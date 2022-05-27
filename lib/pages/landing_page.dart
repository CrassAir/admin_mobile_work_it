import 'package:flutter/material.dart';

class AnimatePage extends StatelessWidget {
  const AnimatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
