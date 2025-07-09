import 'package:equatable/equatable.dart';
import '../model/device_model.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class FetchDevicesEvent extends DeviceEvent {}

class AddDeviceEvent extends DeviceEvent {
  final Device newDevice;

  const AddDeviceEvent(this.newDevice);

  @override
  List<Object> get props => [newDevice];
}