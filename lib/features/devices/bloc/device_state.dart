import 'package:equatable/equatable.dart';
import '../model/device_model.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceSuccess extends DeviceState {
  final List<Device> devices;
  final String? snackBarMessage;

  const DeviceSuccess(this.devices, {this.snackBarMessage});

  @override
  List<Object?> get props => [devices, snackBarMessage];
}

class DeviceError extends DeviceState {
  final String message;

  const DeviceError(this.message);

  @override
  List<Object> get props => [message];
}