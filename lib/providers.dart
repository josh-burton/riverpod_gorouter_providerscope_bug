import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_gorouter_providerscope/main.dart';

///
/// These 2 providers are identical, except one depends on tokeProvider
/// which turns it into a scoped provider
///
final provider = Provider<String>(
  (ref) {
    return random.nextInt(100).toString();
  },
);

final buggyProvider = Provider<String>((ref) {
  return random.nextInt(100).toString();
}, dependencies: [
  tokenProvider,
]);

final tokenProvider = Provider<String>(
  (ref) => throw UnimplementedError(),
);

final refreshProvider = ChangeNotifierProvider(
  (ref) => RefreshNotifier(ref),
);

class RefreshNotifier with ChangeNotifier {
  final Ref ref;

  RefreshNotifier(this.ref) {}

  void refresh() {
    debugPrint("do refresh");
    notifyListeners();
  }
}

final providerOfRouter = Provider<AppGoRouter>(
  (ref) => AppGoRouter(ref),
);
