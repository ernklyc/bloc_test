import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String id;
  final String name;
  final Map<String, dynamic>? data;
  final String? createdAt;

  const Device({
    required this.id,
    required this.name,
    this.data,
    this.createdAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      name: json['name'] as String,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJsonForCreation() {
    return {
      'name': name,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'Device(id: $id, name: $name, data: $data, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props => [id, name, data, createdAt];
}