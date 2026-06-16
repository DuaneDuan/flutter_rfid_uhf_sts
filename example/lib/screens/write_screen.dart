import 'package:flutter/material.dart';

class WriteScreen extends StatelessWidget {
  final bool isConnected;
  final TextEditingController passwordController;
  final TextEditingController ptrController;
  final TextEditingController dataController;
  final TextEditingController sourcePtrController;
  final TextEditingController sourceDataController;
  final VoidCallback onWriteData;

  const WriteScreen({
    super.key,
    required this.isConnected,
    required this.passwordController,
    required this.ptrController,
    required this.dataController,
    required this.sourcePtrController,
    required this.sourceDataController,
    required this.onWriteData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _buildSectionHeader('Write Data Setup'),
          const Text(
            'Write custom hexadecimal payloads into target memory bank addresses of specific tags.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Tag Password (HEX)',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ptrController,
                          decoration: const InputDecoration(
                            labelText: 'Target Pointer (ptr)',
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: sourcePtrController,
                          decoration: const InputDecoration(
                            labelText: 'Source Pointer',
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dataController,
                    decoration: const InputDecoration(
                      labelText: 'Hex Data to Write',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: sourceDataController,
                    decoration: const InputDecoration(
                      labelText:
                          'Source Match Data (Optional, filters target card)',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: isConnected ? onWriteData : null,
                    icon: const Icon(Icons.edit_document),
                    label: const Text('Write Hex Data to Card'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.amber.shade900,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent,
        ),
      ),
    );
  }
}
