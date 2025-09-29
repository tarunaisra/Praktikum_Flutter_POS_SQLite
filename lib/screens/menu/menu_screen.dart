import 'package:flutter/material.dart';
import '../../db/repository.dart';
import '../../models/item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Item> _items = [];
  List<Item> _filteredItems = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  Future<void> _loadItems() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('items');
    setState(() {
      _items = result.map((m) => Item.fromMap(m)).toList();
      _filteredItems = _items;
    });
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) => item.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Menu',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Rp ${item.price} - ${item.category}'),
                  // Tambahkan tombol add to cart jika diperlukan
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}