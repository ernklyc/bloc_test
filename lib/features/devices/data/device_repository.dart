import 'package:dio/dio.dart';
import '../model/device_model.dart';

class DeviceRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.restful-api.dev', 
  ));
  
  Future<List<Device>> getDevices() async {
    try {
      final response = await _dio.get('/objects');
      final List<Device> devices = (response.data as List)
          .map((item) => Device.fromJson(item))
          .toList();
      return devices;
    } on DioException catch (e) {
      throw Exception('Cihazlar yüklenemedi: ${e.message}');
    }
  }

  Future<Device> addDevice(Device device) async {
    try {
      final response = await _dio.post(
        '/objects',
        data: device.toJsonForCreation(),
      );
      return Device.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Cihaz eklenemedi: ${e.message}');
    }
  }
}