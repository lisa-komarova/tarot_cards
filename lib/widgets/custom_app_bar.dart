import 'package:flutter/material.dart';

/// Custom app bar widget containing a search input field.
///
/// Provides a styled text field that reports search input
/// changes via a callback.
class CustomAppBar extends StatefulWidget {
  /// Callback triggered whenever the search text changes.
  final void Function(String searchText) searchHandler;

  /// Controller used to manage the search input text.
  final TextEditingController controller;

  const CustomAppBar({
    super.key,
    required this.searchHandler,
    required this.controller,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double textFieldHeight = 100;

    return Container(
      color: Colors.transparent,
      padding:
          EdgeInsets.only(top: topPadding + 15, left: 20, right: 5, bottom: 10),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: textFieldHeight,
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  spreadRadius: 0.5,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: TextField(
              controller: widget.controller,
              style: Theme.of(context).textTheme.titleLarge,
              cursorHeight: 0,
              cursorWidth: 0,
              focusNode: myFocusNode,
              onChanged: widget.searchHandler,
              onTap: () => myFocusNode.requestFocus(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.black38,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(35),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
