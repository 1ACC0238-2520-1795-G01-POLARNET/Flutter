import 'package:equatable/equatable.dart';

abstract class IoTEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadIoTData extends IoTEvent {
  final int equipmentId;
  LoadIoTData(this.equipmentId);

  @override
  List<Object?> get props => [equipmentId];
}

class RefreshIoTData extends IoTEvent {
  final int equipmentId;
  RefreshIoTData(this.equipmentId);

  @override
  List<Object?> get props => [equipmentId];
}

class StartAutoRefresh extends IoTEvent {
  final int equipmentId;
  final Duration interval;

  StartAutoRefresh(
    this.equipmentId, {
    this.interval = const Duration(seconds: 5),
  });

  @override
  List<Object?> get props => [equipmentId, interval];
}

class StopAutoRefresh extends IoTEvent {}
