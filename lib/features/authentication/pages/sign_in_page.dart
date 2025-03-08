import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/core/theme/gradient_background_wrapper.dart';
import 'package:memo_deck/features/authentication/bloc/auth_cubit.dart';
import 'package:memo_deck/features/authentication/widgets/action_link_footer.dart';
import 'package:memo_deck/features/authentication/widgets/auth_action_button.dart';
import 'package:memo_deck/features/authentication/widgets/password_field.dart';
import 'package:memo_deck/shared/utilities/snack_bar_utils.dart';

import '../data/auth_service.dart';
import '../widgets/email_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(authService: serviceLocator<AuthService>()),
      child: Builder(builder: (context) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignedInState) {
              context.goNamed('HomePage');
            }
            if (state is SignedOutState && state.error != null) {
              SnackBarUtils.showErrorSnackBar(context, state.error!);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('MemoDeck'),
              flexibleSpace: const GradientBackgroundWrapper(),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.cardShadowColor,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Sign in',
                            style: AppTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          EmailField(
                            controller: _emailController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          PasswordField(
                              controller: _passwordController,
                              validator: _passwordValidator,),
                          const SizedBox(
                            height: 10,
                          ),
                          AuthActionButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final cubit = context.read<AuthCubit>();
                                await cubit.signInWithEmail(
                                    _emailController.text,
                                    _passwordController.text,);
                              }
                            },
                            text: 'Log in',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ActionLinkFooter(
                            promptText: "Don't have an account? ",
                            actionText: 'Create one',
                            onTap: () {
                              context.pushNamed('SignUpPage');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },),
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password field cannot be empty';
    }
    return null;
  }
}
