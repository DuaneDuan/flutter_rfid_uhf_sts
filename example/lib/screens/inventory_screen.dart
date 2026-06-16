import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InventoryScreen extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final int keyDownCount;
  final List<Map<String, dynamic>> tagData;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onCheckStatus;
  final VoidCallback onStartScan;
  final VoidCallback onStopScan;
  final VoidCallback onManualRead;
  final VoidCallback onClearTags;
  final ValueChanged<String> onEpcSelectedForWrite;

  const InventoryScreen({
    super.key,
    required this.isConnected,
    required this.isScanning,
    required this.keyDownCount,
    required this.tagData,
    required this.onConnect,
    required this.onDisconnect,
    required this.onCheckStatus,
    required this.onStartScan,
    required this.onStopScan,
    required this.onManualRead,
    required this.onClearTags,
    required this.onEpcSelectedForWrite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 连接管理板块
          _buildSectionHeader('Connection Management'),
          Wrap(
            spacing: 8.0,
            children: [
              ElevatedButton.icon(
                onPressed: onConnect,
                icon: const Icon(Icons.link),
                label: const Text('Connect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onDisconnect,
                icon: const Icon(Icons.link_off),
                label: const Text('Disconnect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onCheckStatus,
                icon: const Icon(Icons.sync),
                label: const Text('Check Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 扫描控制板块
          _buildSectionHeader('Scan & Read Controls'),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton.icon(
                onPressed: onStartScan,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Scan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onStopScan,
                icon: const Icon(Icons.stop),
                label: const Text('Stop Scan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade800,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onManualRead,
                icon: const Icon(Icons.download),
                label: const Text('Manual Read'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onClearTags,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear Tags'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade800,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 扫描结果展示
          _buildSectionHeader('Scanned Cards (${tagData.length})'),
          Expanded(
            child: tagData.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No tags scanned yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
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
                              // 自动填入写卡的过滤参数
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
