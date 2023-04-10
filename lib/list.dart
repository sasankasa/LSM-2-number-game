class ListNum {
  int id;
  int value;
  String comment;
  bool isGoodNumber;


  ListNum({
    required this.id,
    required this.value,
    this.comment = '',
    this.isGoodNumber = false,
  });
}