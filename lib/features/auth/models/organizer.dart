/// The authenticated organiser, as returned by `/login`.
class Organizer {
  const Organizer({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.organizerCode,
    this.schoolId,
  });

  final String id;
  final String name;
  final String email;
  final String role;

  /// The `user_id` the organiser types on the login screen, e.g. `ORG-1234`.
  final String? organizerCode;
  final String? schoolId;

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      organizerCode: json['user_id']?.toString(),
      schoolId: json['school_id']?.toString(),
    );
  }

  Map<String, String> toStorageMap() => {
        AuthStorageKeys.organizerId: id,
        AuthStorageKeys.organizerName: name,
        AuthStorageKeys.organizerEmail: email,
        AuthStorageKeys.organizerRole: role,
        AuthStorageKeys.organizerCode: organizerCode ?? '',
        AuthStorageKeys.schoolId: schoolId ?? '',
      };
}

/// Keys used for the locally persisted session.
class AuthStorageKeys {
  AuthStorageKeys._();

  static const String accessToken = 'organizer_access_token';
  static const String refreshToken = 'organizer_refresh_token';
  static const String organizerId = 'organizer_id';
  static const String organizerName = 'organizer_name';
  static const String organizerEmail = 'organizer_email';
  static const String organizerRole = 'organizer_role';
  static const String organizerCode = 'organizer_code';
  static const String schoolId = 'organizer_school_id';

  static const List<String> all = [
    accessToken,
    refreshToken,
    organizerId,
    organizerName,
    organizerEmail,
    organizerRole,
    organizerCode,
    schoolId,
  ];
}
