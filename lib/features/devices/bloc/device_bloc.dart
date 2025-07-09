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

  Future<void> _onFetchDevices(FetchDevicesEvent event, Emitter<DeviceState> emit) async {
    print("-> 🔴🔵 FetchDevicesEvent alındı, cihazlar çekiliyor...");
    emit(DeviceLoading());
    try {
      final devices = await _deviceRepository.getDevices();
      print("-> 🟢🟢 GET isteği başarılı. Toplam ${devices.length} cihaz alındı.");
      emit(DeviceSuccess(devices));
    } catch (e) {
      print("-> 🔴🔴 HATA: Cihazlar çekilemedi: $e");
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onAddDevice(AddDeviceEvent event, Emitter<DeviceState> emit) async {
    print("-> 🟢🟢 AddDeviceEvent alındı, yeni cihaz ekleniyor...");
    try {
      await _deviceRepository.addDevice(event.newDevice);
      print("-> 🟢🟢 POST isteği BAŞARILI. Şimdi liste yenilenecek.");
      add(FetchDevicesEvent());

    } catch (e) {
      print("-> 🔴🔴 HATA: Cihaz eklenemedi: $e");
      emit(DeviceError("Cihaz eklenemedi: ${e.toString()}"));

    }
  }
}