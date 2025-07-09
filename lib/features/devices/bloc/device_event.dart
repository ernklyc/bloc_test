// lib/features/devices/bloc/device_event.dart
import 'package:equatable/equatable.dart';
import '../model/device_model.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

class FetchDevicesEvent extends DeviceEvent {
  final bool isRefreshAfterAdd;

  const FetchDevicesEvent({this.isRefreshAfterAdd = false});

  @override
  List<Object> get props => [isRefreshAfterAdd];
}

class AddDeviceEvent extends DeviceEvent {
  final Device newDevice;

  const AddDeviceEvent(this.newDevice);

  @override
  List<Object> get props => [newDevice];
}

class FilterDevicesEvent extends DeviceEvent {
  final String? id;
  final String? name;

  const FilterDevicesEvent({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}