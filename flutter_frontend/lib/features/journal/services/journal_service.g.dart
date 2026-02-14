// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journalService)
const journalServiceProvider = JournalServiceProvider._();

final class JournalServiceProvider
    extends $FunctionalProvider<JournalService, JournalService, JournalService>
    with $Provider<JournalService> {
  const JournalServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalServiceHash();

  @$internal
  @override
  $ProviderElement<JournalService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JournalService create(Ref ref) {
    return journalService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JournalService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JournalService>(value),
    );
  }
}

String _$journalServiceHash() => r'79c11e5bc810fcca3adae6a375d5c8abebf2a3ec';
