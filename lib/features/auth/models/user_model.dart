/// Represents a RecycleX user with role information.
/// The [role] field determines which dashboard/section the user sees after login.
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  /// One of: 'customer', 'kebele_collector', 'community_collector', 'company', 'admin'
  final String role;

  final bool emailVerified;
  final DateTime? createdAt;

  /// EcoCoins balance (Requirement 4: 100 upon first registration)
  final int ecoCoins;
  final bool initialCoinsAwarded;

  /// Collector specific metadata (Requirement 3)
  final String? collectorType;
  final String? zoneOrOrganization;

  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.createdAt,
    this.ecoCoins = 100,
    this.initialCoinsAwarded = true,
    this.collectorType,
    this.zoneOrOrganization,
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
      ecoCoins: (map['ecoCoins'] as num?)?.toInt() ?? 100,
      initialCoinsAwarded: map['initialCoinsAwarded'] as bool? ?? true,
      collectorType: map['collectorType'] as String?,
      zoneOrOrganization: map['zoneOrOrganization'] as String?,
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
      'ecoCoins': ecoCoins,
      'initialCoinsAwarded': initialCoinsAwarded,
      if (collectorType != null) 'collectorType': collectorType,
      if (zoneOrOrganization != null) 'zoneOrOrganization': zoneOrOrganization,
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
    int? ecoCoins,
    bool? initialCoinsAwarded,
    String? collectorType,
    String? zoneOrOrganization,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      ecoCoins: ecoCoins ?? this.ecoCoins,
      initialCoinsAwarded: initialCoinsAwarded ?? this.initialCoinsAwarded,
      collectorType: collectorType ?? this.collectorType,
      zoneOrOrganization: zoneOrOrganization ?? this.zoneOrOrganization,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, email: $email, role: $role, ecoCoins: $ecoCoins)';
}
