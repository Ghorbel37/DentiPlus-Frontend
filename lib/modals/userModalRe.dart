// lib/models/user.dart
import 'enums.dart';
import 'doctorModal.dart';
import 'patientModal.dart';

class UserRe {
  final int? id;
  final String? adress;
  final DateTime? birthdate;
  final String? email;
  final String? name;
  final String? password;
  final String? phoneNumber;
  final String? role;
  final bool? disabled;
  final Doctor? doctor;  // May be null if the user is not a doctor
  final Patient? patient; // May be null if the user is not a patient

  UserRe({
    this.id,
    this.adress,
    this.birthdate,
    this.email,
    this.name,
    this.password,
    this.phoneNumber,
    this.role,
    this.disabled,
    this.doctor,
    this.patient,
  });

  factory UserRe.fromJson(Map<String, dynamic> json) {
    return UserRe(
      id: json['id'] as int?,
      // Note: Check for field name differences here ('adress' vs 'address')
      adress: json['adress'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'])
          : null,
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      disabled: json['disabled'] as bool? ?? false,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'])
          : null,
      patient: json['patient'] != null
          ? Patient.fromJson(json['patient'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // Note: Sending 'adress' as key, matching the backend naming.
      'adress': adress,
      'birthdate': birthdate?.toIso8601String(),
      'email': email,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'disabled': disabled,
      'doctor': doctor?.toJson(),
      'patient': patient?.toJson(),
    };
  }
}
