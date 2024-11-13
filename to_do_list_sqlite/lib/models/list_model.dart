import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListTask {
  ListTask(
      {this.id,
      required this.name,
      this.description = '',
      required this.date,
      this.isCompleted = false});

  int? id;
  final String name;
  final String description;
  final DateTime date;
  final bool isCompleted;
  String get formattedDate => formatter.format(date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0
    };
  }

  static ListTask fromMap(Map<String, dynamic> map) {
    return ListTask(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
