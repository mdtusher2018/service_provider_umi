import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/availability_model.dart';

// ─── Args ─────────────────────────────────────────────────────
typedef AvailabilityArgs = ({
  String providerId,
  DateTime date,
  int slotDurationMinutes,
});

// ─── State ────────────────────────────────────────────────────
class AvailabilityState {
  final AsyncValue<List<AvailabilitySlot>> slots;

  const AvailabilityState({this.slots = const AsyncData([])});

  AvailabilityState copyWith({AsyncValue<List<AvailabilitySlot>>? slots}) =>
      AvailabilityState(slots: slots ?? this.slots);
}

// ─── Notifier ─────────────────────────────────────────────────
class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  final Ref _ref;
  final AvailabilityArgs _args;

  AvailabilityNotifier(this._ref, this._args)
    : super(const AvailabilityState());

  Future<void> fetch() async {
    state = state.copyWith(slots: const AsyncLoading());

    final request = AvailabilityRequest(
      providerId: _args.providerId,
      date: _args.date,
      slotDuration: _args.slotDurationMinutes,
    );

    final result = await _ref
        .read(serviceRepositoryProvider)
        .getAvailability(request);

    if (!mounted) return;

    state = state.copyWith(
      slots: result.when(
        success: AsyncData.new,
        failure: (e) => AsyncError(e, StackTrace.current),
      ),
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────
final availabilityProvider =
    StateNotifierProvider.family<
      AvailabilityNotifier,
      AvailabilityState,
      AvailabilityArgs
    >((ref, args) => AvailabilityNotifier(ref, args));
