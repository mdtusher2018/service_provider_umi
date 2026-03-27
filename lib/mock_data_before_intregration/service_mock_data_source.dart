// data/data_source/remote/service_mock_data_source.dart

import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

class ServiceMockDataSource implements ServiceRemoteDataSource {
  static const _delay = Duration(milliseconds: 600);

  static final _homeServices = HomeServicesResponse(
    hasMore: true,
    services: [
      ServiceModel(id: 1, name: 'Home', image: 'assets/icons/home.png', hasSubCategory: false),
      ServiceModel(id: 2, name: 'Cleaning', image: 'assets/icons/cleaning.png', hasSubCategory: false),
      ServiceModel(id: 3, name: 'Care', image: 'assets/icons/care.png', hasSubCategory: true),
      ServiceModel(id: 4, name: 'Handyman', image: 'assets/icons/handyman.png', hasSubCategory: false),
      ServiceModel(id: 5, name: 'Pets', image: 'assets/icons/pets.png', hasSubCategory: true),
      ServiceModel(id: 6, name: 'Others', image: 'assets/icons/others.png', hasSubCategory: false),
    ],
  );

  static final _allServices = AllServicesResponse(
    services: [
      ServiceModel(id: 1, name: 'Home', image: 'assets/icons/home.png', hasSubCategory: false),
      ServiceModel(id: 2, name: 'Cleaning', image: 'assets/icons/cleaning.png', hasSubCategory: false),
      ServiceModel(id: 3, name: 'Care', image: 'assets/icons/care.png', hasSubCategory: true),
      ServiceModel(id: 4, name: 'Handyman', image: 'assets/icons/handyman.png', hasSubCategory: false),
      ServiceModel(id: 5, name: 'Pets', image: 'assets/icons/pets.png', hasSubCategory: true),
      ServiceModel(id: 6, name: 'Others', image: 'assets/icons/others.png', hasSubCategory: false),
      ServiceModel(id: 7, name: 'Elderly Care', image: 'assets/icons/elderly.png', hasSubCategory: true),
      ServiceModel(id: 8, name: 'Cooking', image: 'assets/icons/cooking.png', hasSubCategory: false),
    ],
  );

  static final _subCategories = <String, AllServicesResponse>{
    'care': AllServicesResponse(services: [
      ServiceModel(id: 31, name: 'Elderly Care', image: 'assets/icons/elderly.png'),
      ServiceModel(id: 32, name: 'Child Care', image: 'assets/icons/child.png'),
      ServiceModel(id: 33, name: 'Pet Care', image: 'assets/icons/pet.png'),
    ]),
    'pets': AllServicesResponse(services: [
      ServiceModel(id: 51, name: 'Dog Walking', image: 'assets/icons/dog.png'),
      ServiceModel(id: 52, name: 'Pet Sitting', image: 'assets/icons/pet_sit.png'),
    ]),
    'elderly_care': AllServicesResponse(services: [
      ServiceModel(id: 71, name: 'Live-in Care', image: 'assets/icons/live_in.png'),
      ServiceModel(id: 72, name: 'Day Care', image: 'assets/icons/day_care.png'),
      ServiceModel(id: 73, name: 'Palliative Care', image: 'assets/icons/palliative.png'),
    ]),
  };

  @override
  Future<HomeServicesResponse> getHomeServices() async {
    await Future.delayed(_delay);
    return _homeServices;
  }

  @override
  Future<AllServicesResponse> getAllServices() async {
    await Future.delayed(_delay);
    return _allServices;
  }

  @override
  Future<AllServicesResponse> getSubCategories(String serviceType) async {
    await Future.delayed(_delay);
    return _subCategories[serviceType.toLowerCase()] ??
        AllServicesResponse(services: []);
  }
}
