import 'package:flutter/material.dart';

void main() {
  runApp(FirstExample());
}

class FirstExample extends StatelessWidget {
  const FirstExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Заметки')),
        body: FirstExampleWidget(),
      ), // Scaffold
    ); // MaterialApp
  }
}

class FirstExampleWidget extends StatefulWidget {
  const FirstExampleWidget({super.key});

  @override
  _FirstExampleWidgetState createState() => _FirstExampleWidgetState();
}

class _FirstExampleWidgetState extends State<FirstExampleWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  String _displayText = '';
  int _editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateDisplayText);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateDisplayText);
    _controller.dispose();
    super.dispose();
  }

  void _updateDisplayText() {
    setState(() {
      _displayText = _controller.text;
    });
  }

  void _clearText() {
    _controller.clear();
  }

  void _showText() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Текст: $_displayText')));
  }

  void _addToList() {
    if (_controller.text.isEmpty) return;
    setState(() {
      if (_editingIndex == -1) {
        _items.add(_controller.text);
      } else {
        _items[_editingIndex] = _controller.text;
        _editingIndex = -1;
      }
      _controller.clear();
    });
  }

  void _editItem(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text = _items[index];
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'введите текст',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: _addToList,
              tooltip: 'Добавить',
            ),
          ), // InputDecoration
        ), // TextField
        SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: 40),
            ElevatedButton(
              onPressed: _clearText,
              child: Text('очистить текст'),
            ), // ElevatedButton
            SizedBox(width: 40),
            ElevatedButton(
              onPressed: _showText,
              child: Text('показать текст'),
            ), // Elevat
          ],
        ), // Row
        SizedBox(height: 20),
        Row(children: [SizedBox(width: 20), Text('Вы ввели: $_displayText')]),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(5),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_items[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editItem(index),
                    ), // IconButton
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(index),
                    ), // IconButton
                  ],
                ), // Row
              ); // ListTile
            },
          ), // ListView.builder
        ), // Expanded
      ],
    ); // Column
  }
}
