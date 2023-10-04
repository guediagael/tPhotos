import 'package:flutter/material.dart';

class SelectedPhotosMenu extends StatelessWidget {
  final int count;
  final Function onCancel;
  final Function onDeleteSelection;
  final Function? onShare;
  final Function? onAddToAlbum;

  const SelectedPhotosMenu(
      {Key? key,
      required this.count,
      required this.onCancel,
      required this.onDeleteSelection,
      this.onShare,
      this.onAddToAlbum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            IconButton(
                onPressed: () => onCancel(), icon: const Icon(Icons.close)),
            Text(count.toString()),
            const Spacer(),
            if (onShare != null)
              IconButton(
                  onPressed: () => onShare!(), icon: const Icon(Icons.share)),
            if (onAddToAlbum != null)
              IconButton(
                  onPressed: () => onAddToAlbum!(), icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () => onDeleteSelection(), icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
