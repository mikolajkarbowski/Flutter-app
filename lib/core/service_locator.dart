import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';
import 'package:memo_deck/features/activity_tracker/logic/study_session_manager.dart';
import 'package:memo_deck/features/home/bloc/deck_management_cubit.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';

import '../features/authentication/data/auth_service.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  serviceLocator..registerSingleton<AuthService>(
      AuthService(firebaseInstance: FirebaseAuth.instance),)
  ..registerSingleton<FlashcardsDataSource>(FlashcardsDataSource(
      authService: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,),)
  ..registerSingleton<ActivityHistoryDataSource>(
      ActivityHistoryDataSource(
          authService: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,),)
  ..registerSingleton<DeckManagementCubit>(
      DeckManagementCubit(dataSource: serviceLocator<FlashcardsDataSource>()),)
  ..registerSingleton<StudySessionManager>(StudySessionManager(
      dataSource: serviceLocator<ActivityHistoryDataSource>(),),);
}
