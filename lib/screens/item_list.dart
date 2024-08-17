import 'package:flutter/material.dart';
import 'package:inventory/db/database_helper.dart';
import 'package:inventory/screens/item_form.dart';
import 'dart:io';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late Future<List<Map<String, dynamic>>> _items;

  @override
  void initState() {
    super.initState();
    _items = DatabaseHelper.instance.queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemForm()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                leading: item['image'] != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(File(item['image'])),
                        radius: 25,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.image, color: Colors.white),
                        radius: 25,
                      ),
                title: Text(item['name']),
                subtitle: Text(
                    'Price: KSH ${item['price'].toStringAsFixed(2)}, Remaining: ${item['remaining']}, Sold: ${item['sold']}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemForm(item: item)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
