import 'dart:convert';

import 'package:flutter/foundation.dart';

class CompanyDocuments {
  final String category;
  final String docType;
  final String type;
  final String financialYear;
  final int point;
  final int month;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String uploadedBy;
  final List<FolderData> folder;
  CompanyDocuments({
    required this.category,
    required this.docType,
    required this.type,
    required this.financialYear,
    required this.point,
    required this.month,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.uploadedBy,
    required this.folder,
  });
  

  CompanyDocuments copyWith({
    String? category,
    String? docType,
    String? type,
    String? financialYear,
    int? point,
    int? month,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? uploadedBy,
    List<FolderData>? folder,
  }) {
    return CompanyDocuments(
      category: category ?? this.category,
      docType: docType ?? this.docType,
      type: type ?? this.type,
      financialYear: financialYear ?? this.financialYear,
      point: point ?? this.point,
      month: month ?? this.month,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      folder: folder ?? this.folder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'docType': docType,
      'type': type,
      'financialYear': financialYear,
      'point': point,
      'month': month,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'uploadedBy': uploadedBy,
      'folder': folder.map((x) => x.toMap()).toList(),
    };
  }

  factory CompanyDocuments.fromMap(Map<String, dynamic> map) {
    return CompanyDocuments(
      category: map['category'] ?? '',
      docType: map['docType'] ?? '',
      type: map['type'] ?? '',
      financialYear: map['financialYear'] ?? '',
      point: map['point']?.toInt() ?? 0,
      month: map['month']?.toInt() ?? 0,
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      folder: List<FolderData>.from(map['folder']?.map((x) => FolderData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyDocuments.fromJson(String source) => CompanyDocuments.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompanyDocuments(category: $category, docType: $docType, type: $type, financialYear: $financialYear, point: $point, month: $month, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, uploadedBy: $uploadedBy, folder: $folder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CompanyDocuments &&
      other.category == category &&
      other.docType == docType &&
      other.type == type &&
      other.financialYear == financialYear &&
      other.point == point &&
      other.month == month &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.uploadedBy == uploadedBy &&
      listEquals(other.folder, folder);
  }

  @override
  int get hashCode {
    return category.hashCode ^
      docType.hashCode ^
      type.hashCode ^
      financialYear.hashCode ^
      point.hashCode ^
      month.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      uploadedBy.hashCode ^
      folder.hashCode;
  }
}

class FolderData {
  final String id;
  final String file;
  final String preview;
  FolderData({
    required this.id,
    required this.file,
    required this.preview,
  });

  FolderData copyWith({
    String? id,
    String? file,
    String? preview,
  }) {
    return FolderData(
      id: id ?? this.id,
      file: file ?? this.file,
      preview: preview ?? this.preview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file': file,
      'preview': preview,
    };
  }

  factory FolderData.fromMap(Map<String, dynamic> map) {
    return FolderData(
      id: map['_id'] ?? '',
      file: map['file'] ?? '',
      preview: map['preview'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FolderData.fromJson(String source) => FolderData.fromMap(json.decode(source));

  @override
  String toString() => 'FolderData(id: $id, file: $file, preview: $preview)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FolderData &&
      other.id == id &&
      other.file == file &&
      other.preview == preview;
  }

  @override
  int get hashCode => id.hashCode ^ file.hashCode ^ preview.hashCode;
}
