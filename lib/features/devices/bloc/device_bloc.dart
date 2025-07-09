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
    print("🟢 Event Alındı: FetchDevicesEvent");

    print("⏳ Yükleniyor... Emit: DeviceLoading");
    emit(DeviceLoading());

    try {
      print("☁️ Repository'den Cihazlar İsteniyor...");
      final devices = await _deviceRepository.getDevices();
      print("✅ Cihazlar Başarıyla Alındı: ${devices.length} adet.");

      print("🎉 Başarılı! Emit: DeviceSuccess");
      emit(DeviceSuccess(devices));
    } catch (e) {
      print("🔴 HATA: Cihazlar alınamadı: $e");
      print("🔥 Hata! Emit: DeviceError");
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onAddDevice(
    AddDeviceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    print("\n🟢 Event Alındı: AddDeviceEvent");

    try {
      print("➡️ POST İsteği Gönderiliyor: ${event.newDevice.toJsonForCreation()}");
      final newDeviceFromApi = await _deviceRepository.addDevice(event.newDevice);
      print("✅ POST Yanıtı Başarıyla Alındı: ${newDeviceFromApi.toString()}");

      print("🔄 Liste güncelleniyor... Yeni Event Tetikleniyor: FetchDevicesEvent");
      add(FetchDevicesEvent());

    } catch (e) {
      print("🔴 HATA: Cihaz eklenemedi: $e");
      print("🔥 Hata! Emit: DeviceError");
      emit(DeviceError("Cihaz eklenemedi: ${e.toString()}"));
    }
  }
}