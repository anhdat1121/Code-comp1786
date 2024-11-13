import 'package:flutter/material.dart';
import '../models/list_model.dart';

class ListTaskTile extends StatelessWidget {
  const ListTaskTile({
    super.key,
    required this.listTask,
    required this.onEdit,
    required this.onDelete,
    required this.onCompleteToggle,
  });

  final ListTask listTask;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onCompleteToggle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: listTask.isCompleted,
        onChanged: onCompleteToggle,
      ),
      title: Text(
        listTask.name,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listTask.description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text('Date: ${listTask.formattedDate}',
              style: const TextStyle(fontSize: 13)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!listTask.isCompleted)
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color.fromRGBO(1, 120, 255, 0.612)),
              onPressed: onEdit,
            ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
