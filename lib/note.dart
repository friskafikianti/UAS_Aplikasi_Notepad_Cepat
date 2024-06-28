import 'package:flutter/material.dart';
import 'dart:io';

class Note {
  String title;
  String content;
  String date;
  Color color;
  File? image;
  bool isCompleted;

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.color,
    this.image,
    this.isCompleted = false,
  });
}