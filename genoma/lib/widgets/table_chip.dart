import 'package:flutter/material.dart';
import 'package:genoma/pages/table_list_page.dart';

class TableChip extends StatelessWidget {
  final String label;
  final String endpoint;

  const TableChip({Key? key, required this.label, required this.endpoint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TableListPage(endpoint: endpoint, title: label)),
        );
      },
    );
  }
}
