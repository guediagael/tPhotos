import 'package:flutter/material.dart';

class SelectedPhotosMenu extends StatelessWidget {
  final int count;
  final Function onCancel;
  final Function onDeleteSelection;
  final Function? onShare;
  final Function? onAddToAlbum;

  const SelectedPhotosMenu(
      {super.key,
      required this.count,
      required this.onCancel,
      required this.onDeleteSelection,
      this.onShare,
      this.onAddToAlbum});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            IconButton(
                onPressed: () => onCancel(),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
            Text(
              count.toString(),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            const Spacer(),
            if (onShare != null)
              IconButton(
                  onPressed: () => onShare!(),
                  icon: Icon(Icons.share,
                      color: Theme.of(context).colorScheme.onPrimary)),
            if (onAddToAlbum != null)
              IconButton(
                  onPressed: () => onAddToAlbum!(),
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary)),
            IconButton(
                onPressed: () => onDeleteSelection(),
                icon: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.onPrimary))
          ],
        ),
      ),
    );
  }
}
