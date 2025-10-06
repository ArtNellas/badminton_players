class Player {
  final String id;
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final double skillLevelMin;
  final double skillLevelMax;
  final DateTime createdAt;

  Player({
    required this.id,
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.skillLevelMin,
    required this.skillLevelMax,
    required this.createdAt,
  });

  // Convert Player to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'remarks': remarks,
      'skillLevelMin': skillLevelMin,
      'skillLevelMax': skillLevelMax,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Player from Map
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] ?? '',
      nickname: map['nickname'] ?? '',
      fullName: map['fullName'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      remarks: map['remarks'] ?? '',
      skillLevelMin: (map['skillLevelMin'] ?? 0.0).toDouble(),
      skillLevelMax: (map['skillLevelMax'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Create a copy with some fields changed
  Player copyWith({
    String? id,
    String? nickname,
    String? fullName,
    String? contactNumber,
    String? email,
    String? address,
    String? remarks,
    double? skillLevelMin,
    double? skillLevelMax,
    DateTime? createdAt,
  }) {
    return Player(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      remarks: remarks ?? this.remarks,
      skillLevelMin: skillLevelMin ?? this.skillLevelMin,
      skillLevelMax: skillLevelMax ?? this.skillLevelMax,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Player{nickname: $nickname, fullName: $fullName, skillRange: $skillLevelMin-$skillLevelMax}';
  }
}