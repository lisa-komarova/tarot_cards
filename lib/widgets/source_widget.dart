import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';

/// Displays a tappable text link pointing to an external source.
///
/// When tapped, the widget attempts to open the provided URL
/// using the system browser
class SourceWidget extends StatelessWidget {
  /// URL of the external source to be opened.
  final String url;
  const SourceWidget({
    super.key,
    required this.url,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = (() => {launchUrl(Uri.parse(url))}),
              text: AppLocalizations.of(context).source,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontStyle: FontStyle.italic)),
        ),
      ),
    );
  }
}
