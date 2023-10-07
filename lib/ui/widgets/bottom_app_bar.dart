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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => onTap(0), icon:  Icon( (currentIndex == 0) ? Icons.timer : Icons.timer_outlined)),
          // const Spacer(),
          IconButton(
              onPressed: () => onTap(1), icon:  Icon((currentIndex == 1)? Icons.manage_search_outlined:Icons.search ))
        ],
      ),
    );
  }
}
