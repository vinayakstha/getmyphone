import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String compIpAddress = "192.168.18.3";

  static const String imageBaseUrl = "http://$compIpAddress:5050";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return "http://$compIpAddress:5050/api";
    }
    if (kIsWeb) {
      return "http://localhost:5050/api";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:5050/api";
    } else if (Platform.isIOS) {
      return "http://localhost:5050/api";
    } else {
      return "http://10.0.2.2:5050/api";
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  //============= User Endpoints ============
  static const String updateProfile = '/user/update-profile';
  static const String getCurrentUser = '/user/me';

  // ============ Category Endpoints ==========
  static const String getAllCategories = '/category/';
  static const String getCategoryById = '/category/';

  // ============ Phone Endpoints ==========
  static const String createPhone = '/phone';
  static const String getAllPhones = '/phone';
  static const String getPhoneById = '/phone';
  static const String getPhonesBySeller = '/phone/my-listings';
  static const String getPhonesByBrand = '/phone/brand';
  static const String getPhonesNearLocation = '/phone/near';
  static const String updatePhone = '/phone';
  static const String deletePhone = '/phone';

  // ============ Saved Endpoints ==========
  static const String toggleSave = '/saved';
  static const String getSaved = '/saved';
  static const String isSaved = '/saved';

  // ============ Rating Endpoints ==========
  static const String submitRating = '/rating';
  static const String getUserRatings = '/rating';

  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    // Strip scheme and host if it is a full URL, keep just the path
    String path = imagePath;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      final uri = Uri.tryParse(path);
      if (uri != null) {
        path = uri.path;
      }
    }
    return '${baseUrl.replaceAll('/api', '')}$path';
  }
}
