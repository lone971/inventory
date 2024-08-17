import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory/db/database_helper.dart';

class ItemForm extends StatefulWidget {
  final Map<String, dynamic>? item;

  const ItemForm({super.key, this.item});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _remainingController = TextEditingController();
  final _soldController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!['name'];
      _priceController.text = widget.item!['price'].toString();
      _remainingController.text = widget.item!['remaining'].toString();
      _soldController.text = widget.item!['sold'].toString();
      if (widget.item!['image'] != null) {
        _image = File(widget.item!['image']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_image != null)
                Image.file(
                  _image!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _remainingController,
                decoration: const InputDecoration(labelText: 'Remaining'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _soldController,
                decoration: const InputDecoration(labelText: 'Sold'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(widget.item == null ? 'Add Item' : 'Update Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveItem() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _remainingController.text.isEmpty ||
        _soldController.text.isEmpty ||
        _image == null) {
      _showErrorDialog('All fields, including image, are required.');
      return;
    }

    final item = {
      'name': _nameController.text,
      'price': double.tryParse(_priceController.text) ?? 0,
      'remaining': int.tryParse(_remainingController.text) ?? 0,
      'sold': int.tryParse(_soldController.text) ?? 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'image': _image!.path, // Store the image path
    };

    try {
      if (widget.item == null) {
        await DatabaseHelper.instance.insert(item);
      } else {
        await DatabaseHelper.instance
            .update({...item, 'id': widget.item!['id']});
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to save item. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
