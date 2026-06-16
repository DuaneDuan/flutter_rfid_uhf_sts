import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isConnected;
  final String powerValue;
  final ValueChanged<String?> onPowerChanged;
  final int bandPosition;
  final ValueChanged<int?> onBandPositionChanged;
  final bool scanEpc;
  final ValueChanged<bool?> onScanEpcChanged;
  final bool scanTid;
  final ValueChanged<bool?> onScanTidChanged;
  final bool scanUser;
  final ValueChanged<bool?> onScanUserChanged;
  final int userPtr;
  final ValueChanged<String> onUserPtrChanged;
  final int userLen;
  final ValueChanged<String> onUserLenChanged;
  final VoidCallback onApplySettings;
  final Map<dynamic, dynamic> configFile;

  const SettingsScreen({
    super.key,
    required this.isConnected,
    required this.powerValue,
    required this.onPowerChanged,
    required this.bandPosition,
    required this.onBandPositionChanged,
    required this.scanEpc,
    required this.onScanEpcChanged,
    required this.scanTid,
    required this.onScanTidChanged,
    required this.scanUser,
    required this.onScanUserChanged,
    required this.userPtr,
    required this.onUserPtrChanged,
    required this.userLen,
    required this.onUserLenChanged,
    required this.onApplySettings,
    required this.configFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _buildSectionHeader('RFID Configurations'),
          Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // 功率设置
                  Row(
                    children: [
                      const Expanded(child: Text('Power (dBm):')),
                      DropdownButton<String>(
                        value: powerValue,
                        dropdownColor: Colors.grey.shade900,
                        items: ['10', '15', '20', '25', '26', '27', '28', '29', '30', '33'].map((val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text('$val dBm'),
                          );
                        }).toList(),
                        onChanged: onPowerChanged,
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  // 频段设置
                  Row(
                    children: [
                      const Expanded(child: Text('Frequency Band:')),
                      DropdownButton<int>(
                        value: bandPosition,
                        dropdownColor: Colors.grey.shade900,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Band 1 (China/US)')),
                          DropdownMenuItem(value: 2, child: Text('Band 2 (Europe)')),
                          DropdownMenuItem(value: 3, child: Text('Band 3')),
                          DropdownMenuItem(value: 4, child: Text('Band 4')),
                        ],
                        onChanged: onBandPositionChanged,
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  // 扫描内容切换
                  CheckboxListTile(
                    title: const Text('Scan EPC'),
                    dense: true,
                    value: scanEpc,
                    onChanged: onScanEpcChanged,
                  ),
                  CheckboxListTile(
                    title: const Text('Scan TID'),
                    dense: true,
                    value: scanTid,
                    onChanged: onScanTidChanged,
                  ),
                  CheckboxListTile(
                    title: const Text('Scan USER Memory'),
                    dense: true,
                    value: scanUser,
                    onChanged: onScanUserChanged,
                  ),
                  if (scanUser) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'User Ptr (word)',
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: userPtr.toString())
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: userPtr.toString().length),
                                ),
                              onChanged: onUserPtrChanged,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'User Len (word)',
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: userLen.toString())
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: userLen.toString().length),
                                ),
                              onChanged: onUserLenChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onApplySettings,
                    icon: const Icon(Icons.settings),
                    label: const Text('Apply RFID Settings'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.teal.shade900,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (configFile.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Current Module Config:\n$configFile',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                  ],
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
