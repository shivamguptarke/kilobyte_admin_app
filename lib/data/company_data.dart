import 'dart:convert';

import 'package:flutter/foundation.dart';

class CompanyData {
  final String id;
  final String name;
  final String companyName;
  final String members;
  final List<String> communicationEmails;
  final List<String> documentsActivated;
  final String email;
  final String preferences;
  final String clientID;
  final String updatedAt;
  final bool deleted;
  final String deletedAt;
  CompanyData({
    required this.id,
    required this.name,
    required this.companyName,
    required this.members,
    required this.communicationEmails,
    required this.documentsActivated,
    required this.email,
    required this.preferences,
    required this.clientID,
    required this.updatedAt,
    required this.deleted,
    required this.deletedAt,
  });

  CompanyData copyWith({
    String? id,
    String? name,
    String? companyName,
    String? members,
    List<String>? communicationEmails,
    List<String>? documentsActivated,
    String? email,
    String? preferences,
    String? clientID,
    String? updatedAt,
    bool? deleted,
    String? deletedAt,
  }) {
    return CompanyData(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      members: members ?? this.members,
      communicationEmails: communicationEmails ?? this.communicationEmails,
      documentsActivated: documentsActivated ?? this.documentsActivated,
      email: email ?? this.email,
      preferences: preferences ?? this.preferences,
      clientID: clientID ?? this.clientID,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'members': members,
      'communicationEmails': communicationEmails,
      'documentsActivated': documentsActivated,
      'email': email,
      'preferences': preferences,
      'clientID': clientID,
      'updatedAt': updatedAt,
      'deleted': deleted,
      'deletedAt': deletedAt,
    };
  }

  factory CompanyData.fromMap(Map<String, dynamic> map) {
    return CompanyData(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      companyName: map['companyName'] ?? '',
      members: map['members'] ?? '',
      communicationEmails: List<String>.from(map['communicationEmails']),
      documentsActivated: List<String>.from(map['documentsActivated']),
      email: map['email'] ?? '',
      preferences: map['preferences'] ?? '',
      clientID: map['clientID'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      deleted: map['deleted'] ?? false,
      deletedAt: map['deletedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyData.fromJson(String source) => CompanyData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompanyData(id: $id, name: $name, companyName: $companyName, members: $members, communicationEmails: $communicationEmails, documentsActivated: $documentsActivated, email: $email, preferences: $preferences, clientID: $clientID, updatedAt: $updatedAt, deleted: $deleted, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CompanyData &&
      other.id == id &&
      other.name == name &&
      other.companyName == companyName &&
      other.members == members &&
      listEquals(other.communicationEmails, communicationEmails) &&
      listEquals(other.documentsActivated, documentsActivated) &&
      other.email == email &&
      other.preferences == preferences &&
      other.clientID == clientID &&
      other.updatedAt == updatedAt &&
      other.deleted == deleted &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      companyName.hashCode ^
      members.hashCode ^
      communicationEmails.hashCode ^
      documentsActivated.hashCode ^
      email.hashCode ^
      preferences.hashCode ^
      clientID.hashCode ^
      updatedAt.hashCode ^
      deleted.hashCode ^
      deletedAt.hashCode;
  }
  }

class CompanyDataModel{
  static List<CompanyData> companyDataList = [];
}
