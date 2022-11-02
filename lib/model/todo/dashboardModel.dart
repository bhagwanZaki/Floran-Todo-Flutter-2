// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DashboardModel {
  List<int> cdate;
  List<int> cdata;
  int numberOfTaskDone;
  DashboardModel({
    required this.cdate,
    required this.cdata,
    required this.numberOfTaskDone,
  });

  DashboardModel copyWith({
    List<int>? cdate,
    List<int>? cdata,
    int? numberOfTaskDone,
  }) {
    return DashboardModel(
      cdate: cdate ?? this.cdate,
      cdata: cdata ?? this.cdata,
      numberOfTaskDone: numberOfTaskDone ?? this.numberOfTaskDone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cdate': cdate,
      'cdata': cdata,
      'numberOfTaskDone': numberOfTaskDone,
    };
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      cdate: List<int>.from((map['cdate'])),
      cdata: List<int>.from((map['cdata'])),
      numberOfTaskDone: map['numberOfTaskDone'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardModel.fromJson(String source) => DashboardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DashboardModel(cdate: $cdate, cdata: $cdata, numberOfTaskDone: $numberOfTaskDone)';

  @override
  bool operator ==(covariant DashboardModel other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.cdate, cdate) &&
      listEquals(other.cdata, cdata) &&
      other.numberOfTaskDone == numberOfTaskDone;
  }

  @override
  int get hashCode => cdate.hashCode ^ cdata.hashCode ^ numberOfTaskDone.hashCode;
}
