// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeData)
final homeDataProvider = HomeDataProvider._();

final class HomeDataProvider extends $AsyncNotifierProvider<HomeData, void> {
  HomeDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDataHash();

  @$internal
  @override
  HomeData create() => HomeData();
}

String _$homeDataHash() => r'a88fecd4d781dd229df1f9145a680064f43ed3a4';

abstract class _$HomeData extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentCheckIn)
final currentCheckInProvider = CurrentCheckInFamily._();

final class CurrentCheckInProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  CurrentCheckInProvider._({
    required CurrentCheckInFamily super.from,
    required ({int userId, String terant}) super.argument,
  }) : super(
         retry: null,
         name: r'currentCheckInProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentCheckInHash();

  @override
  String toString() {
    return r'currentCheckInProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as ({int userId, String terant});
    return currentCheckIn(
      ref,
      userId: argument.userId,
      terant: argument.terant,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentCheckInProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentCheckInHash() => r'8081d6765892102ec61ad2fda4069ebf5162f79b';

final class CurrentCheckInFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({int userId, String terant})
        > {
  CurrentCheckInFamily._()
    : super(
        retry: null,
        name: r'currentCheckInProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrentCheckInProvider call({required int userId, required String terant}) =>
      CurrentCheckInProvider._(
        argument: (userId: userId, terant: terant),
        from: this,
      );

  @override
  String toString() => r'currentCheckInProvider';
}

@ProviderFor(appointmentList)
final appointmentListProvider = AppointmentListFamily._();

final class AppointmentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  AppointmentListProvider._({
    required AppointmentListFamily super.from,
    required ({int userId, String terant, String date}) super.argument,
  }) : super(
         retry: null,
         name: r'appointmentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentListHash();

  @override
  String toString() {
    return r'appointmentListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument =
        this.argument as ({int userId, String terant, String date});
    return appointmentList(
      ref,
      userId: argument.userId,
      terant: argument.terant,
      date: argument.date,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentListHash() => r'780ac2a8456beacdfc562011fbe506c199cb3979';

final class AppointmentListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Map<String, dynamic>>>,
          ({int userId, String terant, String date})
        > {
  AppointmentListFamily._()
    : super(
        retry: null,
        name: r'appointmentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppointmentListProvider call({
    required int userId,
    required String terant,
    required String date,
  }) => AppointmentListProvider._(
    argument: (userId: userId, terant: terant, date: date),
    from: this,
  );

  @override
  String toString() => r'appointmentListProvider';
}

@ProviderFor(UserData)
final userDataProvider = UserDataProvider._();

final class UserDataProvider
    extends $AsyncNotifierProvider<UserData, Map<String, dynamic>> {
  UserDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataHash();

  @$internal
  @override
  UserData create() => UserData();
}

String _$userDataHash() => r'3024225ecdff94e1ff4b999437745aba5447099c';

abstract class _$UserData extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
