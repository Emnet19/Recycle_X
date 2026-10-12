/// Customer-specific profile data.
/// The general [UserModel] in features/auth/models holds uid/email/role.
/// This model holds customer-specific stats and preferences.
class CustomerModel {
  final String uid;
  final String displayName;
  final String? photoUrl;
  final String? phone;
  final String? address;
  final double ecoCoins;
  final int totalPickups;
  final double totalRecycledKg;
  final String? level; // e.g. "Level 4 Recycler"

  const CustomerModel({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    this.phone,
    this.address,
    this.ecoCoins = 0,
    this.totalPickups = 0,
    this.totalRecycledKg = 0,
    this.level,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      uid: map['uid'] as String,
      displayName: map['displayName'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      ecoCoins: (map['ecoCoins'] as num?)?.toDouble() ?? 0,
      totalPickups: map['totalPickups'] as int? ?? 0,
      totalRecycledKg:
          (map['totalRecycledKg'] as num?)?.toDouble() ?? 0,
      level: map['level'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        'ecoCoins': ecoCoins,
        'totalPickups': totalPickups,
        'totalRecycledKg': totalRecycledKg,
        if (level != null) 'level': level,
      };

  CustomerModel copyWith({
    String? displayName,
    String? photoUrl,
    String? phone,
    String? address,
    double? ecoCoins,
    int? totalPickups,
    double? totalRecycledKg,
    String? level,
  }) {
    return CustomerModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      ecoCoins: ecoCoins ?? this.ecoCoins,
      totalPickups: totalPickups ?? this.totalPickups,
      totalRecycledKg: totalRecycledKg ?? this.totalRecycledKg,
      level: level ?? this.level,
    );
  }
}
