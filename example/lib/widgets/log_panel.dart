import 'package:flutter/material.dart';
import '../logger.dart';

class LogPanel extends StatelessWidget {
  final String logFilePath;
  final VoidCallback onClearLogs;

  const LogPanel({
    super.key,
    required this.logFilePath,
    required this.onClearLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade700)),
        color: Colors.black,
      ),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Logs File: $logFilePath',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: onClearLogs,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 24),
                ),
                child: const Text(
                  'Reset File',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: FileLogger.inMemoryLogs.length,
              itemBuilder: (context, index) {
                final idx = FileLogger.inMemoryLogs.length - 1 - index;
                return Text(
                  FileLogger.inMemoryLogs[idx],
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
