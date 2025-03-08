import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/loading_indicator.dart';
import '../bloc/auth_cubit.dart';

class AuthActionButton extends StatelessWidget {
  const AuthActionButton({super.key, this.onPressed, this.text});

  final void Function()? onPressed;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),),),
            child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              if (state is SigningInState) {
                return const LoadingIndicator();
              }
              return text != null ? Text(text!) : const Text('');
            },),),
      ),
    );
  }
}
