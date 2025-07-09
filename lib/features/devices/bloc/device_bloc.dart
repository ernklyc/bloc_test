import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_event.dart';
import 'device_state.dart';
import '../data/device_repository.dart';
import '../model/device_model.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository _deviceRepository;
  List<Device> _allDevices = [];

  DeviceBloc(this._deviceRepository) : super(DeviceInitial()) {
    on<FetchDevicesEvent>(_onFetchDevices);
    on<AddDeviceEvent>(_onAddDevice);
    on<FilterDevicesEvent>(_onFilterDevices);
  }

  Future<void> _onFetchDevices(
    FetchDevicesEvent event,
    Emitter<DeviceState> emit,
  ) async {
    print("🟢 Event Alındı: FetchDevicesEvent");
    if (!event.isRefreshAfterAdd) {
      print("⏳ Yükleniyor... Emit: DeviceLoading");
      emit(DeviceLoading());
    }

    try {
      print("☁️ Repository'den Cihazlar İsteniyor...");
      _allDevices = await _deviceRepository.getDevices();
      print("✅ Cihazlar Başarıyla Alındı: ${_allDevices.length} adet.");

      if (event.isRefreshAfterAdd) {
        print("🎉 Başarılı (Ekleme Sonrası)! Emit: DeviceSuccess with SnackBar message");
        emit(DeviceSuccess(_allDevices, snackBarMessage: "Yeni cihaz başarıyla listeye eklendi!"));
      } else {
        print("🎉 Başarılı! Emit: DeviceSuccess");
        emit(DeviceSuccess(_allDevices));
      }
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
      await _deviceRepository.addDevice(event.newDevice);
      print("✅ POST Yanıtı Başarıyla Alındı");

      print("🔄 Liste güncelleniyor... Yeni Event Tetikleniyor: FetchDevicesEvent");
      add(FetchDevicesEvent(isRefreshAfterAdd: true));

    } catch (e) {
      print("🔴 HATA: Cihaz eklenemedi: $e");
      print("🔥 Hata! Emit: DeviceError");
      emit(DeviceError("Cihaz eklenemedi: ${e.toString()}"));
    }
  }

  void _onFilterDevices(
    FilterDevicesEvent event,
    Emitter<DeviceState> emit,
  ) {
    print("🟢 Event Alındı: FilterDevicesEvent");

    List<Device> filteredDevices = List.from(_allDevices);

    if (event.id != null && event.id!.isNotEmpty) {
      filteredDevices = filteredDevices.where((device) => device.id == event.id).toList();
    }

    if (event.name != null && event.name!.isNotEmpty) {
      filteredDevices = filteredDevices
          .where((device) =>
              device.name.toLowerCase().contains(event.name!.toLowerCase()))
          .toList();
    }

    emit(DeviceSuccess(filteredDevices));
  }
}