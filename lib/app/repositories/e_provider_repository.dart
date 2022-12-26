import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_provider_type_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../models/tax_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class EProviderRepository {
  LaravelApiClient _laravelApiClient;

  EProviderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<EProvider> get(String eProviderId) {
    return _laravelApiClient.getEProvider(eProviderId);
  }

  Future<List<EProvider>> getAll() {
    return _laravelApiClient.getAllEproviders();
  }

  Future<List<Review>> getReviews(String eProviderId) {
    return _laravelApiClient.getEProviderReviews(eProviderId);
  }

  Future<List<Gallery>> getGalleries(String eProviderId) {
    return _laravelApiClient.getEProviderGalleries(eProviderId);
  }

  Future<List<Award>> getAwards(String eProviderId) {
    return _laravelApiClient.getEProviderAwards(eProviderId);
  }

  Future<List<Experience>> getExperiences(String eProviderId) {
    return _laravelApiClient.getEProviderExperiences(eProviderId);
  }

  Future<List<EService>> getEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderEServices(eProviderId, page);
  }

  Future<List<User>> getEmployees(String eProviderId) {
    return _laravelApiClient.getEProviderEmployees(eProviderId);
  }

  Future<List<EService>> getPopularEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderPopularEServices(eProviderId, page);
  }

  Future<List<EService>> getMostRatedEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderMostRatedEServices(eProviderId, page);
  }

  Future<List<EService>> getAvailableEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderAvailableEServices(eProviderId, page);
  }

  Future<List<EService>> getFeaturedEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderFeaturedEServices(eProviderId, page);
  }

  Future<List<EProvider>> getEProviders({int page}) {
    return _laravelApiClient.getEProviders(page);
  }

  Future<List<EProviderType>> getEProviderTypes() {
    return _laravelApiClient.getEProviderTypes();
  }

  /**
   * Get the User's address
   */
  Future<List<Address>> getAddresses() {
    return _laravelApiClient.getAddresses();
  }

  /**
   * Create a User's address
   */
  Future<Address> createAddress(Address address) {
    return _laravelApiClient.createAddress(address);
  }

  Future<Address> updateAddress(Address address) {
    return _laravelApiClient.updateAddress(address);
  }

  Future<Address> deleteAddress(Address address) {
    return _laravelApiClient.deleteAddress(address);
  }

  // Future<List<AvailabilityHour>> getAvailabilityHours(EProvider eProvider) {
  //   return _laravelApiClient.getAvailabilityHours(eProvider);
  // }
  //
  // Future<AvailabilityHour> createAvailabilityHour(AvailabilityHour availabilityHour) {
  //   return _laravelApiClient.createAvailabilityHour(availabilityHour);
  // }
  //
  // Future<AvailabilityHour> deleteAvailabilityHour(AvailabilityHour availabilityHour) {
  //   return _laravelApiClient.deleteAvailabilityHour(availabilityHour);
  // }

  Future<List<EProvider>> getAcceptedEProviders({int page}) {
    return _laravelApiClient.getAcceptedEProviders(page);
  }

  Future<List<EProvider>> getFeaturedEProviders({int page}) {
    return _laravelApiClient.getFeaturedEProviders(page);
  }

  Future<List<EProvider>> getPendingEProviders({int page}) {
    return _laravelApiClient.getPendingEProviders(page);
  }

  Future<User> create(EProvider eProvider) {
    return _laravelApiClient.createEProvider(eProvider);
  }

  Future<User> update(EProvider eProvider) {
    return _laravelApiClient.updateEProvider(eProvider);
  }

  Future<User> delete(EProvider eProvider) {
    return _laravelApiClient.deleteEProvider(eProvider);
  }

  Future<List<User>> getAllEmployees() {
    return _laravelApiClient.getAllEmployees();
  }

  Future<List<Tax>> getTaxes() {
    return _laravelApiClient.getTaxes();
  }

}
