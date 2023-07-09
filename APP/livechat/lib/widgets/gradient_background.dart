import 'package:flutter/material.dart';

class GradienBackGround extends StatelessWidget {
  final double height;

  const GradienBackGround(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          stops: const [0, 1],
        ),
      ),
    );
  }
}
