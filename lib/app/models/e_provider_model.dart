/*
 * Copyright (c) 2020 .
 */

import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import '../../common/uuid.dart';
import 'address_model.dart';
import 'availability_hour_model.dart';
import 'category_model.dart';
import 'e_provider_type_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class EProvider extends Model {
  String id;
  String name;
  String description;
  List<Media> images;
  String phoneNumber;
  String mobileNumber;
  // EProviderType type;
  Category category;
  String categoryGet;
  List subcategoryGet;

  List<AvailabilityHour> availabilityHours = [AvailabilityHour('1', '2', '2', '2', '2')];
  double availabilityRange =5;
  bool available;
  bool featured;
  List<Address> addresses;
  // List<Tax> taxes;
  List<Category> subCategory;

  List<User> employees;
  double rate;
  List<Review> reviews;
  int totalReviews;
  bool verified;
  int bookingsInProgress;
  String memId;  String memName;



  EProvider(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.phoneNumber,
      this.mobileNumber,
      this.category,
      this.availabilityHours,
      this.availabilityRange,
      this.available,
      this.featured,
      this.addresses,
      this.employees,
      this.rate,
      this.reviews,
      this.totalReviews,
      this.verified,
      this.bookingsInProgress,this.memId,this.memName});

  EProvider.fromJson(Map<String, dynamic> json) {

    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    categoryGet = stringFromJson(json, 'cat_name');
        // EProviderType.fromJson(v));
    availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    available = boolFromJson(json, 'available');
    featured = boolFromJson(json, 'featured');
    addresses = listFromJson(json, 'addresses', (v) => Address.fromJson(v));
    subcategoryGet = json['sub_cat'] == '' ? [''] :jsonDecode(json['sub_cat']);
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'e_provider_reviews', (v) => Review.fromJson(v));
    totalReviews = reviews.isEmpty ? intFromJson(json, 'total_reviews') : reviews.length;
    verified = boolFromJson(json, 'verified');
    bookingsInProgress = intFromJson(json, 'bookings_in_progress');
    memId = stringFromJson(json, 'mem_id');
    memName = stringFromJson(json, 'mem_assoc');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    // data['addresses'] = this.addresses;
    data['images'] = this.images;

    data['description'] = this.description;
    data['available'] = this.available;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['verified'] = this.verified;
    data['bookings_in_progress'] = this.bookingsInProgress;
    data['availability_range']   =this.availabilityRange;
    data['type'] = this.category;
    data['sub_cat'] = this.subCategory;

    data['mem_id'] = this.memId;
    data['mem_assoc'] = this.memName;
    data['custom_fields'] = [{'sub_cat':this.subCategory}];

    return data;
  }



  Map<String, dynamic> toJsonUpload() {
    print((this.memId == '').toString() + 'checkMemid');

    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    if (available != null) data['available'] = this.available;
    if (phoneNumber != null) data['phone_number'] = this.phoneNumber;
    if (mobileNumber != null) data['mobile_number'] = this.mobileNumber;
    if (rate != null) data['rate'] = this.rate;
    if (totalReviews != null) data['total_reviews'] = this.totalReviews;
    if (verified != null) data['verified'] = this.verified;
    if (this.category != null) {
      data['cat_name'] = this.category.id;
    }
    if (this.images != null) {
      data['image'] = this.images.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v?.id).toList();
    }
    if (this.employees != null) {
      data['employees'] = this.employees.map((v) => v?.id).toList();
    }
    if (this.subCategory != null) {
      data['sub_cat'] = jsonEncode(this.subCategory.map((v) => v?.id).toList());
    }
    if (this.availabilityRange != null) {
      data['availability_range'] = availabilityRange;
    }
    data['e_provider_type_id'] = '3';
    data['taxes'] = ['3'];
    data['mem_assoc'] = this.memName == '' ?'a' : this.memName;
    data['mem_id']= this.memId == '' ?'a' : this.memId;

    return data;
  }


  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  String get firstAddress {
    if (this.addresses.isNotEmpty) {
      return this.addresses.first?.address;
    }
    return '';
  }

  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    this.availabilityHours.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day].add(element.startAt + ' - ' + element.endAt);
      } else {
        result[element.day] = [element.startAt + ' - ' + element.endAt];
      }
    });
    return result;
  }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours.forEach((element) {
      if (element.day == day) {
        result.add(element.data);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is EProvider &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          category == other.category &&
          availabilityRange == other.availabilityRange &&
          available == other.available &&
          featured == other.featured &&
          addresses == other.addresses &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          verified == other.verified &&
          bookingsInProgress == other.bookingsInProgress;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      category.hashCode ^
      availabilityRange.hashCode ^
      available.hashCode ^
      featured.hashCode ^
      addresses.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode ^
      bookingsInProgress.hashCode;
}
