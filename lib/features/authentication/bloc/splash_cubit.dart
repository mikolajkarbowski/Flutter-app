import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_service.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required this.authService}) : super(SplashState.displaySplash());

  final AuthService authService;
  Future<void> appStarted() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (authService.isSignedIn) {
      emit(SplashState.authenticated());
    } else {
      emit(SplashState.unAuthenticated());
    }
  }
}

sealed class SplashState {
  SplashState();
  factory SplashState.displaySplash() = DisplaySplash;
  factory SplashState.authenticated() = Authenticated;
  factory SplashState.unAuthenticated() = UnAuthenticated;
}

class DisplaySplash extends SplashState {}

class Authenticated extends SplashState {}

class UnAuthenticated extends SplashState {}
