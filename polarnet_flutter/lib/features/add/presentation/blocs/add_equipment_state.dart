import 'package:equatable/equatable.dart';

enum AddEquipmentStatus { initial, loading, success, failure }

class AddEquipmentState extends Equatable {
  final AddEquipmentStatus status;
  final String? successMessage;
  final String? errorMessage;

  const AddEquipmentState({
    this.status = AddEquipmentStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  AddEquipmentState copyWith({
    AddEquipmentStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return AddEquipmentState(
      status: status ?? this.status,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
