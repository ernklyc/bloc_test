import 'package:bloc_test/features/devices/model/device_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_event.dart';
import 'device_state.dart';
import '../data/device_repository.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository _deviceRepository;

  DeviceBloc(this._deviceRepository) : super(DeviceInitial()) {
    on<FetchDevicesEvent>(_onFetchDevices);
    on<AddDeviceEvent>(_onAddDevice);
  }

  Future<void> _onFetchDevices(
    FetchDevicesEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());
    try {
      final devices = await _deviceRepository.getDevices();
      emit(DeviceSuccess(devices));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onAddDevice(
    AddDeviceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    final currentState = state;
    if (currentState is DeviceSuccess) {
      try {
        print("➡️ POST İsteği Gönderiliyor: ${event.newDevice.toJsonForCreation()}");
        
        final newDeviceFromApi = await _deviceRepository.addDevice(event.newDevice);
        print("✅ POST Yanıtı Alındı: ${newDeviceFromApi.toString()}");

        final updatedList = List<Device>.from(currentState.devices)
          ..add(newDeviceFromApi);
        
        emit(DeviceSuccess(updatedList));

      } catch (e) {
        print("🔴 HATA: Cihaz eklenemedi: $e");
        emit(DeviceError("Cihaz eklenemedi: ${e.toString()}"));
      }
    }
  }
}