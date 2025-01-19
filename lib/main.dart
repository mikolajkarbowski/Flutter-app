import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/manage_flashcard/pages/manage_flashcard_page.dart';
import 'package:memo_deck/features/authentication/pages/splash_page.dart';
import 'package:memo_deck/features/authentication/firebase/firebase_options.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/quiz/pages/quiz_page.dart';
import 'package:memo_deck/shared/models/flashcard.dart';
import 'features/authentication/pages/sign_in_page.dart';
import 'features/authentication/pages/sign_up_page.dart';
import 'features/home/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await FirebaseFirestore.instance.enableNetwork();
  await initializeDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.appTheme,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'SplashPage',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
        path: '/sign_in',
        name: 'SignInPage',
        builder: (context, state) {
          return SignInPage();
        }),
    GoRoute(
        path: '/sign_up',
        name: 'SignUpPage',
        builder: (context, state) {
          return SignUpPage();
        }),
    GoRoute(
        path: '/home',
        name: 'HomePage',
        builder: (context, state) {
          return HomePage();
        }),
    GoRoute(
        path: '/quiz',
        name: 'QuizPage',
        builder: (context, state) {
          final deckId = state.extra as String;
          return QuizPage(
            deckId: deckId,
          );
        }),
    GoRoute(
        path: '/manage_flashcard/:deckId',
        name: 'ManageFlashcardPage',
        builder: (context, state) {
          final deckEntryId = state.pathParameters['deckId'] as String;
          final flashcard = state.extra as Flashcard?;
          return ManageFlashcardPage(
            selectedDeckId: deckEntryId,
            selectedFlashcard: flashcard,
          );
        })
  ],
);
