import 'package:flutter/material.dart';

class AppColors {
  // Core Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF111827);
  static const Color accent = Color(0xFF6366F1);
  static const Color border = Color(0xFFE5E7EB);
  static const Color secondaryText = Color(0xFF6B7280);

  // Status Colors
  static const Color statusApplied = Color(0xFF93C5FD);
  static const Color statusShortlisted = Color(0xFFC4B5FD);
  static const Color statusInterview = Color(0xFFFCD34D);
  static const Color statusSelected = Color(0xFF6EE7B7);
  static const Color statusRejected = Color(0xFFFCA5A5);

  static Color getStatusColor(String status) {
    switch (status) {
      case 'Applied': return statusApplied;
      case 'Shortlisted': return statusShortlisted;
      case 'Interview Scheduled': return statusInterview;
      case 'Selected': return statusSelected;
      case 'Rejected': return statusRejected;
      default: return border;
    }
  }

  static Color getStatusTextColor(String status) {
    switch (status) {
      case 'Applied': return const Color(0xFF1E3A8A); // Darker blue
      case 'Shortlisted': return const Color(0xFF4C1D95); // Darker purple
      case 'Interview Scheduled': return const Color(0xFF78350F); // Darker amber/brown
      case 'Selected': return const Color(0xFF064E3B); // Darker green
      case 'Rejected': return const Color(0xFF7F1D1D); // Darker red
      default: return secondaryText;
    }
  }
}
