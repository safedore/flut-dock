import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return DraggableItem(
                icon: e,
              );
            },
          ),
        ),
      ),
    );
  }
}

class DraggableItem extends StatelessWidget {
  final IconData icon;

  const DraggableItem({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<IconData>(
      data: icon,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(minWidth: 48),
          height: 48,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.primaries[icon.hashCode % Colors.primaries.length],
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
      childWhenDragging: Container(
        constraints: const BoxConstraints(minWidth: 48),
        height: 48,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.primaries[icon.hashCode % Colors.primaries.length],
        ),
        child: Icon(icon, color: Colors.white),
      ),
      child: Container(
        constraints: const BoxConstraints(minWidth: 48),
        height: 48,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.primaries[icon.hashCode % Colors.primaries.length],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<IconData> items;

  /// Builder building the provided [T] item.
  final Widget Function(IconData) builder;

  @override
  State<Dock> createState() => _DockState();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState extends State<Dock> {
  /// [T] items being manipulated.
  late List<IconData> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.map((item) {
          return DragTarget<IconData>(
            onAcceptWithDetails: (receivedItem) {
              setState(() {
                int oldIndex = _items.indexOf(receivedItem.data);
                int newIndex = _items.indexOf(item);
                if (oldIndex != newIndex) {
                  _items.removeAt(oldIndex);
                  _items.insert(newIndex, receivedItem.data);
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return widget.builder(item);
            },
          );
        }).toList(),
      ),
    );
  }
}
