class DialogItemChoice {
  final String text;
  final Function onSelected;

  const DialogItemChoice(this.text, this.onSelected);
}

typedef DialogItemChoiceList = List<DialogItemChoice>;
