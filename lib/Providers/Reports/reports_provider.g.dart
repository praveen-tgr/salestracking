// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DailyActivity)
final dailyActivityProvider = DailyActivityFamily._();

final class DailyActivityProvider
    extends $AsyncNotifierProvider<DailyActivity, List<ActivityRecord>> {
  DailyActivityProvider._({
    required DailyActivityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dailyActivityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyActivityHash();

  @override
  String toString() {
    return r'dailyActivityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DailyActivity create() => DailyActivity();

  @override
  bool operator ==(Object other) {
    return other is DailyActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyActivityHash() => r'9ba1c8ab93204ac204f4258748a4464ae5db746b';

final class DailyActivityFamily extends $Family
    with
        $ClassFamilyOverride<
          DailyActivity,
          AsyncValue<List<ActivityRecord>>,
          List<ActivityRecord>,
          FutureOr<List<ActivityRecord>>,
          String
        > {
  DailyActivityFamily._()
    : super(
        retry: null,
        name: r'dailyActivityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailyActivityProvider call(String date) =>
      DailyActivityProvider._(argument: date, from: this);

  @override
  String toString() => r'dailyActivityProvider';
}

abstract class _$DailyActivity extends $AsyncNotifier<List<ActivityRecord>> {
  late final _$args = ref.$arg as String;
  String get date => _$args;

  FutureOr<List<ActivityRecord>> build(String date);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ActivityRecord>>, List<ActivityRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ActivityRecord>>,
                List<ActivityRecord>
              >,
              AsyncValue<List<ActivityRecord>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(SalesDashboard)
final salesDashboardProvider = SalesDashboardFamily._();

final class SalesDashboardProvider
    extends $AsyncNotifierProvider<SalesDashboard, SalesDashboardMetric> {
  SalesDashboardProvider._({
    required SalesDashboardFamily super.from,
    required ({String fromDate, String toDate, int? userId}) super.argument,
  }) : super(
         retry: null,
         name: r'salesDashboardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesDashboardHash();

  @override
  String toString() {
    return r'salesDashboardProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SalesDashboard create() => SalesDashboard();

  @override
  bool operator ==(Object other) {
    return other is SalesDashboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesDashboardHash() => r'd7a5ddf833446889ac3116e96c21bfe2a7caee7c';

final class SalesDashboardFamily extends $Family
    with
        $ClassFamilyOverride<
          SalesDashboard,
          AsyncValue<SalesDashboardMetric>,
          SalesDashboardMetric,
          FutureOr<SalesDashboardMetric>,
          ({String fromDate, String toDate, int? userId})
        > {
  SalesDashboardFamily._()
    : super(
        retry: null,
        name: r'salesDashboardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalesDashboardProvider call({
    required String fromDate,
    required String toDate,
    int? userId,
  }) => SalesDashboardProvider._(
    argument: (fromDate: fromDate, toDate: toDate, userId: userId),
    from: this,
  );

  @override
  String toString() => r'salesDashboardProvider';
}

abstract class _$SalesDashboard extends $AsyncNotifier<SalesDashboardMetric> {
  late final _$args =
      ref.$arg as ({String fromDate, String toDate, int? userId});
  String get fromDate => _$args.fromDate;
  String get toDate => _$args.toDate;
  int? get userId => _$args.userId;

  FutureOr<SalesDashboardMetric> build({
    required String fromDate,
    required String toDate,
    int? userId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SalesDashboardMetric>, SalesDashboardMetric>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalesDashboardMetric>,
                SalesDashboardMetric
              >,
              AsyncValue<SalesDashboardMetric>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        fromDate: _$args.fromDate,
        toDate: _$args.toDate,
        userId: _$args.userId,
      ),
    );
  }
}
