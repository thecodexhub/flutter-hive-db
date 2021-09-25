import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    Key? key,
    required this.index,
    required this.task,
    required this.isDone,
    this.onTap,
    this.onDelete,
  }) : super(key: key);
  final int index;
  final String task;
  final bool isDone;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(index.toString()),
      actionPane: SlidableDrawerActionPane(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              isDone
                  ? Icon(
                      Icons.check_box,
                      color: Colors.indigo,
                    )
                  : Icon(Icons.check_box_outline_blank),
              const SizedBox(width: 16.0),
              Text(task),
            ],
          ),
        ),
      ),
      secondaryActions: [
        GestureDetector(
          onTap: onDelete,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}
