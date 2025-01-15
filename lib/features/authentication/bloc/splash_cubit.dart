import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.displaySplash());
  void appStarted() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashState.unAuthenticated());
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
