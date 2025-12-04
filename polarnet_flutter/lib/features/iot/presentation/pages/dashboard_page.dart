import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';
import 'package:polarnet_flutter/features/iot/domain/models/iot_sensor.dart';
import 'package:polarnet_flutter/features/iot/presentation/blocs/dashboard_bloc.dart';
import 'package:polarnet_flutter/features/iot/presentation/blocs/dashboard_event.dart';
import 'package:polarnet_flutter/features/iot/presentation/blocs/dashboard_state.dart';

class IoTDashboardPage extends StatefulWidget {
  final int equipmentId;
  final String equipmentName;

  const IoTDashboardPage({
    super.key,
    required this.equipmentId,
    required this.equipmentName,
  });

  @override
  State<IoTDashboardPage> createState() => _IoTDashboardPageState();
}

class _IoTDashboardPageState extends State<IoTDashboardPage> {
  bool _isAutoRefreshEnabled = true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<IoTBloc>();
    bloc.add(LoadIoTData(widget.equipmentId));
    // Iniciar auto-refresh cada 3 segundos
    bloc.add(
      StartAutoRefresh(
        widget.equipmentId,
        interval: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    // Detener auto-refresh al salir
    context.read<IoTBloc>().add(StopAutoRefresh());
    super.dispose();
  }

  void _toggleAutoRefresh() {
    setState(() {
      _isAutoRefreshEnabled = !_isAutoRefreshEnabled;
    });

    final bloc = context.read<IoTBloc>();
    if (_isAutoRefreshEnabled) {
      bloc.add(
        StartAutoRefresh(
          widget.equipmentId,
          interval: const Duration(seconds: 3),
        ),
      );
    } else {
      bloc.add(StopAutoRefresh());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Monitoreo en Tiempo Real',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                if (_isAutoRefreshEnabled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Text(
              widget.equipmentName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // Botón para activar/desactivar auto-refresh
          IconButton(
            icon: Icon(
              _isAutoRefreshEnabled ? Icons.pause_circle : Icons.play_circle,
              color: _isAutoRefreshEnabled ? Colors.orange : Colors.green,
            ),
            tooltip: _isAutoRefreshEnabled
                ? 'Pausar actualización'
                : 'Reanudar actualización',
            onPressed: _toggleAutoRefresh,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar ahora',
            onPressed: () =>
                context.read<IoTBloc>().add(LoadIoTData(widget.equipmentId)),
          ),
        ],
      ),
      body: BlocBuilder<IoTBloc, IoTState>(
        builder: (context, state) {
          if (state is IoTLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is IoTLoaded) {
            if (state.sensors.isEmpty) {
              return const Center(
                child: Text("Este equipo no tiene sensores instalados."),
              );
            }
            return _buildDashboard(state.sensors);
          }
          if (state is IoTError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(List<IoTSensor> sensors) {
    final tempSensor = sensors.firstWhere(
      (s) => s.type == IoTSensorType.temperature,
      orElse: () => sensors.first,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Resumen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Hoy ${DateFormat('MMM d').format(DateTime.now())}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.thermostat, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      tempSensor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: tempSensor.readings.isNotEmpty
                      ? LineChart(_buildChartData(tempSensor))
                      : const Center(child: Text("Sin datos recientes")),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Estado de Sensores',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: sensors.length,
            itemBuilder: (context, index) {
              return _SensorCard(sensor: sensors[index]);
            },
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(IoTSensor sensor) {
    final readings = sensor.readings.reversed.toList();

    List<FlSpot> spots = [];
    for (int i = 0; i < readings.length; i++) {
      spots.add(FlSpot(i.toDouble(), readings[i].value));
    }

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minY: (spots.map((e) => e.y).reduce((a, b) => a < b ? a : b)) - 5,
      maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b)) + 5,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}

class _SensorCard extends StatelessWidget {
  final IoTSensor sensor;

  const _SensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final reading = sensor.latestReading;
    final hasData = reading != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getIconForType(sensor.type, code: sensor.code),
              if (hasData)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: reading.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasData ? _formatReading(sensor, reading) : "--",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: hasData && reading.status == IoTStatus.critical
                      ? Colors.red
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sensor.name,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatReading(IoTSensor sensor, IoTReading reading) {
    // Para el sensor de puerta, mostrar solo el estado
    if (sensor.type == IoTSensorType.doorStatus) {
      return reading.unit; // "Abierta" o "Cerrada"
    }
    // Para otros sensores, mostrar valor + unidad
    return "${reading.value} ${reading.unit}";
  }

  Widget _getIconForType(IoTSensorType type, {String? code}) {
    IconData icon;
    Color color;

    switch (type) {
      case IoTSensorType.temperature:
        icon = Icons.thermostat;
        color = Colors.orange;
        break;
      case IoTSensorType.humidity:
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case IoTSensorType.doorStatus:
        icon = Icons.door_front_door;
        color = Colors.purple;
        break;
      default:
        // Detectar tipo de sensor por código
        if (code != null && code.toUpperCase().contains('VOLT')) {
          icon = Icons.electrical_services;
          color = Colors.amber;
        } else if (code != null && code.toUpperCase().contains('CURR')) {
          icon = Icons.bolt;
          color = Colors.yellow.shade700;
        } else {
          icon = Icons.sensors;
          color = Colors.grey;
        }
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
