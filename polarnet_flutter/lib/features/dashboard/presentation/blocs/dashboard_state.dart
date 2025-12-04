import 'package:equatable/equatable.dart';
import 'package:polarnet_flutter/features/dashboard/domain/models/iot_sensor.dart';

abstract class IoTState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IoTInitial extends IoTState {}

class IoTLoading extends IoTState {}

class IoTLoaded extends IoTState {
  final List<IoTSensor> sensors;
  IoTLoaded(this.sensors);
  @override
  List<Object?> get props => [sensors];
}

class IoTError extends IoTState {
  final String message;
  IoTError(this.message);
}
