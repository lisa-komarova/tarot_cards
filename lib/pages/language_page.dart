import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/locale_bloc.dart';
import '../bloc/locale_event.dart';
import '../l10n/app_localizations.dart';
import 'main_page.dart';

/// Language selection screen shown on the first app launch.
///
/// Allows the user to choose the application language.
/// The selected locale is persisted and applied immediately.
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).chooseLang,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              _LangButton(
                text: 'English',
                onTap: () => _select(context, 'en'),
              ),
              const SizedBox(height: 16),
              _LangButton(
                text: 'Русский',
                onTap: () => _select(context, 'ru'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Persists the selected language, updates the active locale,
  /// and navigates to the main application screen.
  ///
  /// [code] must be a valid ISO language code (e.g. 'en', 'ru').
  Future<void> _select(BuildContext context, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', code);

    context.read<LocaleBloc>().add(
          ChangeLocale(
            locale: Locale(code),
            category: code == 'ru' ? 'Старшие арканы' : 'Major Arcana',
          ),
        );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }
}

/// Reusable button widget used for language selection.
///
/// Displays a localized label and triggers [onTap]
/// when the user selects a language.
class _LangButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LangButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(text,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 20)),
        ),
      ),
    );
  }
}
