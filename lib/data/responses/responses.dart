import 'package:mawadk/app/enums.dart';

class BasicResponse {
  final String success;
  final int code;
  final String message;

  BasicResponse(
      {required this.success, required this.message, required this.code});

  factory BasicResponse.fromJson(Map<String, dynamic> json) {
    return BasicResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      message: (json['message'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
    );
  }
}

class User {
  final int id;
  final String? name;
  final String phone;
  final String? email;
  final bool status;
  final bool isActivation;
  final String? image;
  final String? gender;
  final String? birthDate;

  User({
    required this.id,
    this.name,
    required this.phone,
    this.email,
    required this.status,
    required this.isActivation,
    this.image,
    this.gender,
    this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as int?) ?? 0,
      name: json['name'] as String?,
      phone: (json['phone'] as String?) ?? '',
      email: json['email'] as String?,
      status: (json['status'] as bool?) ?? false,
      isActivation: (json['is_activation'] as bool?) ?? false,
      image: json['image'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'status': status,
      'is_activation': isActivation,
      'image': image,
      'gender': gender,
      'birth_date': birthDate,
    };
  }
}

class LoginData {
  final String accessToken;
  final String tokenType;
  final String? expiresIn;
  final User user;

  LoginData({
    required this.accessToken,
    required this.tokenType,
    this.expiresIn,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: (json['access_token'] as String?) ?? '',
      tokenType: (json['token_type'] as String?) ?? '',
      expiresIn: json['expires_in'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class LoginResponse extends BasicResponse {
  final LoginData? data;

  LoginResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RegisterData {
  final int userId;

  RegisterData({required this.userId});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      userId: (json['user_id'] as int?) ?? 0,
    );
  }
}

class RegisterResponse extends BasicResponse {
  final RegisterData? data;

  RegisterResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? RegisterData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CheckCodeResponse extends BasicResponse {
  final LoginData? data;

  CheckCodeResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory CheckCodeResponse.fromJson(Map<String, dynamic> json) {
    return CheckCodeResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ResendCodeResponse extends BasicResponse {
  final int? data;

  ResendCodeResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ResendCodeResponse.fromJson(Map<String, dynamic> json) {
    final dataValue = json['data'];
    return ResendCodeResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: dataValue is int ? dataValue : null,
    );
  }
}

class LogoutResponse extends BasicResponse {
  LogoutResponse({
    required super.success,
    required super.message,
    required super.code,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
    );
  }
}

class RemoveAccountResponse extends BasicResponse {
  RemoveAccountResponse({
    required super.success,
    required super.message,
    required super.code,
  });

  factory RemoveAccountResponse.fromJson(Map<String, dynamic> json) {
    return RemoveAccountResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
    );
  }
}

class RefreshResponse extends BasicResponse {
  final LoginData? data;

  RefreshResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ForgetPasswordResponse extends BasicResponse {
  final int? data;

  ForgetPasswordResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    final dataValue = json['data'];
    return ForgetPasswordResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: dataValue is int ? dataValue : null,
    );
  }
}

class ResetPasswordResponse extends BasicResponse {
  ResetPasswordResponse({
    required super.success,
    required super.message,
    required super.code,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
    );
  }
}

class ProfileResponse extends BasicResponse {
  final User? data;

  ProfileResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? User.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// --- New Models ---

class Slider {
  final int id;
  final String type;
  final String title;
  final String description;
  final String? url;
  final String image;

  Slider({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.url,
    required this.image,
  });

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      id: (json['id'] as int?) ?? 0,
      type: (json['type'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      url: json['url'] as String?,
      image: (json['image'] as String?) ?? '',
    );
  }
}

class Category {
  final int id;
  final String image;
  final String name;
  final int doctorsCount;

  Category(
      {required this.id,
      required this.image,
      required this.name,
      required this.doctorsCount});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] as int?) ?? 0,
      image: (json['image'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      doctorsCount: (json['doctors_count'] as int?) ?? 0,
    );
  }
}

class Provider {
  final int id;
  final String image;
  bool isFavorite;
  final ProviderType type;
  final String name;
  final String address;
  final String countRating;
  final double rating;
  final String distanceKm;
  final Category? category;

  Provider({
    required this.id,
    required this.image,
    required this.isFavorite,
    required this.type,
    required this.name,
    required this.address,
    required this.countRating,
    required this.rating,
    required this.distanceKm,
    this.category,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: (json['id'] as int?) ?? 0,
      image: (json['image'] as String?) ?? '',
      isFavorite: (json['is_favorite'] as bool?) ?? false,
      type: ProviderType.fromString((json['type'] as String?) ?? '') ?? ProviderType.Hospital,
      name: (json['name'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      countRating: (json['count_rating']?.toString()) ?? '0',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      distanceKm: _formatDistance((json['distance_km'] as String?) ?? '0.0'),
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  static String _formatDistance(String raw) {
    final value = double.tryParse(raw);
    if (value == null || value == 0) return '0';
    return value.round().toString();
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: (json['current_page'] as int?) ?? 0,
      lastPage: (json['last_page'] as int?) ?? 0,
      perPage: (json['per_page'] as int?) ?? 0,
      total: (json['total'] as int?) ?? 0,
    );
  }
}

class HomeData {
  final List<Slider> sliders;
  final List<Category> categories;
  final List<Provider> nearby;

  HomeData({
    required this.sliders,
    required this.categories,
    required this.nearby,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      sliders:
          (json['sliders'] as List?)?.map((e) => Slider.fromJson(e)).toList() ??
              [],
      categories: (json['categories'] as List?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],
      nearby: (json['nearby'] as List?)
              ?.map((e) => Provider.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HomeResponse extends BasicResponse {
  final HomeData? data;

  HomeResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? HomeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CategoriesData {
  final List<Category> items;
  final Meta meta;

  CategoriesData({
    required this.items,
    required this.meta,
  });

  factory CategoriesData.fromJson(Map<String, dynamic> json) {
    return CategoriesData(
      items:
          (json['items'] as List?)?.map((e) => Category.fromJson(e)).toList() ??
              [],
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CategoriesResponse extends BasicResponse {
  final CategoriesData? data;

  CategoriesResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? CategoriesData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AllCategoriesResponse extends BasicResponse {
  final List<Category>? data;

  AllCategoriesResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory AllCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return AllCategoriesResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: (json['data'] as List?)?.map((e) => Category.fromJson(e)).toList(),
    );
  }
}

class ContactUsResponse extends BasicResponse {
  ContactUsResponse({
    required super.success,
    required super.message,
    required super.code,
  });

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) {
    return ContactUsResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
    );
  }
}

class ProvidersData {
  final List<Provider> items;
  final Meta meta;

  ProvidersData({
    required this.items,
    required this.meta,
  });

  factory ProvidersData.fromJson(Map<String, dynamic> json) {
    return ProvidersData(
      items:
          (json['items'] as List?)?.map((e) => Provider.fromJson(e)).toList() ??
              [],
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ProvidersResponse extends BasicResponse {
  final ProvidersData? data;

  ProvidersResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ProvidersResponse.fromJson(Map<String, dynamic> json) {
    return ProvidersResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? ProvidersData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Schedule {
  final String day;
  final String hours;

  Schedule({
    required this.day,
    required this.hours,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      day: (json['day'] as String?) ?? '',
      hours: (json['hours'] as String?) ?? '',
    );
  }
}

class ProviderDetails extends Provider {
  final bool isOpenNow;
  final int countDoctors;
  final int clients;
  final int experienceYears;
  final String lat;
  final String lng;
  final String description;
  final List<Schedule> schedules;
  final String priceBeforeDiscount;
  final String priceAfterDiscount;
  final String discountPercentage;
  final List<Category>? categories;

  ProviderDetails(
      {required super.id,
      required super.image,
      required super.isFavorite,
      required super.type,
      required super.name,
      required super.address,
      required super.countRating,
      required super.rating,
      required super.distanceKm,
      super.category,
      required this.isOpenNow,
      required this.countDoctors,
      required this.clients,
      required this.experienceYears,
      required this.lat,
      required this.lng,
      required this.description,
      required this.schedules,
      required this.priceBeforeDiscount,
      required this.priceAfterDiscount,
      required this.discountPercentage,
      this.categories});

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
        id: (json['id'] as int?) ?? 0,
        image: (json['image'] as String?) ?? '',
        isFavorite: (json['is_favorite'] as bool?) ?? false,
        type: ProviderType.fromString((json['type'] as String?) ?? '') ?? ProviderType.Hospital,
        name: (json['name'] as String?) ?? '',
        address: (json['address'] as String?) ?? '',
        countRating: (json['count_rating']?.toString()) ?? '0',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        distanceKm: Provider._formatDistance((json['distance_km'] as String?) ?? '0'),
        category: json['category'] != null
            ? Category.fromJson(json['category'] as Map<String, dynamic>)
            : null,
        isOpenNow: (json['is_open_now'] as bool?) ?? false,
        countDoctors: (json['count_doctors'] as int?) ?? 0,
        clients: (json['clients'] as int?) ?? 0,
        experienceYears: (json['experience_years'] as int?) ?? 0,
        lat: (json['lat'] as String?) ?? '',
        lng: (json['lng'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
        schedules: (json['schedules'] as List?)
                ?.map((e) => Schedule.fromJson(e))
                .toList() ??
            [],
        priceBeforeDiscount:
            (json['price_before_discount'] as String?) ?? '0.00',
        priceAfterDiscount: (json['price_after_discount'] as String?) ?? '0.00',
        discountPercentage: (json['discount_percentage'] as String?) ?? '0.00',
        categories: json['categories'] != null
            ? ((json['categories'] as List?)
                    ?.map((e) => Category.fromJson(e))
                    .toList() ??
                [])
            : null);
  }
}

class Rating {
  final int id;
  final double rating;
  final int userId;
  final String userName;
  final String userImage;
  final String comment;
  final String dateAt;

  Rating({
    required this.id,
    required this.rating,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.dateAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: (json['id'] as int?) ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      userId: (json['user_id'] as int?) ?? 0,
      userName: (json['user_name'] as String?) ?? '',
      userImage: (json['user_image'] as String?) ?? '',
      comment: (json['comment'] as String?) ?? '',
      dateAt: (json['date_at'] as String?) ?? '',
    );
  }
}

class ProviderShowData {
  final ProviderDetails provider;
  final List<Category> categories;
  final List<Rating> ratings;

  ProviderShowData({
    required this.provider,
    required this.categories,
    required this.ratings,
  });

  factory ProviderShowData.fromJson(Map<String, dynamic> json) {
    return ProviderShowData(
      provider: ProviderDetails.fromJson(
          json['provider'] as Map<String, dynamic>? ?? {}),
      categories: (json['categories'] as List?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],
      ratings:
          (json['ratings'] as List?)?.map((e) => Rating.fromJson(e)).toList() ??
              [],
    );
  }
}

class ProviderShowResponse extends BasicResponse {
  final ProviderShowData? data;

  ProviderShowResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ProviderShowResponse.fromJson(Map<String, dynamic> json) {
    return ProviderShowResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? ProviderShowData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProviderRatingsData {
  final List<Rating> items;
  final Meta meta;

  ProviderRatingsData({
    required this.items,
    required this.meta,
  });

  factory ProviderRatingsData.fromJson(Map<String, dynamic> json) {
    return ProviderRatingsData(
      items:
          (json['items'] as List?)?.map((e) => Rating.fromJson(e)).toList() ??
              [],
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ProviderRatingsResponse extends BasicResponse {
  final ProviderRatingsData? data;

  ProviderRatingsResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ProviderRatingsResponse.fromJson(Map<String, dynamic> json) {
    return ProviderRatingsResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? ProviderRatingsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProviderLikeResponse extends BasicResponse {
  final bool? data;

  ProviderLikeResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ProviderLikeResponse.fromJson(Map<String, dynamic> json) {
    return ProviderLikeResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] as bool?,
    );
  }
}

class ProviderDoctor {
  final int id;
  final String image;
  final bool isFavorite;
  final String name;
  final String shortDescription;
  final String countRating;
  final double rating;
  final Category category;
  final Provider provider;

  final int experienceYears;
  final String priceBeforeDiscount;
  final String priceAfterDiscount;
  final String discountPercentage;

  ProviderDoctor({
    required this.id,
    required this.image,
    required this.isFavorite,
    required this.name,
    required this.shortDescription,
    required this.countRating,
    required this.rating,
    required this.category,
    required this.provider,
    required this.experienceYears,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    required this.discountPercentage,
  });

  factory ProviderDoctor.fromJson(Map<String, dynamic> json) {
    return ProviderDoctor(
      id: (json['id'] as int?) ?? 0,
      image: (json['image'] as String?) ?? '',
      isFavorite: (json['is_favorite'] as bool?) ?? false,
      name: (json['name'] as String?) ?? '',
      shortDescription: (json['short_description'] as String?) ?? '',
      countRating: (json['count_rating']?.toString()) ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      category:
          Category.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
      provider:
          Provider.fromJson(json['provider'] as Map<String, dynamic>? ?? {}),
      experienceYears: (json['experience_years'] as int?) ?? 0,
      priceBeforeDiscount: (json['price_before_discount']?.toString()) ?? '0',
      priceAfterDiscount: (json['price_after_discount']?.toString()) ?? '0',
      discountPercentage: (json['discount_percentage']?.toString()) ?? '0',
    );
  }
}

class Price {
  final String subTotal;
  final double feeAmount;
  final double total;

  Price({
    required this.subTotal,
    required this.feeAmount,
    required this.total,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      subTotal: (json['subTotal'] as String?) ?? "0.0",
      feeAmount: (json['fee_amount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subTotal': subTotal,
      'fee_amount': feeAmount,
      'total': total,
    };
  }
}

class BookingConfirmData {
  final Provider provider;
  final ProviderDoctor? providerDoctor;
  final Price price;

  BookingConfirmData({
    required this.provider,
    this.providerDoctor,
    required this.price,
  });

  factory BookingConfirmData.fromJson(Map<String, dynamic> json) {
    return BookingConfirmData(
      provider:
          Provider.fromJson(json['provider'] as Map<String, dynamic>? ?? {}),
      providerDoctor: json['provider_doctor'] != null
          ? ProviderDoctor.fromJson(
              json['provider_doctor'] as Map<String, dynamic>)
          : null,
      price: Price.fromJson(json['price'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class BookingConfirmResponse extends BasicResponse {
  final BookingConfirmData? data;

  BookingConfirmResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory BookingConfirmResponse.fromJson(Map<String, dynamic> json) {
    return BookingConfirmResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? BookingConfirmData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TimeSlot {
  final String time;
  final bool available;

  TimeSlot({
    required this.time,
    required this.available,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      time: (json['time'] as String?) ?? '',
      available: (json['available'] as bool?) ?? false,
    );
  }
}

class BookingAvailableTimesData {
  final bool isAvailable;
  final List<TimeSlot> morning;
  final List<TimeSlot> evening;

  BookingAvailableTimesData({
    required this.isAvailable,
    required this.morning,
    required this.evening,
  });

  factory BookingAvailableTimesData.fromJson(Map<String, dynamic> json) {
    return BookingAvailableTimesData(
      isAvailable: (json['is_available'] as bool?) ?? false,
      morning: (json['morning'] as List?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evening: (json['evening'] as List?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BookingAvailableTimesResponse extends BasicResponse {
  final BookingAvailableTimesData? data;

  BookingAvailableTimesResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory BookingAvailableTimesResponse.fromJson(Map<String, dynamic> json) {
    return BookingAvailableTimesResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? BookingAvailableTimesData.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// One row of a booking's status history. The list comes back ordered
/// chronologically (oldest first) so the UI can render a vertical
/// timeline directly without re-sorting.
class BookingStatusTimelineEntry {
  final int id;
  final BookingStatusApp status;
  /// ISO-8601 string from the server. Pre-parsed once into [changedAtDate].
  final String? changedAtIso;
  /// Server-side `diffForHumans()` text — already localised by the
  /// backend's translate() chain, so the UI displays it directly
  /// without doing date math on device.
  final String? changedAtHuman;
  /// 'User' | 'Admin' | 'Provider' — same vocabulary the backend uses
  /// for cancelled_by_type. null when the change was system-driven
  /// (e.g. cron expiry, webhook auto-complete).
  final String? actorType;
  final DateTime? changedAtDate;

  BookingStatusTimelineEntry({
    required this.id,
    required this.status,
    this.changedAtIso,
    this.changedAtHuman,
    this.actorType,
    this.changedAtDate,
  });

  factory BookingStatusTimelineEntry.fromJson(Map<String, dynamic> j) {
    final iso = j['changed_at'] as String?;
    return BookingStatusTimelineEntry(
      id: (j['id'] as int?) ?? 0,
      status: BookingStatusApp.fromString((j['status'] as String?) ?? '') ??
          BookingStatusApp.pending,
      changedAtIso: iso,
      changedAtHuman: j['changed_at_human'] as String?,
      actorType: j['actor_type'] as String?,
      changedAtDate: iso != null ? DateTime.tryParse(iso) : null,
    );
  }
}

class Booking {
  final int id;
  final String invoiceNumber;
  final bool isRated;
  final ProviderDetails provider;
  final String? subtotal;
  final String total;
  final BookingStatusApp status;
  final String date;
  final String time;
  final String period;
  final PaymentMethod paymentMethod;
  /// 'pending' | 'paid' | 'failed' | 'refunded'.
  /// For online bookings: surfaces a "Resume payment" affordance in the
  /// booking-details view when status=pending and payment_status=pending
  /// — i.e. the user backed out of Sadad or the app got killed mid-flow.
  final PaymentStatus paymentStatus;
  final ProviderDoctor? providerDoctor;
  final String createdAt;
  final String feeServices;
  // 'provider_no_response', 'auto_complete_after_grace', etc. Surface in
  // the UI when explaining a system-driven status to the user.
  final String? autoActionReason;
  /// Status history. Empty when the API didn't include the field
  /// (older endpoints) — the UI hides the timeline section in that case.
  final List<BookingStatusTimelineEntry> statusTimeline;

  Booking({
    required this.id,
    required this.invoiceNumber,
    required this.isRated,
    required this.provider,
    this.subtotal,
    required this.total,
    required this.status,
    required this.date,
    required this.time,
    required this.period,
    required this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.providerDoctor,
    required this.createdAt,
    required this.feeServices,
    this.autoActionReason,
    this.statusTimeline = const [],
  });

  /// True when this booking has a half-finished online payment that the
  /// user can resume — they backed out of the Sadad sheet, or the OS
  /// killed the app, and the slot is still held by the 15-min server cron.
  bool get canResumeOnlinePayment =>
      paymentMethod.isOnline &&
      paymentStatus.isPending &&
      status == BookingStatusApp.pending;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: (json['id'] as int?) ?? 0,
      invoiceNumber: (json['invoice_number'] as String?) ?? '',
      isRated: (json['is_rated'] as bool?) ?? false,
      provider: ProviderDetails.fromJson(
          json['provider'] as Map<String, dynamic>? ?? {}),
      subtotal: json['subtotal'] as String?,
      total: (json['total'] as String?) ?? '0.0',
      // Prefer the precise server status (status_raw) when the API exposes it,
      // and fall back to the bucket-mapped status field for compatibility with
      // older payloads. Either way an unknown value degrades to pending instead
      // of crashing.
      status: BookingStatusApp.fromString(
            (json['status_raw'] as String?) ?? (json['status'] as String?) ?? '',
          ) ??
          BookingStatusApp.pending,
      date: (json['date'] as String?) ?? '',
      time: (json['time'] as String?) ?? '',
      period: (json['period'] as String?) ?? '',
      paymentMethod: (json['payment_method'] as String?) == null
          ? PaymentMethod.cash
          : PaymentMethod.fromString((json['payment_method'] as String?)!) ?? PaymentMethod.cash,
      paymentStatus: PaymentStatus.fromString(json['payment_status'] as String?),
      providerDoctor: json['provider_doctor'] != null &&
              json['provider_doctor'] is Map<String, dynamic>
          ? ProviderDoctor.fromJson(
              json['provider_doctor'] as Map<String, dynamic>)
          : null,
      createdAt: (json['created_at'] as String?) ?? '',
      feeServices: (json['fee_services'] as String?) ?? '0.0',
      autoActionReason: json['auto_action_reason'] as String?,
      statusTimeline: (json['status_timeline'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(BookingStatusTimelineEntry.fromJson)
              .toList() ??
          const [],
    );
  }
}

/// Payment-flow params the backend hands back when payment_method=online.
/// The `sdk` block is exactly what the Sadad PaymentScreen widget needs;
/// we keep it as a typed value object so the booking flow doesn't have to
/// reach into a raw map.
class SadadSdkParams {
  final String token;
  final String orderId;
  final double amountQar;
  final String customerName;
  final String customerEmail;
  final String customerMobile;
  /// 'debug' (test merchant) or 'release' (live).
  final String packageMode;
  /// The mawadk-side payment_transaction id — used to poll
  /// /payments/{id}/status after the SDK returns.
  final int transactionId;
  /// ISO-8601 — the moment the Sadad token expires. Mobile should
  /// not enter the SDK if now > expiresAt.
  final String? expiresAtIso;

  SadadSdkParams({
    required this.token,
    required this.orderId,
    required this.amountQar,
    required this.customerName,
    required this.customerEmail,
    required this.customerMobile,
    required this.packageMode,
    required this.transactionId,
    this.expiresAtIso,
  });

  factory SadadSdkParams.fromJson(Map<String, dynamic> j) {
    final amt = j['amount_qar'];
    return SadadSdkParams(
      token:          (j['token'] as String?) ?? '',
      orderId:        (j['order_id'] as String?) ?? '',
      amountQar:      amt is num ? amt.toDouble() : double.tryParse('${amt ?? ''}') ?? 0.0,
      customerName:   (j['customer_name'] as String?) ?? '',
      customerEmail:  (j['customer_email'] as String?) ?? '',
      customerMobile: (j['customer_mobile'] as String?) ?? '',
      packageMode:    (j['package_mode'] as String?) ?? 'debug',
      transactionId:  (j['transaction_id'] as int?) ?? 0,
      expiresAtIso:   j['expires_at'] as String?,
    );
  }
}

class BookingCreatePayment {
  final int? transactionId;
  final SadadSdkParams? sdk;
  /// Set when the backend created the booking but the gateway was not
  /// reachable. Mobile should fall back to "Pay cash" with a friendly
  /// message instead of crashing.
  final String? error;

  BookingCreatePayment({this.transactionId, this.sdk, this.error});

  bool get isReady => sdk != null && error == null;

  factory BookingCreatePayment.fromJson(Map<String, dynamic> j) {
    return BookingCreatePayment(
      transactionId: j['transaction_id'] as int?,
      sdk: j['sdk'] is Map<String, dynamic>
          ? SadadSdkParams.fromJson(j['sdk'] as Map<String, dynamic>)
          : null,
      error: j['error'] as String?,
    );
  }
}

class BookingCreateResponse extends BasicResponse {
  /// Cash-flow shape (existing): the booking is the whole `data`.
  /// Online-flow shape (new): `data` is `{ booking, payment }`.
  /// We accept both transparently so older builds keep working.
  final Booking? data;
  final BookingCreatePayment? payment;

  /// Booking id pulled out of the online-create envelope (shape 1) when
  /// the embedded booking object can't be fully deserialised — typically
  /// because the response includes nested decimal fields (lat/lng,
  /// discounts) that the existing model casts as String? but MySQL
  /// occasionally returns as int defaults.
  ///
  /// We only need the id to deep-link the user back to the booking-
  /// detail screen on cancel/fail outcomes; the full booking is
  /// refetched via GET /bookings/{id} when that screen mounts. So
  /// rather than parsing the whole nested object (and risking another
  /// type-cast bomb), we read just the id cheaply here.
  final int? bookingId;

  BookingCreateResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
    this.payment,
    this.bookingId,
  });

  factory BookingCreateResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    Booking? booking;
    BookingCreatePayment? payment;
    int? bookingId;

    if (raw is Map<String, dynamic>) {
      // Three response shapes feed through this factory — they all came
      // out of /bookings-family endpoints over time and we accept all of
      // them here so the mobile doesn't care which one fired:
      //
      //   1. POST /bookings (online): { data: { booking: {...}, payment: {...} } }
      //   2. POST /bookings/{id}/resume-payment: { data: { transaction_id, sdk } }
      //      ← flat. No outer booking key because resume doesn't create
      //         a new booking; the caller already has the booking id.
      //   3. POST /bookings (cash): { data: { ...booking fields directly } }
      //      ← legacy; we don't deserialise the booking here, the GET
      //         /bookings list refreshes the UI.
      if (raw['booking'] is Map<String, dynamic>) {
        // Shape 1 — online-create envelope. We read the id cheaply
        // instead of full-parsing the booking. The full Booking model
        // has String? casts on fields like lat/lng and discount
        // percentages that MySQL sometimes returns as int defaults
        // (e.g. discount_percentage = 0 from a DECIMAL(5,2) column with
        // default 0) — that mismatch caused
        //   `type 'int' is not a subtype of type 'String?' in type cast`
        // when trying to confirm a brand-new online booking. We don't
        // need any of those fields here; the booking-details screen
        // refetches the full record via GET /bookings/{id} as soon as
        // it mounts.
        final bookingMap = raw['booking'] as Map<String, dynamic>;
        bookingId = (bookingMap['id'] is int)
            ? bookingMap['id'] as int
            : int.tryParse('${bookingMap['id']}');
        if (raw['payment'] is Map<String, dynamic>) {
          payment = BookingCreatePayment.fromJson(
              raw['payment'] as Map<String, dynamic>);
        }
      } else if (raw['transaction_id'] != null || raw['sdk'] is Map) {
        // Shape 2 — resume-payment flat envelope. The whole `data` block
        // IS the payment block. Without this branch, `payment` would
        // stay null and the SadadPaymentRunner would bail to
        // gatewayUnavailable, which is what made the "Continue Payment"
        // button appear broken end-to-end.
        payment = BookingCreatePayment.fromJson(raw);
      }
      // Shape 3 (cash legacy) — neither branch matches, both stay null.
      // ConfirmBookingBloc only checks for success on this path so the
      // null is fine.
    }

    return BookingCreateResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: booking,
      payment: payment,
      bookingId: bookingId,
    );
  }
}

class BookingRateResponse extends BasicResponse {
  BookingRateResponse({
    required super.success,
    required super.message,
    required super.code,
  });

  factory BookingRateResponse.fromJson(Map<String, dynamic> json) {
    return BookingRateResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
    );
  }
}

class BookingsData {
  final List<Booking> items;
  final Meta meta;

  BookingsData({
    required this.items,
    required this.meta,
  });

  factory BookingsData.fromJson(Map<String, dynamic> json) {
    return BookingsData(
      items: (json['items'] as List?)
              ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class BookingsResponse extends BasicResponse {
  final BookingsData? data;

  BookingsResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    return BookingsResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? BookingsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BookingShowResponse extends BasicResponse {
  final Booking? data;

  BookingShowResponse({
    required super.success,
    required super.message, required super.code,
    this.data,
  });

  factory BookingShowResponse.fromJson(Map<String, dynamic> json) {
    return BookingShowResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? Booking.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProviderDoctorsData {
  final List<ProviderDoctor> items;
  final Meta meta;

  ProviderDoctorsData({
    required this.items,
    required this.meta,
  });

  factory ProviderDoctorsData.fromJson(Map<String, dynamic> json) {
    return ProviderDoctorsData(
      items: (json['items'] as List?)
              ?.map((e) => ProviderDoctor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ProviderDoctorsResponse extends BasicResponse {
  final ProviderDoctorsData? data;

  ProviderDoctorsResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory ProviderDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return ProviderDoctorsResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null
          ? ProviderDoctorsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// --- Booking Cancellation ---

class BookingCancelResponse extends BasicResponse {
  BookingCancelResponse({
    required super.success,
    required super.message,
    required super.code,
  });

  factory BookingCancelResponse.fromJson(Map<String, dynamic> json) {
    return BookingCancelResponse(
      success: (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
    );
  }
}

class CancellationReason {
  final int id;
  final String title;

  CancellationReason({required this.id, required this.title});

  factory CancellationReason.fromJson(Map<String, dynamic> json) {
    return CancellationReason(
      id: (json['id'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '',
    );
  }
}

class CancellationReasonsResponse extends BasicResponse {
  final List<CancellationReason>? data;

  CancellationReasonsResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory CancellationReasonsResponse.fromJson(Map<String, dynamic> json) {
    return CancellationReasonsResponse(
      success: (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: (json['data'] as List?)
          ?.map((e) => CancellationReason.fromJson(e))
          .toList(),
    );
  }
}

// --- Info (FAQ, Terms, Privacy) ---

class FAQ {
  final int id;
  final String title;
  final String description;

  FAQ({required this.id, required this.title, required this.description});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: (json['id'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
    );
  }
}

class FAQsResponse extends BasicResponse {
  final List<FAQ>? data;

  FAQsResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory FAQsResponse.fromJson(Map<String, dynamic> json) {
    return FAQsResponse(
      success: (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: (json['data'] as List?)?.map((e) => FAQ.fromJson(e)).toList(),
    );
  }
}

class InfoContent {
  final int id;
  final String? slug;
  final String title;
  final String description;

  InfoContent({required this.id, this.slug, required this.title, required this.description});

  factory InfoContent.fromJson(Map<String, dynamic> json) {
    return InfoContent(
      id: (json['id'] as int?) ?? 0,
      slug: json['slug'] as String?,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
    );
  }
}

class InfoContentResponse extends BasicResponse {
  final InfoContent? data;

  InfoContentResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory InfoContentResponse.fromJson(Map<String, dynamic> json) {
    return InfoContentResponse(
      success: (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: json['data'] != null ? InfoContent.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

// --- Notifications ---

class NotificationModel {
  final int id;
  final bool isRead;
  final String type;
  final int? typeId;
  final String title;
  final String body;
  final String? image;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.isRead,
    required this.type,
    this.typeId,
    required this.title,
    required this.body,
    this.image,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as int?) ?? 0,
      isRead: (json['is_read'] as bool?) ?? false,
      type: (json['type'] as String?) ?? '',
      typeId: (json['type_id'] as int?),
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      image: json['image'] as String?,
      createdAt: (json['created_at'] as String?) ?? '',
    );
  }
}

class NotificationsResponse extends BasicResponse {
  final List<NotificationModel>? data;

  NotificationsResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      success: (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? "",
      data: (json['data'] as List?)?.map((e) => NotificationModel.fromJson(e)).toList(),
    );
  }
}

// ===== AI Symptom Chatbot =====

enum AiUrgency {
  routine,
  urgent,
  emergency;

  static AiUrgency from(String? value) {
    return switch (value) {
      'urgent' => AiUrgency.urgent,
      'emergency' => AiUrgency.emergency,
      _ => AiUrgency.routine,
    };
  }

  bool get isEmergency => this == AiUrgency.emergency;
  bool get isUrgent => this == AiUrgency.urgent;
}

class SuggestedCategory {
  final int id;
  final String name;

  SuggestedCategory({required this.id, required this.name});

  factory SuggestedCategory.fromJson(Map<String, dynamic> json) {
    return SuggestedCategory(
      id: (json['id'] as int?) ?? 0,
      name: (json['name'] as String?) ?? '',
    );
  }
}

class NextSlot {
  final String date; // yyyy-MM-dd
  final String time; // hh:mm a — matches the existing booking flow
  final String label;
  final String period; // 'morning' | 'evening' — pre-derived server-side

  NextSlot({
    required this.date,
    required this.time,
    required this.label,
    required this.period,
  });

  factory NextSlot.fromJson(Map<String, dynamic> json) {
    return NextSlot(
      date: (json['date'] as String?) ?? '',
      time: (json['time'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      period: (json['period'] as String?) ?? 'morning',
    );
  }
}

class DoctorMatch {
  final String type; // provider_doctor | provider
  final int id;
  final String name;
  final String? specialty;
  final String? image;
  final double? rating;
  final int? ratingsCount;
  final String? price;
  final double? distanceKm;
  final int? providerId;
  final String? providerName;
  final String? providerType;
  final List<NextSlot> nextSlots;

  DoctorMatch({
    required this.type,
    required this.id,
    required this.name,
    this.specialty,
    this.image,
    this.rating,
    this.ratingsCount,
    this.price,
    this.distanceKm,
    this.providerId,
    this.providerName,
    this.providerType,
    required this.nextSlots,
  });

  bool get isStandaloneDoctor => type == 'provider';
  bool get isProviderDoctor => type == 'provider_doctor';

  factory DoctorMatch.fromJson(Map<String, dynamic> json) {
    return DoctorMatch(
      type: (json['type'] as String?) ?? 'provider_doctor',
      id: (json['id'] as int?) ?? 0,
      name: (json['name'] as String?) ?? '',
      specialty: json['specialty'] as String?,
      image: json['image'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      ratingsCount: json['ratings_count'] as int?,
      price: json['price']?.toString(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      providerId: json['provider_id'] as int?,
      providerName: json['provider_name'] as String?,
      providerType: json['provider_type'] as String?,
      nextSlots: (json['next_slots'] as List?)
              ?.map((e) => NextSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class AiChatData {
  final String sessionId;
  final AiUrgency urgency;
  final String aiMessage;
  final String? followUpQuestion;
  final List<SuggestedCategory> suggestedCategories;
  final List<DoctorMatch> matches;
  final String? disclaimer;
  final String? emergencyPhone;

  AiChatData({
    required this.sessionId,
    required this.urgency,
    required this.aiMessage,
    this.followUpQuestion,
    required this.suggestedCategories,
    required this.matches,
    this.disclaimer,
    this.emergencyPhone,
  });

  factory AiChatData.fromJson(Map<String, dynamic> json) {
    return AiChatData(
      sessionId: (json['session_id'] as String?) ?? '',
      urgency: AiUrgency.from(json['urgency'] as String?),
      aiMessage: (json['ai_message'] as String?) ?? '',
      followUpQuestion: json['follow_up_question'] as String?,
      suggestedCategories: (json['suggested_categories'] as List?)
              ?.map((e) =>
                  SuggestedCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      matches: (json['matches'] as List?)
              ?.map((e) => DoctorMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      disclaimer: json['disclaimer'] as String?,
      emergencyPhone: json['emergency_phone']?.toString(),
    );
  }
}

class AiChatResponse extends BasicResponse {
  final AiChatData? data;

  AiChatResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? '',
      data: json['data'] != null
          ? AiChatData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Response of GET /payments/{id}/status — used by the booking flow
/// after the Sadad SDK returns, to confirm that the gateway-side state
/// matches what the SDK reported. The `verify_source` field tells you
/// whether the backend served from its DB cache or made a live call.
class PaymentStatusData {
  final int transactionId;
  final String orderId;
  /// 'initiated' | 'sent_to_gateway' | 'success' | 'failed' | 'expired' | 'cancelled'
  final String status;
  /// 'db' (cache) | 'sadad_live' (just re-checked with the gateway)
  final String verifySource;
  final double amountQar;

  PaymentStatusData({
    required this.transactionId,
    required this.orderId,
    required this.status,
    required this.verifySource,
    required this.amountQar,
  });

  bool get isSuccess => status == 'success';
  bool get isFailedOrExpired => status == 'failed' || status == 'expired' || status == 'cancelled';
  bool get isPending => status == 'initiated' || status == 'sent_to_gateway';

  factory PaymentStatusData.fromJson(Map<String, dynamic> j) {
    final amt = j['amount_qar'];
    return PaymentStatusData(
      transactionId: (j['transaction_id'] as int?) ?? 0,
      orderId:       (j['order_id'] as String?) ?? '',
      status:        (j['status'] as String?) ?? 'initiated',
      verifySource:  (j['verify_source'] as String?) ?? 'db',
      amountQar:     amt is num ? amt.toDouble() : double.tryParse('${amt ?? ''}') ?? 0.0,
    );
  }
}

class PaymentStatusResponse extends BasicResponse {
  final PaymentStatusData? data;

  PaymentStatusResponse({
    required super.success,
    required super.message,
    required super.code,
    this.data,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success:
          (json['success'] as String?) ?? (json['status'] as String?) ?? '',
      code: (json['code'] as int?) ?? -1,
      message: (json['message'] as String?) ?? '',
      data: json['data'] is Map<String, dynamic>
          ? PaymentStatusData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
