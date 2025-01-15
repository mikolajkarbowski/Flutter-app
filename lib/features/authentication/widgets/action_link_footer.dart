import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import '../../../core/theme/app_theme.dart';

class ActionLinkFooter extends StatelessWidget {
  const ActionLinkFooter(
      {super.key,
      required this.actionText,
      required this.promptText,
      required this.onTap});

  final String promptText;
  final String actionText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: RichText(
        text: TextSpan(
          text: promptText,
          style: AppTheme.bodyLarge,
          children: [
            TextSpan(
                text: actionText,
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ],
        ),
      ),
    );
  }
}
