import 'package:equatable/equatable.dart';

abstract class EquipmentEvent extends Equatable {
  const EquipmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadEquipments extends EquipmentEvent {
  const LoadEquipments();
}