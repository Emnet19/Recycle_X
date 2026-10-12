/// Represents a RecycleX user with role information.
/// The [role] field determines which dashboard/section the user sees after login.
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  /// One of: 'customer', 'collector', 'company', 'admin'
  final String role;

  final bool emailVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      role: map['role'] as String? ?? 'customer',
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      emailVerified: map['emailVerified'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, email: $email, role: $role)';
}
