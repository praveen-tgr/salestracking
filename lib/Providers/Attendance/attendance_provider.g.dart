// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AttendanceNotifier)
final attendanceProvider = AttendanceNotifierProvider._();

final class AttendanceNotifierProvider
    extends $AsyncNotifierProvider<AttendanceNotifier, List<AttendanceRecord>> {
  AttendanceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceNotifierHash();

  @$internal
  @override
  AttendanceNotifier create() => AttendanceNotifier();
}

String _$attendanceNotifierHash() =>
    r'a2376b86e224ee9f1665315249dfd66daccde32c';

abstract class _$AttendanceNotifier
    extends $AsyncNotifier<List<AttendanceRecord>> {
  FutureOr<List<AttendanceRecord>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AttendanceRecord>>, List<AttendanceRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AttendanceRecord>>,
                List<AttendanceRecord>
              >,
              AsyncValue<List<AttendanceRecord>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
