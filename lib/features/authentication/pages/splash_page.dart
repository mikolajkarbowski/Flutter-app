import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/authentication/bloc/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..appStarted(),
      child: Builder(builder: (context) {
        return BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              context.goNamed('SignInPage');
            }
            if (state is Authenticated) {}
          },
          child: Scaffold(
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }),
    );
  }
}
