// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalizationNotifier)
final localizationProvider = LocalizationNotifierProvider._();

final class LocalizationNotifierProvider
    extends $AsyncNotifierProvider<LocalizationNotifier, Locale> {
  LocalizationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localizationNotifierHash();

  @$internal
  @override
  LocalizationNotifier create() => LocalizationNotifier();
}

String _$localizationNotifierHash() =>
    r'211b038c807dfbbc1d363e2c4eda9997c03504d2';

abstract class _$LocalizationNotifier extends $AsyncNotifier<Locale> {
  FutureOr<Locale> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Locale>, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Locale>, Locale>,
              AsyncValue<Locale>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
