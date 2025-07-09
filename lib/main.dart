import 'package:bloc_test/features/devices/bloc/device_bloc.dart';
import 'package:bloc_test/features/devices/bloc/device_event.dart';
import 'package:bloc_test/features/devices/presentation/device_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/devices/data/device_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DeviceRepository(),
      child: BlocProvider(
        create: (context) => DeviceBloc(
          RepositoryProvider.of<DeviceRepository>(context),
        )..add(FetchDevicesEvent()),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dio & BLoC Demo',
          home: DevicePage(),
        ),
      ),
    );
  }
}