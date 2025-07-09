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
    try {
      print("➡️ POST İsteği Gönderiliyor: ${event.newDevice.toJsonForCreation()}");
      final newDeviceFromApi = await _deviceRepository.addDevice(event.newDevice);
      print("✅ POST Yanıtı Alındı: ${newDeviceFromApi.toString()}");

      print("🔄 POST başarılı, sunucudan güncel liste isteniyor...");
      add(FetchDevicesEvent());

    } catch (e) {
      print("🔴 HATA: Cihaz eklenemedi: $e");
      emit(DeviceError("Cihaz eklenemedi: ${e.toString()}"));
    }
  }
}