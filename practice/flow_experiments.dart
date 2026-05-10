import 'dart:async';

import 'package:flow/flow.dart';
import 'package:flow/src/collectors/safe_collector.dart';

class InMemoryCache<T> implements CacheFlow<T> {
  T? _cached;

  @override
  Future<T?> read() async => _cached;

  @override
  Future<void> write(T value) async => _cached = value;

  @override
  FutureOr<Duration> cacheAge() {
    return const Duration(days: 1);
  }

  @override
  FutureOr<void> collect(FutureOr<void> Function(T value) collector) {
    return collector(_cached!);
  }

  @override
  SafeCollector collectSafely(FutureOr<void> Function(T value) collector, [String? name]) {
    final safeCollector = SafeCollector();
    return safeCollector;
  }
}

class BudgetedRetryPolicy implements RetryPolicy {
  final int maxAttempts;
  int _attempts = 0;

  BudgetedRetryPolicy(this.maxAttempts);

  @override
  FutureOr<bool> retry<T>(int attempts) {
    print('Retry attempt: $attempts');
    return _attempts++ < maxAttempts;
  }
}

void header(String title) {
  print('\n${'═' * 60}');
  print('  $title');
  print('${'═' * 60}');
}

void section(String title) {
  print('\n── $title ──');
}

// Creating Flows ────────────────────────────────────────────────────────
Future<void> creationFlow() async {
  header('Creating Flows');
  section('build() Flow');

  await flow<String>((collector) {
     collector.emit('Hello');
     collector.emit('from');
     collector.emit('dart-flow');
  }).collect(print);

  section('flowOf() Flow');
  await flowOf<String>(['Hello', 'from', 'dart-flow']).collect(print);

  section('Flow.empty() with onEmpty fallback');
  await Flow.empty().onEmpty((collection) => collection.emit('No Data Available')).collect(print);
}


// Transform Operators ───────────────────────────────────────────────────

Future<void> transformOperator() async {
  header('Transform Operators');
  section('map — int to formatted currency string');

  await flowOf<int>([100, 200, 500, 1000])
  .map<String>((value) => '\$$value')
  .collect(print);

  // section('flatMap — each element fans out into a new flow');
  // await flowOf(['user:1', 'user:2'])
  //     .flatMap((userId) => flowOf(['$userId:profile', '$userId:settings']))
  //     .collect(print);


  section('filter — only credit transactions');
  await flowOf([
    {'id': 1, 'type': 'credit', 'amount': 500},
    {'id': 2, 'type': 'debit', 'amount': 200},
    {'id': 3, 'type': 'credit', 'amount': 1000},
  ])
  .filter((transaction) => transaction['type'] == 'credit')
   .collect((tx) => print('credit: ₦${tx['amount']}'));

  section('distinctUntilChanged — drops consecutive duplicates');
  await flow<String>((collector){
    collector.emit('Loading');
    collector.emit('Loading');
    collector.emit('Success');
    collector.emit('Success');
    collector.emit('Success');
    collector.emit('Idle');
  }).distinctUntilChanged()
  .collect(print);

  section('startWith — prepend a value before the flow');
  await flowOf(['account_data', 'transaction_data'])
      .startWith('loading_state')
      .collect(print);

  section('asStream — convert Flow to Dart Stream');
  final stream = flowOf([1, 2, 3]).map((v) => v * 10).asStream();
  await stream.forEach(print);
}

// Lifecycle Hooks ───────────────────────────────────────────────────────
Future<void> lifecycleHooks() async {
  header('LIFECYCLE HOOKS');

  section('onStart — runs before collection begins');
  await flow<String>((collector) => collector.emit('World!'))
      .onStart((collector) => collector.emit('Hello,'))
      .collect(print);

  section('onEach — side-effect before each value');
  await flowOf<int>([1, 2, 3])
      .onEach((value) => print('Emitting value: $value'))
      .collect(print);

  section('onEmpty — fallback when flow emits nothing');
  await Flow.empty()
      .onEmpty((collector) => collector.emit('No data available'))
      .collect(print);
}

// Error Handling ────────────────────────────────────────────────────────
Future<void> errorHandling() async {
  header('ERROR HANDLING');

  section('catchError — intercept and emit fallback');
  await flow<int>((collector) {
    collector.emit(1);
    collector.emit(2);
    throw Exception('network timeout');
  }).catchError((error, collector) {
    print('caught: $error');
    collector.emit(-1);
  }).collect(print);
}

// Retry Policies ───────────────────────────────────────────────────────
Future<void> retryPolicies() async {
  header('RETRY POLICIES');

  section('retryWhen — manual predicate (retry on 502, max 3 times)');
  int attempt = 0;
  await flow<String>((collector) {
    attempt++;
    print('attempt $attempt');
    collector.emit('A');
    if (attempt < 3) throw Exception('502 Bad Gateway');
    collector.emit('success!');
  }).retryWhen((cause, attempts) => cause.toString().contains('502') && attempts < 3).collect(print);

  section('retryWith — ExponentialBackOff');
  print('(simulated — doubles delay: 1s → 2s → 4s → 8s...)');
  await flow<String>((collector) {
    collector.emit('attempting...');
    throw Exception('service unavailable');
  }).retryWith((cause) => RetryPolicy.exponentialBackOff(maxAttempts: 2))
      .catchError((e, c) => print('gave up after retries: $e'))
      .collect(print);

  section('retryWith — CircuitBreaker');
  print('(trips after N failures, blocks retries for timeout period)');
  await flow<String>((collector) {
    collector.emit('ping');
    throw Exception('host unreachable');
  })
      .retryWith((cause) => RetryPolicy.circuitBreaker(maxAttempts: 2))
      .catchError((e, c) => print('circuit open: $e'))
      .collect(print);

  section('retryWith — FixedInterval');
  print('(retries at constant 3s intervals)');
  await flow<String>((collector) {
    collector.emit('checking...');
    throw Exception('not ready yet');
  })
      .retryWith((cause) => RetryPolicy.fixedInterval(maxAttempts: 2))
      .catchError((e, c) => print('max retries reached: $e'))
      .collect(print);

  section('retryWith — DecorrelatedJitter');
  print('(retries with random jitter)');
  await flow<String>((collector) {
    collector.emit('checking...');
    throw Exception('not ready yet');
  })
      .retryWith((cause) => RetryPolicy.decorrelatedJitter(maxAttempts: 2))
      .catchError((e, c) => print('max retries reached: $e'))
      .collect(print);

  section('retryWith — LinearBackoff');
  print(' (delay grows by fixed increment: 1s → 2s → 3s → 4s...)');
  await flow<String>((collector) {
    collector.emit('connecting...');
    throw Exception('connection refused');
  })
      .retryWith((cause) => RetryPolicy.linearBackoff(maxAttempts: 2))
      .catchError((e, c) => print('  gave up: $e'))
      .collect(print);

  section('retryWith — RandomisedBackoff');
  print('(pure random delay each attempt)');
  await flow<String>((collector) {
    collector.emit('submit');
    throw Exception('timeout');
  })
      .retryWith((cause) => RetryPolicy.randomisedBackoff(maxAttempts: 2))
      .catchError((e, c) => print('gave up: $e'))
      .collect(print);

  section('retryWith — NoRetry');
  print('(never retry)');
  await flow<String>((collector) {
    collector.emit('submit');
    throw Exception('timeout');
  })
      .retryWith((cause) => RetryPolicy.noRetry())
      .catchError((e, c) => print('gave up: $e'))
      .collect(print);
}

// Combination Operators ─────────────────────────────────────────────────
Future<void> combinationOperator() async {
  header('COMBINATION OPERATORS');
  section('merge — merge multiple flows into one');

  final flow1 = flowOf([1, 2, 3]);
  final flow2 = flowOf(['a', 'b', 'c']);
  await Flow.merge([flow1, flow2]).collect(print);

  section('merge - merge sequential collection of mutilple flows');
  final creditFlow = flowOf([1000, 2000, 3000]);
  final debitFlow = flowOf([500, 1000, 1500]);

  await Flow.merge([creditFlow, debitFlow]).collect(print);

  section('combineLatest — combine newest values from all flows');
  final flow3 = flowOf([1, 2, 3]);
  final flow4 = flowOf(['a', 'b', 'c']);
  await Flow
      .combineLatest(
          [flow3, flow4],
          (values) => '${values[0]} ${values[1]}')
      .collect(print);

  section('combineLatest - combine sequential collection of mutilple flows');
  final balanceFlow = flowOf([1000, 2000, 3000]);
  final currencyFlow = flowOf(['USD', 'EUR', 'GBP']);
  await Flow
      .combineLatest(
          [balanceFlow, currencyFlow],
          (values) => '${values[0]} ${values[1]}')
      .collect(print);

  section('race — emit only from the first flow to produce a value');
  final flow5 = flowOf([1, 2, 3]);
  final flow6 = flowOf(['a', 'b', 'c']);
  await Flow.race([flow5, flow6]).collect(print);

  section('race — emit only from the first flow to produce a value');
  final slowFlow = flow<String>((collector) async {
    await Future.delayed(const Duration(milliseconds: 300));
    collector.emit('slow: primary data');
  });
  final fastFlow = flow<String>((collector) async {
    collector.emit('fast: cached data');
  });
  await Flow.race([slowFlow, fastFlow]).collect(print);

  section('raceWith — extension method variant');
  await slowFlow.raceWith([fastFlow]).collect(print);
}

// Caching ───────────────────────────────────────────────────────────────
Future<void> cachingExamples() async {
  header('CACHING');
  section('FetchOrElseCache — try source first, fall back to cache on error');

  final fetchCache = InMemoryCache<String>();
  await flow<String>((collector) {
    collector.emit('live: account balance ₦24,500');
  }).cache(fetchCache, FetchOrElseCache()).collect(print);
  print('(cached value: ${await fetchCache.read()})');

  section('FetchOrElseCache — try source first, fall back to cache on error');
  await flow<String>((collector) {
    collector.emit('live: account balance ₦24,500');
  }).cache(fetchCache, FetchOrElseCache()).collect(print);
  print('(cached value: ${await fetchCache.read()})');


  section('CacheThenFetch — serve cache instantly, then emit fresh data');
  final ctfCache = InMemoryCache<String>();
  await flow<String>((collector) {
    collector.emit('live: account balance ₦24,500');
  }).cache(ctfCache, CacheThenFetch()).collect(print);
  print('(cached value: ${await ctfCache.read()})');
}

Future<void> realWorldPipeline() async {
  header('REAL-WORLD: ANALYTICS EVENT PIPELINE');

  await flow<String>((collector) {
    collector.emit('app_open');
    collector.emit('app_open');
    collector.emit('screen_view');
    collector.emit('button_tap');
    collector.emit('button_tap');
  })
      .onStart((_) => print('[sdk] starting event flush'))
      .distinctUntilChanged()
      .onEach((event) => print('[track] $event'))
      .map((event) => {
    'event': event,
    'ts': DateTime.now().toIso8601String(),
  })
      .retryWith((e) => RetryPolicy.exponentialBackOff())
      .catchError((e, c) => print('[error] $e'))
      .onCompletion((_, __) => print('[sdk] flush complete'))
      .collect((payload) => print('[send]  $payload'));
}


void main() async {
  await creationFlow();
  await transformOperator();
  await lifecycleHooks();
  await errorHandling();
  await retryPolicies();
  await combinationOperator();
  await cachingExamples();
  await realWorldPipeline();
}