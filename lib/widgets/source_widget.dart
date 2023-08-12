import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceWidget extends StatelessWidget {
  final String url;
  const SourceWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

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
              text: "Источник",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontStyle: FontStyle.italic)),
        ),
      ),
    );
  }
}
