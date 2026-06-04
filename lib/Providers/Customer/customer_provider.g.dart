// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerNotifier)
final customerProvider = CustomerNotifierProvider._();

final class CustomerNotifierProvider
    extends $AsyncNotifierProvider<CustomerNotifier, List<Customer>> {
  CustomerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerNotifierHash();

  @$internal
  @override
  CustomerNotifier create() => CustomerNotifier();
}

String _$customerNotifierHash() => r'29a4e2ea308aec90fb6d9c230eba325a41023837';

abstract class _$CustomerNotifier extends $AsyncNotifier<List<Customer>> {
  FutureOr<List<Customer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Customer>>, List<Customer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Customer>>, List<Customer>>,
              AsyncValue<List<Customer>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(customerLookups)
final customerLookupsProvider = CustomerLookupsFamily._();

final class CustomerLookupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  CustomerLookupsProvider._({
    required CustomerLookupsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerLookupsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerLookupsHash();

  @override
  String toString() {
    return r'customerLookupsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return customerLookups(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerLookupsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerLookupsHash() => r'955d30514faebc2c3215c4db00793414ce8f366f';

final class CustomerLookupsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  CustomerLookupsFamily._()
    : super(
        retry: null,
        name: r'customerLookupsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerLookupsProvider call(String category) =>
      CustomerLookupsProvider._(argument: category, from: this);

  @override
  String toString() => r'customerLookupsProvider';
}
