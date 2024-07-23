import 'package:flutter/material.dart';

///app bar with search
class CustomAppBar extends StatefulWidget {
  final void Function(String searchText) searchHandler;
  final TextEditingController controller;

  const CustomAppBar(
      {super.key, required this.searchHandler, required this.controller});

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
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Align(
              alignment: const Alignment(0.0, 1.25),
              child: Container(
                  height: MediaQuery.of(context).size.height / 10.5,
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20.0,
                            // shadow
                            spreadRadius: .5,
                            // set effect of extending the shadow
                            offset: Offset(
                              0.0,
                              5.0,
                            ),
                          )
                        ],
                      ),
                      child: TextField(
                          controller: widget.controller,
                          style: Theme.of(context).textTheme.titleLarge,
                          cursorHeight: 0,
                          cursorWidth: 0,
                          focusNode: myFocusNode,
                          onChanged: (searchText) {
                            widget.searchHandler(searchText);
                          },
                          onTap: () => myFocusNode.requestFocus(),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: const Icon(
                                Icons.search,
                                color: Colors.black38,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 30, bottom: 30),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(35)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(35))))))),
        ]));
  }
}
