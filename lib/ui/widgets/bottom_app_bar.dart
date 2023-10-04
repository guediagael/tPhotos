import 'package:flutter/material.dart';

class TphotosBottomAppBar extends StatelessWidget {
  final Function onTap;
  final int currentIndex;

  const TphotosBottomAppBar(
      {Key? key, required this.onTap, this.currentIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      // color: Colors.blue,
      child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => onTap(0), icon: const Icon(Icons.timer)),
              const Spacer(),
              IconButton(
                  onPressed: () => onTap(1), icon: const Icon(Icons.search))
            ],
          )),
    );
  }
}
