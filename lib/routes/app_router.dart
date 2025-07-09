import 'package:bloc_test/features/devices/presentation/device_page.dart';
import 'package:bloc_test/features/devices/presentation/favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/device',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.devices),
                label: 'Cihazlar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoriler',
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/device',
              builder: (context, state) => const DevicePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorite',
              builder: (context, state) => const FavoritePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);