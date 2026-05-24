import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/website_models.dart';
import 'package:service_provider_umi/data/repository/website_repository.dart';

part 'website_provider.g.dart';

class WebsiteState {
  final List<WebsiteServiceModel> services;
  final List<AboutUsModel> aboutUs;

  const WebsiteState({this.services = const [], this.aboutUs = const []});

  WebsiteState copyWith({
    List<WebsiteServiceModel>? services,
    List<AboutUsModel>? aboutUs,
  }) {
    return WebsiteState(
      services: services ?? this.services,
      aboutUs: aboutUs ?? this.aboutUs,
    );
  }
}

@Riverpod(keepAlive: true)
class WebsiteNotifier extends _$WebsiteNotifier {
  @override
  AsyncValue<WebsiteState> build() {
    _fetchAll();
    return const AsyncLoading();
  }

  WebsiteRepository get _repo => ref.read(websiteRepositoryProvider);

  Future<void> _fetchAll() async {
    state = const AsyncLoading();

    final results = await Future.wait([
      _repo.getAllCategories(),
      _repo.getAllAboutUs(),
    ]);

    if (!ref.mounted) return;

    final servicesResult = results[0] as dynamic;
    final aboutUsResult = results[1] as dynamic;

    List<WebsiteServiceModel>? services;
    List<AboutUsModel>? aboutUs;
    Object? error;
    StackTrace? trace;

    servicesResult.when(
      success: (data) => services = data as List<WebsiteServiceModel>,
      failure: (f) {
        error = f;
        trace = StackTrace.current;
      },
    );

    if (error != null) {
      state = AsyncError(error!, trace!);
      return;
    }

    aboutUsResult.when(
      success: (data) => aboutUs = data as List<AboutUsModel>,
      failure: (f) {
        error = f;
        trace = StackTrace.current;
      },
    );

    if (error != null) {
      state = AsyncError(error!, trace!);
      return;
    }

    state = AsyncData(
      WebsiteState(services: services ?? [], aboutUs: aboutUs ?? []),
    );
  }

  /// Public retry — re-fetches everything
  Future<void> refresh() => _fetchAll();
}
