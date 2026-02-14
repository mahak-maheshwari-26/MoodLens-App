// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recentJournals)
const recentJournalsProvider = RecentJournalsProvider._();

final class RecentJournalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<JournalListResponse>,
          JournalListResponse,
          FutureOr<JournalListResponse>
        >
    with
        $FutureModifier<JournalListResponse>,
        $FutureProvider<JournalListResponse> {
  const RecentJournalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentJournalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentJournalsHash();

  @$internal
  @override
  $FutureProviderElement<JournalListResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JournalListResponse> create(Ref ref) {
    return recentJournals(ref);
  }
}

String _$recentJournalsHash() => r'38c13f9ec577cb285337fcd2eebcc5cf7c4a66e7';

@ProviderFor(journalStats)
const journalStatsProvider = JournalStatsProvider._();

final class JournalStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<JournalStats>,
          JournalStats,
          FutureOr<JournalStats>
        >
    with $FutureModifier<JournalStats>, $FutureProvider<JournalStats> {
  const JournalStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalStatsHash();

  @$internal
  @override
  $FutureProviderElement<JournalStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JournalStats> create(Ref ref) {
    return journalStats(ref);
  }
}

String _$journalStatsHash() => r'a4bbe0faa09402ce38936e0783d8cfe53da8db22';

@ProviderFor(JournalNotifier)
const journalProvider = JournalNotifierProvider._();

final class JournalNotifierProvider
    extends $AsyncNotifierProvider<JournalNotifier, JournalListResponse> {
  const JournalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalNotifierHash();

  @$internal
  @override
  JournalNotifier create() => JournalNotifier();
}

String _$journalNotifierHash() => r'3df46eac750078173dbcc079e498dc3e5b1ce92e';

abstract class _$JournalNotifier extends $AsyncNotifier<JournalListResponse> {
  FutureOr<JournalListResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<JournalListResponse>, JournalListResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<JournalListResponse>, JournalListResponse>,
              AsyncValue<JournalListResponse>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
