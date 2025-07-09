import 'package:bloc_test/features/devices/model/device_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';
import 'package:bloc_test/components/product_filter.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices (GET & POST)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _idController.clear();
              _nameController.clear();
              context.read<DeviceBloc>().add(const FetchDevicesEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterControls(
            idController: _idController,
            nameController: _nameController,
          ),
          Expanded(
            child: BlocConsumer<DeviceBloc, DeviceState>(
              listenWhen: (previous, current) {
                return current is DeviceSuccess && current.snackBarMessage != null;
              },
              listener: (context, state) {
                if (state is DeviceSuccess && state.snackBarMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.snackBarMessage!),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is DeviceLoading || state is DeviceInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DeviceSuccess) {
                  if (state.devices.isEmpty) {
                    return const Center(child: Text('Gösterilecek cihaz bulunamadı.'));
                  }
                  return ListView.builder(
                    itemCount: state.devices.length,
                    itemBuilder: (context, index) {
                      final device = state.devices[index];
                      String formatData(Map<String, dynamic>? data) {
                        if (data == null || data.isEmpty) return 'Ek bilgi yok';
                        return data.entries.map((e) => '${e.key}: ${e.value}').join('\n');
                      }
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            final selectedDeviceForPost = Device(
                              id: '',
                              name: device.name,
                              data: device.data,
                            );
                            context.read<DeviceBloc>().add(AddDeviceEvent(selectedDeviceForPost));
                          },
                          child: ListTile(
                            leading: CircleAvatar(child: Text(device.id)),
                            title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(formatData(device.data)),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  );
                }
                 if (state is DeviceError) {
                  return Center(child: Text('Hata oluştu: ${state.message}'));
                }
                return const Center(child: Text('Bilinmeyen bir durum oluştu.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}