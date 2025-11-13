import 'package:equatable/equatable.dart';

abstract class ClientEquipmentEvent extends Equatable {
  const ClientEquipmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadClientEquipments extends ClientEquipmentEvent {
  final int clientId;

  const LoadClientEquipments(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class LoadClientEquipmentById extends ClientEquipmentEvent {
  final int id;

  const LoadClientEquipmentById(this.id);

  @override
  List<Object?> get props => [id];
}
