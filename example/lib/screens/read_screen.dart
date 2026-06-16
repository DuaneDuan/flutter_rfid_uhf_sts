import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadScreen extends StatelessWidget {
  final bool isConnected;
  final List<Map<String, dynamic>> tagData;
  final VoidCallback onManualRead;
  final ValueChanged<String> onEpcSelectedForWrite;

  const ReadScreen({
    super.key,
    required this.isConnected,
    required this.tagData,
    required this.onManualRead,
    required this.onEpcSelectedForWrite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader('Manual Read Data'),
          const Text(
            'Fetch cached tag data currently residing in the RFID module\'s buffer memory manually.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: isConnected ? onManualRead : null,
            icon: const Icon(Icons.download),
            label: const Text('Fetch Buffered Tag Data'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: Colors.cyan.shade800,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Manual Read Results (${tagData.length})'),
          Expanded(
            child: tagData.isEmpty
                ? const Center(
                    child: Text(
                      'No manually fetched data. Click button to load.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tagData.length,
                    itemBuilder: (context, index) {
                      final item = tagData[index];
                      final epc = item['epc'] ?? 'Unknown EPC';
                      final tid = item['tid'];
                      final rssi = item['rssi'] ?? 'N/A';
                      final count = item['count'] ?? 1;

                      return Card(
                        color: Colors.grey.shade800,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            'EPC: $epc',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tid != null && tid.toString().isNotEmpty)
                                Text('TID: $tid'),
                              Text('RSSI: $rssi  |  Scan Count: $count'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: epc));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('EPC copied to clipboard'),
                                ),
                              );
                              onEpcSelectedForWrite(epc);
                            },
                          ),
                        ),
                      );
                    },
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
