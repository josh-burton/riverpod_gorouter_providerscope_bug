import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_gorouter_providerscope/providers.dart';

Random random = Random();

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

const keyIdentifier = ValueKey("identifier");

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: ref.read(providerOfRouter).router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AppGoRouter {
  final Ref ref;
  late final GoRouter router;

  AppGoRouter(this.ref) {
    router = GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: ref.read(refreshProvider),
      initialLocation: "/home",
      routes: [
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Scaffold(
              body: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.push('/home/bug');
                      },
                      child: const Text("bug"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/home/no-bug');
                      },
                      child: const Text("no bug"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          routes: [
            GoRoute(
              path: "bug",
              pageBuilder: (context, state) {
                debugPrint("Build bug page");
                return NoTransitionPage(
                  key: state.pageKey,
                  child: ProviderScope(
                    overrides: [
                      tokenProvider.overrideWithValue(""),
                    ],
                    child: ProviderPage(
                      provider: buggyProvider,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path: "no-bug",
              pageBuilder: (context, state) {
                debugPrint("Build no bug page");
                return NoTransitionPage(
                  key: state.pageKey,
                  child: ProviderScope(
                    overrides: [
                      tokenProvider.overrideWithValue(""),
                    ],
                    child: ProviderPage(
                      provider: provider,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ProviderPage extends ConsumerWidget {
  final Provider<String> provider;

  const ProviderPage({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, ref) {
    final identifier = ref.watch(provider);
    return Center(
      child: Column(
        children: [
          Text(
            identifier,
            key: keyIdentifier,
          ),
        ],
      ),
    );
  }
}
