class Item {
  final int id;
  final String name;
  final int price;
  final String category;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
    );
  }
}