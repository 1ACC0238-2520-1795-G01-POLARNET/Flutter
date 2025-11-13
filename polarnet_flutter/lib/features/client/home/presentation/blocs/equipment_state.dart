import 'package:equatable/equatable.dart';
import '../../../../../shared/domain/models/equipment.dart';

enum EquipmentStatus { initial, loading, success, failure }

class EquipmentState extends Equatable {
  final EquipmentStatus status;
  final List<Equipment> equipments;
  final String? error;

  const EquipmentState({
    this.status = EquipmentStatus.initial,
    this.equipments = const [],
    this.error,
  });

  EquipmentState copyWith({
    EquipmentStatus? status,
    List<Equipment>? equipments,
    String? error,
  }) {
    return EquipmentState(
      status: status ?? this.status,
      equipments: equipments ?? this.equipments,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, equipments, error];
}
