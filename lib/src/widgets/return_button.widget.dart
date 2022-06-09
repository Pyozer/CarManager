import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  final bool isClose;

  const ReturnButton({Key? key, this.isClose = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundColor: Colors.black45,
          child: isClose
              ? const CloseButton(color: Colors.white)
              : const BackButton(color: Colors.white),
        ),
      ),
    );
  }
}
