import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taro_cards/database/cards_database.dart';
import 'package:taro_cards/models/spread_card_interpretation.dart';
import 'package:taro_cards/models/tarot_card.dart';

import '../bloc/locale_bloc.dart';
import '../l10n/app_localizations.dart';

/// Displays a collapsible year spread interpretation
/// for a single tarot card.
///
/// The widget loads localized interpretations from the database
/// and animates their expansion and collapse.
class YearSpread extends StatefulWidget {
  /// Tarot card for which the year spread is displayed.
  final TarotCard taroCard;

  const YearSpread({super.key, required this.taroCard});

  @override
  State<YearSpread> createState() => _YearSpreadState();
}

class _YearSpreadState extends State<YearSpread>
    with SingleTickerProviderStateMixin {
  static const _color = Colors.white;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  /// Cached future that loads year spread interpretations
  /// from the local database.
  late final Future<List<SpreadCardInterpretation>> _future;

  /// Toggles the visibility of the year spread content
  /// by playing the animation forward or in reverse
  void _toggle() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _future = _loadYearReading();
  }

  Future<List<SpreadCardInterpretation>> _loadYearReading() async {
    final locale = context.read<LocaleBloc>().state.languageCode;

    return await TarotCardsDatabase.instance.readYearReading(
          widget.taroCard.cardId,
          locale,
        ) ??
        [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: FutureBuilder<List<SpreadCardInterpretation>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  /// Builds the animated content of the year spread.
  ///
  /// Includes a tappable header and a list of interpretations
  /// revealed using a size transition animation.
  Widget _buildContent(List<SpreadCardInterpretation> items) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.lerp(
                    _color,
                    _color.withOpacity(0.4),
                    _controller.value,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).yearReading,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Transform.rotate(
                      angle: pi * _controller.value,
                      child: const Icon(
                        Icons.arrow_drop_up,
                        color: Color(0xFF5E017D),
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.position,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.text,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
