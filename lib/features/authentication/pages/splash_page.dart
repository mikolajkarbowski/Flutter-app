import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/core/theme/gradient_background_wrapper.dart';
import 'package:memo_deck/features/authentication/bloc/splash_cubit.dart';
import 'package:memo_deck/features/authentication/data/auth_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SplashCubit(authService: serviceLocator<AuthService>())..appStarted(),
      child: Builder(builder: (context) {
        return BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              context.goNamed('SignInPage');
            }
            if (state is Authenticated) {
              context.goNamed('HomePage');
            }
          },
          child: Scaffold(
              backgroundColor: AppTheme.backgroundColor,
              body: GradientBackgroundWrapper(
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Image.asset(
                                  'assets/icon/memo_deck_icon.png')),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LinearProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              )),
        );
      }),
    );
  }
}
