import 'dart:convert';

class CompanyData {
  final String id;
  final String name;
  final String createdOn;
  final String members;
  CompanyData({
    required this.id,
    required this.name,
    required this.createdOn,
    required this.members,
  });

  CompanyData copyWith({
    String? id,
    String? name,
    String? createdOn,
    String? members,
  }) {
    return CompanyData(
      id: id ?? this.id,
      name: name ?? this.name,
      createdOn: createdOn ?? this.createdOn,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdOn': createdOn,
      'members': members,
    };
  }

  factory CompanyData.fromMap(Map<String, dynamic> map) {
    return CompanyData(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdOn: map['createdOn'] ?? '',
      members: map['members'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyData.fromJson(String source) => CompanyData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompanyData(id: $id, name: $name, createdOn: $createdOn, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CompanyData &&
      other.id == id &&
      other.name == name &&
      other.createdOn == createdOn &&
      other.members == members;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      createdOn.hashCode ^
      members.hashCode;
  }
}

class CompanyDataModel{
  static List<CompanyData> companyDataList = [];
}
