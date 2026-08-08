import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/string_ext.dart';
import 'package:service_provider_umi/data/models/work_schedule_model.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

import '../../../../../../../core/di/app_role_provider.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
part '_schedule_dialog.dart';
part '_widgets.dart';

// ─── Ordered day metadata ─────────────────────────────────────────────────────

const _kDayMeta = [
  (label: 'Monday', code: 'Mon'),
  (label: 'Tuesday', code: 'Tue'),
  (label: 'Wednesday', code: 'Wed'),
  (label: 'Thursday', code: 'Thu'),
  (label: 'Friday', code: 'Fri'),
  (label: 'Saturday', code: 'Sat'),
  (label: 'Sunday', code: 'Sun'),
];

// ─── Builds the full 7-row list from the API response ────────────────────────
// Days present in [apiData]  → use API values (status, startTime, endTime).
// Days missing from [apiData] → inserted with status=false, 09:00–18:00.
// If [apiData] is empty every day gets status=false (all-off).

List<WorkScheduleModel> _buildDayList(List<WorkScheduleModel> apiData) {
  return _kDayMeta.map((meta) {
    final match = apiData.where((m) => m.day == meta.code).firstOrNull;
    return match ??
        WorkScheduleModel(
          id: '',
          userId: '',
          day: meta.code,
          startTime: DateTime.utc(2026, 3, 30, 9, 0), // 09:00 default
          endTime: DateTime.utc(2026, 3, 30, 18, 0), // 18:00 default
          status: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }).toList();
}

// ─── Used only by the time-picker dialog ─────────────────────────────────────

class _TimeRange {
  final TimeOfDay from;
  final TimeOfDay to;
  const _TimeRange(this.from, this.to);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class WorkScheduleScreen extends ConsumerStatefulWidget {
  final bool isFromProfile;

  const WorkScheduleScreen({
    super.key,
    this.isFromProfile = false,
  });

  @override
  ConsumerState<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends ConsumerState<WorkScheduleScreen> {
  /// Working copy of the schedule rows.
  /// Stays null until the GET response arrives (drives the loading state).
  List<WorkScheduleModel>? _days;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(workScheduleProvider.notifier).fetch(ref);
    });
    super.initState();
  }

  // ── Seed once – called from build() via whenData ──────────────────────────

  void _seedFromApi(List<WorkScheduleModel> apiData) {
    if (_days != null) return; // already seeded, don't overwrite user edits
    setState(() => _days = _buildDayList(apiData));
  }

  // ── Toggle a day on / off ─────────────────────────────────────────────────

  void _toggleDay(int index, bool value) {
    if (_days == null) return;
    setState(() {
      final d = _days![index];
      _days![index] = WorkScheduleModel(
        id: d.id,
        userId: d.userId,
        day: d.day,
        startTime: d.startTime,
        endTime: d.endTime,
        status: value,
        createdAt: d.createdAt,
        updatedAt: d.updatedAt,
      );
    });
  }

  // ── Open the time-picker dialog ───────────────────────────────────────────

  Future<void> _openSchedulePicker(int index) async {
    if (_days == null) return;
    final d = _days![index];
    final localStart = d.startTime.toLocal();
    final localEnd = d.endTime.toLocal();

    final result = await showGeneralDialog<_TimeRange>(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      pageBuilder: (_, _, _) => _ScheduleDialog(
        dayName: _kDayMeta.firstWhere((m) => m.code == d.day).label,
        initialFrom: TimeOfDay(
          hour: localStart.hour,
          minute: localStart.minute,
        ),
        initialTo: TimeOfDay(hour: localEnd.hour, minute: localEnd.minute),
      ),
    );

    if (result != null) {
      setState(() {
        // Keep same calendar date; only replace hour/minute.
        final newStart = DateTime(
          localStart.year,
          localStart.month,
          localStart.day,
          result.from.hour,
          result.from.minute,
        ).toUtc();

        final newEnd = DateTime(
          localEnd.year,
          localEnd.month,
          localEnd.day,
          result.to.hour,
          result.to.minute,
        ).toUtc();

        _days![index] = WorkScheduleModel(
          id: d.id,
          userId: d.userId,
          day: d.day,
          startTime: newStart,
          endTime: newEnd,
          status: d.status,
          createdAt: d.createdAt,
          updatedAt: d.updatedAt,
        );
      });
    }
  }

  // ── Build the POST / PATCH body ───────────────────────────────────────────

  List<WorkScheduleRequest> _buildRequestBody(String userId) => (_days ?? [])
      .map(
        (d) => WorkScheduleRequest(
          day: d.day,
          userId: userId.isNotEmpty ? userId : d.userId,
          startTime: d.startTime,
          endTime: d.endTime,
          status: d.status,
        ),
      )
      .toList();

  // ── Confirm / save ────────────────────────────────────────────────────────

  Future<void> _onConfirm({
    required bool isUpdate,
    required String userId,
  }) async {
    final ok = await ref
        .read(saveWorkScheduleProvider.notifier)
        .save(schedules: _buildRequestBody(userId), isUpdate: isUpdate);

    if (!mounted) return;

    if (ok) {
      if (widget.isFromProfile) {
        if (context.canPop()) {
          context.pop();
        } else {
          if (kIsWeb) {
            context.go(AppRoutes.providerProfile);
          } else {
            context.push(AppRoutes.providerProfile);
          }
        }
      } else {
        if (kIsWeb) {
          context.go(AppRoutes.filter);
        } else {
          context.push(AppRoutes.filter);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save schedule. Try again.')),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    // 1️⃣  Watch the GET provider.
    final scheduleAsync = ref.watch(workScheduleProvider);

    // 2️⃣  As soon as data arrives, seed _days (no-op on subsequent rebuilds).
    scheduleAsync.whenData((response) => _seedFromApi(response.data));

    // 3️⃣  Loading = API still in-flight OR _days not yet populated.
    final isLoading = scheduleAsync is AsyncLoading || _days == null;

    final saveState = ref.watch(saveWorkScheduleProvider);
    final isSaving = saveState is AsyncLoading;

    // PATCH when the server already has records, POST otherwise.
    final isUpdate = false;
    //  scheduleAsync.value?.data.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: (kIsWeb)
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: primary,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.h1(AppLocalizations.of(context)!.workSchedule, color: AppColors.textPrimary),
            4.verticalSpace,
            AppText.bodySm(AppLocalizations.of(context)!.whenAreYouAvailable),
            24.verticalSpace,

            // ── Loading spinner until API responds ───────────────────────
            if (isLoading)
              const Expanded(child: AppLoader())
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _days!.length,
                  separatorBuilder: (_, __) => 16.verticalSpace,
                  itemBuilder: (_, i) {
                    final d = _days![i];
                    final String code = d.day;
                    String localizedLabel = code;
                    switch (code) {
                      case 'Mon':
                        localizedLabel = AppLocalizations.of(context)!.monday;
                        break;
                      case 'Tue':
                        localizedLabel = AppLocalizations.of(context)!.tuesday;
                        break;
                      case 'Wed':
                        localizedLabel = AppLocalizations.of(context)!.wednesday;
                        break;
                      case 'Thu':
                        localizedLabel = AppLocalizations.of(context)!.thursday;
                        break;
                      case 'Fri':
                        localizedLabel = AppLocalizations.of(context)!.friday;
                        break;
                      case 'Sat':
                        localizedLabel = AppLocalizations.of(context)!.saturday;
                        break;
                      case 'Sun':
                        localizedLabel = AppLocalizations.of(context)!.sunday;
                        break;
                    }

                    final localStart = d.startTime.toLocal();
                    final localEnd = d.endTime.toLocal();

                    return _DayRow(
                      // Adapt these named params to match your _DayRow widget.
                      dayLabel: localizedLabel,
                      isAvailable: d.status,
                      from: TimeOfDay(
                        hour: localStart.hour,
                        minute: localStart.minute,
                      ),
                      to: TimeOfDay(
                        hour: localEnd.hour,
                        minute: localEnd.minute,
                      ),
                      primary: primary,
                      onToggle: (v) => _toggleDay(i, v),
                      onTapTime: d.status ? () => _openSchedulePicker(i) : null,
                    );
                  },
                ),
              ),

            // ── Confirm button ───────────────────────────────────────────
            AppButton(
              label: isSaving ? 'Saving…' : 'Confirm',
              onPressed: (isSaving || isLoading)
                  ? null
                  : () async {
                      final token =
                          await ref
                                  .read(localStorageProvider)
                                  .read(StorageKey.accessToken)
                              as String? ??
                          "";

                      _onConfirm(
                        isUpdate: isUpdate,
                        userId: token.decodeJwt['userId'],
                      );
                    },
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
