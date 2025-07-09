import 'package:bloc_test/features/devices/bloc/device_bloc.dart';
import 'package:bloc_test/features/devices/bloc/device_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FilterControls extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController nameController;

  const FilterControls({
    super.key,
    required this.idController,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID ile Filtrele',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'İsim ile Filtrele',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus(); 
              
              context.read<DeviceBloc>().add(FilterDevicesEvent(
                    id: idController.text,
                    name: nameController.text,
                  ));
            },
            child: const Text('Filtrele'),
          ),
        ],
      ),
    );
  }
}