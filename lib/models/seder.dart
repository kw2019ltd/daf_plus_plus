import 'package:flutter/material.dart';

class SederModel {
  const SederModel({
    @required this.id,
    @required this.name,
    @required this.translatedName,
  });

  final int id;
  final String name;
  final String translatedName;
}
