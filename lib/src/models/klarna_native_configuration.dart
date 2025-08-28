import 'package:flutter/material.dart';

class KlarnaNativeConfiguration {
  final String redirectUrl;
  final String clientToken;
  final String paymentData;
  final String category;
  final String environment; 
  final Widget? initializationWidget;
  final Widget? processingWidget;
  final double bottomSheetMaxHeightRatio;
  const KlarnaNativeConfiguration({
    required this.redirectUrl,
    required this.clientToken,
    required this.paymentData,
    required this.category,
    required this.environment,
    this.initializationWidget,
    this.processingWidget,
    this.bottomSheetMaxHeightRatio = 0.6,
  });
}