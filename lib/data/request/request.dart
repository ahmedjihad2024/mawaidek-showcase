import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/supported_locales.dart';

class LoginRequest {
  final String phone;
  final String password;
  final String fcmToken;

  LoginRequest({
    required this.phone,
    required this.password,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'fcm_token': fcmToken,
      };
}

class RegisterRequest {
  final String? name;
  /// Optional. Captured on the profile-completion screen so the
  /// patient receives booking-invoice emails (via Resend) without
  /// blocking signup if they prefer to skip it.
  final String? email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final Gender? gender;
  final DateTime? birthDate;
  final File? image;

  RegisterRequest({
    this.name,
    this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.gender,
    this.birthDate,
    this.image,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    if (name != null) {
      json['name'] = name;
    }

    if (email != null && email!.isNotEmpty) {
      json['email'] = email;
    }

    if (gender != null) {
      json['gender'] = gender!.name;
    }

    if (birthDate != null) {
      json['birth_date'] = DateFormat('yyyy-MM-dd', SupportedLocales.EN.locale.languageCode).format(birthDate!);
    }

    return json;
  }

  FormData toFormData() {
    return FormData.fromMap({
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (name != null) 'name': name,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (gender != null) 'gender': gender!.name,
      if (birthDate != null)
        'birth_date': DateFormat('yyyy-MM-dd', SupportedLocales.EN.locale.languageCode).format(birthDate!),
      if (image != null)
        'image': MultipartFile.fromFileSync(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    });
  }
}

class CheckCodeRequest {
  final String code;
  final int userId;
  final String fcmToken;

  CheckCodeRequest({
    required this.code,
    required this.userId,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'user_id': userId,
        'fcm_token': fcmToken,
      };
}

class ResendCodeRequest {
  final int userId;

  ResendCodeRequest({required this.userId});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
      };
}

class RemoveAccountRequest {
  final String? password;

  RemoveAccountRequest({this.password});

  Map<String, dynamic> toJson() => {
        if (password != null) 'password': password,
      };
}

class ForgetPasswordRequest {
  final String phone;

  ForgetPasswordRequest({required this.phone});

  Map<String, dynamic> toJson() => {
        'phone': phone,
      };
}

class ResetPasswordRequest {
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequest({
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}

class CategoriesRequest {
  final String? search;
  final int page;

  CategoriesRequest({this.search, this.page = 1});

  Map<String, dynamic> toJson() {
    return {if (search != null) 'search': search, 'page': page};
  }
}

class ContactUsRequest {
  final String name;
  final String email;
  final String phone;
  final String message;

  ContactUsRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }
}

class ProvidersRequest {
  final double? lat;
  final double? lng;
  final int? categoryId;
  final String? search;
  final ProviderType type;
  final ProviderSortBy? sortBy;
  final int? ratings;
  final int? page;

  ProvidersRequest({
    this.lat,
    this.lng,
    this.categoryId,
    this.search,
    required this.type,
    this.sortBy,
    this.ratings,
    this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (categoryId != null) 'category_id': categoryId,
      if (search != null) 'search': search,
      'type': type.name,
      if (sortBy != null) 'sortBy': sortBy!.name,
      if (ratings != null) 'ratings': ratings,
      if (page != null) 'page': page,
    };
  }
}

class ProviderShowRequest {
  final int id;
  final double? lat;
  final double? lng;

  ProviderShowRequest({
    required this.id,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }
}

class ProviderLikesRequest {
  final ProviderType type;
  final int? page;

  ProviderLikesRequest({
    required this.type,
    this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (page != null) 'page': page,
    };
  }
}

class GetHomeRequest {
  final double? lat;
  final double? lng;

  GetHomeRequest({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }
}

class BookingConfirmRequest {
  final int providerId;
  final int? providerDoctorId;

  BookingConfirmRequest({
    required this.providerId,
    this.providerDoctorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
      if (providerDoctorId != null) 'provider_doctor_id': providerDoctorId,
    };
  }
}

class BookingAvailableTimesRequest {
  final DateTime date;
  final int categoryId;
  final int providerId;

  BookingAvailableTimesRequest({
    required this.date,
    required this.categoryId,
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    // Format date as "20-01-2026"
    final formattedDate = DateFormat('dd-MM-yyyy', SupportedLocales.EN.locale.languageCode).format(date);
    return {
      'date': formattedDate,
      'category_id': categoryId,
      'provider_id': providerId,
    };
  }
}

class BookingCreateRequest {
  final int providerId;
  final int? providerDoctorId;
  final DateTime date;
  final String time; // Format: "11:00"
  final BookingPeriod period;
  final PaymentMethod paymentMethod;
  /// Optional. Sent as `Idempotency-Key` header so a retried POST /bookings
  /// (network blip, double-tap on Confirm) returns the same payment session
  /// instead of creating a second booking and a second charge.
  final String? idempotencyKey;

  BookingCreateRequest({
    required this.providerId,
    this.providerDoctorId,
    required this.date,
    required this.time,
    required this.period,
    required this.paymentMethod,
    this.idempotencyKey,
  });

  Map<String, dynamic> toJson() {
    // Format date as "20-01-2026"
    final formattedDate = DateFormat('dd-MM-yyyy', SupportedLocales.EN.locale.languageCode).format(date);
    return {
      'provider_id': providerId,
      if (providerDoctorId != null) 'provider_doctor_id': providerDoctorId,
      'date': formattedDate,
      'time': time,
      'period': period.name,
      'payment_method': paymentMethod.name,
    };
  }
}

class BookingRateRequest {
  final int bookingId;
  final double rating;
  final String comment;
  final double? ratingDoctor;
  final String? commentDoctor;

  BookingRateRequest({
    required this.bookingId,
    required this.rating,
    required this.comment,
    this.ratingDoctor,
    this.commentDoctor,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'rating': rating,
      'comment': comment,
      if(ratingDoctor != null) 'rating_doctor': ratingDoctor,
      if(commentDoctor != null) 'comment_doctor': commentDoctor,
    };
  }
}

class BookingsRequest {
  final BookingStatusApp? statusApp;
  final String? invoiceNumber;
  final ProviderType? type;
  final BookingSortBy? sortBy;
  final int? page;

  BookingsRequest({
    this.statusApp,
    this.invoiceNumber,
    this.type,
    this.sortBy,
    this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      if (statusApp != null) 'status_app': statusApp!.name,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (type != null) 'type': type!.name,
      if (sortBy != null) 'sortBy': sortBy!.name,
      if (page != null) 'page': page,
    };
  }
}

class ProvidersDoctorsRequest {
  final int providerId;
  final int? categoryId;
  final String? search;
  final DoctorSortBy? sortBy;
  final int? ratings;
  final DateTime? date; // Will be formatted as "dd-MM-yyyy"
  final String? time; // Format: "18:30"
  final int? page;

  ProvidersDoctorsRequest({
    required this.providerId,
    this.categoryId,
    this.search,
    this.sortBy,
    this.ratings,
    this.date,
    this.time,
    this.page,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'provider_id': providerId,
    };

    if (categoryId != null) json['category_id'] = categoryId;
    if (search != null) json['search'] = search;
    if (sortBy != null) json['sortBy'] = sortBy!.name;
    if (ratings != null) json['ratings'] = ratings;
    if (date != null) {
      // Format date as "28-12-2025"
      json['date'] = DateFormat('dd-MM-yyyy', SupportedLocales.EN.locale.languageCode).format(date!);
    }
    if (time != null) json['time'] = time;
    if (page != null) json['page'] = page;

    return json;
  }
}

class BookingShowUseCaseInput {
  final int id;
  final double? lat;
  final double? lng;

  BookingShowUseCaseInput({required this.id, this.lat, this.lng});

  Map<String, dynamic> toJson() {
    return {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }
}

class BookingCancelRequest {
  final int bookingId;
  final int reasonCancellationId;

  BookingCancelRequest({
    required this.bookingId,
    required this.reasonCancellationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'reason_cancellation_id': reasonCancellationId,
    };
  }
}

class NotificationsRequest {
  final int? countPaginate;
  final int? page;

  NotificationsRequest({this.countPaginate, this.page});

  Map<String, dynamic> toJson() {
    return {
      if (countPaginate != null) 'count_paginate': countPaginate,
      if (page != null) 'page': page,
    };
  }
}

class UpdateAccountRequest {
  final String? name;
  final String? email;
  final Gender? gender;
  final DateTime? birthDate;
  final File? image;

  UpdateAccountRequest({
    this.name,
    this.email,
    this.gender,
    this.birthDate,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender!.name,
      if (birthDate != null) 'birth_date': DateFormat('yyyy-MM-dd', SupportedLocales.EN.locale.languageCode).format(birthDate!),
    };
  }

  FormData toFormData() {
    return FormData.fromMap({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender!.name,
      if (birthDate != null) 'birth_date': DateFormat('yyyy-MM-dd', SupportedLocales.EN.locale.languageCode).format(birthDate!),
      if (image != null)
        'image': MultipartFile.fromFileSync(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    });
  }
}

class AiChatHistoryItem {
  final String role; // user | assistant
  final String content;

  AiChatHistoryItem({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}

class AiChatRequest {
  final String message;
  final String sessionId;
  final List<AiChatHistoryItem>? history;

  AiChatRequest({
    required this.message,
    required this.sessionId,
    this.history,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'message': message,
      'session_id': sessionId,
    };
    if (history != null && history!.isNotEmpty) {
      json['history'] = history!.map((e) => e.toJson()).toList();
    }
    return json;
  }
}
