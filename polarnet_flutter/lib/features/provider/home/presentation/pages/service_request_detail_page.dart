import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_bloc.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_event.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_state.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/detail/status_card.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/detail/client_info_card.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/detail/equipment_info_card.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/detail/request_details_card.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/detail/additional_info_card.dart';

class ServiceRequestDetailPage extends StatefulWidget {
  final ProviderServiceRequest serviceRequest;

  const ServiceRequestDetailPage({
    super.key,
    required this.serviceRequest,
  });

  @override
  State<ServiceRequestDetailPage> createState() =>
      _ServiceRequestDetailPageState();
}

class _ServiceRequestDetailPageState extends State<ServiceRequestDetailPage> {
  bool _showAcceptDialog = false;
  bool _showRejectDialog = false;

  @override
  Widget build(BuildContext context) {
    final isPending = widget.serviceRequest.status.toLowerCase() == 'pending';

    return BlocConsumer<ProviderHomeBloc, ProviderHomeState>(
      listener: (context, state) {
        if (state is ProviderHomeActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is ProviderHomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProviderHomeLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalle de Solicitud'),
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          bottomNavigationBar: isPending && !isLoading
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _showRejectDialog = true);
                          },
                          icon: const Icon(Icons.close, size: 20),
                          label: const Text('Rechazar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _showAcceptDialog = true);
                          },
                          icon: const Icon(Icons.check, size: 20),
                          label: const Text('Aceptar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E37),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusCard(serviceRequest: widget.serviceRequest),
                    const SizedBox(height: 16),
                    ClientInfoCard(serviceRequest: widget.serviceRequest),
                    const SizedBox(height: 16),
                    EquipmentInfoCard(serviceRequest: widget.serviceRequest),
                    const SizedBox(height: 16),
                    RequestDetailsCard(serviceRequest: widget.serviceRequest),
                    const SizedBox(height: 16),
                    AdditionalInfoCard(serviceRequest: widget.serviceRequest),
                  ],
                ),
              ),

              // Diálogo de aceptar
              if (_showAcceptDialog)
                _buildAcceptDialog(context),

              // Diálogo de rechazar
              if (_showRejectDialog)
                _buildRejectDialog(context),

              // Loading overlay
              if (isLoading)
                Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAcceptDialog(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.check_circle,
        color: Color(0xFF1B5E37),
        size: 32,
      ),
      title: const Text(
        '¿Aceptar Solicitud?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'La solicitud será marcada como completada y el equipo quedará asignado al cliente.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _showAcceptDialog = false);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ProviderHomeBloc>().add(
                  UpdateServiceRequestStatus(
                    id: widget.serviceRequest.id,
                    status: 'completed',
                  ),
                );
            setState(() => _showAcceptDialog = false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E37),
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }

  Widget _buildRejectDialog(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.cancel,
        color: Colors.red,
        size: 32,
      ),
      title: const Text(
        '¿Rechazar Solicitud?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'La solicitud será eliminada permanentemente. Esta acción no se puede deshacer.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _showRejectDialog = false);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ProviderHomeBloc>().add(
                  DeleteServiceRequest(widget.serviceRequest.id),
                );
            setState(() => _showRejectDialog = false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }
}
