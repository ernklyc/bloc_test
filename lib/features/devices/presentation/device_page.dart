import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';
import '../model/device_model.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cihazlar (BLoC)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DeviceBloc>().add(FetchDevicesEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is DeviceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DeviceSuccess) {
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
                  child: ListTile(
                    leading: CircleAvatar(child: Text(device.id)),
                    title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(formatData(device.data)),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Başlamak için yenile butonuna basın.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final colorController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Yeni Cihaz Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Cihaz Adı')),
              TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Renk')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Fiyat'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newDevice = Device(
                  id: '', // ID sunucu tarafından atanacak, boş bırakıyoruz.
                  name: nameController.text,
                  data: {
                    'color': colorController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'source': 'Flutter App'
                  },
                );
                context.read<DeviceBloc>().add(AddDeviceEvent(newDevice));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}