import 'package:equatable/equatable.dart';
import '../../domain/models/client_equipment.dart';

enum ClientEquipmentStatus { initial, loading, success, failure }

class ClientEquipmentState extends Equatable {
  final ClientEquipmentStatus status;
  final List<ClientEquipment> equipments;
  final String? error;

  const ClientEquipmentState({
    this.status = ClientEquipmentStatus.initial,
    this.equipments = const [],
    this.error,
  });

  ClientEquipmentState copyWith({
    ClientEquipmentStatus? status,
    List<ClientEquipment>? equipments,
    String? error,
  }) {
    return ClientEquipmentState(
      status: status ?? this.status,
      equipments: equipments ?? this.equipments,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, equipments, error];
}
