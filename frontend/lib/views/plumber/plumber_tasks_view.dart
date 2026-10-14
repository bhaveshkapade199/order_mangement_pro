import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PlumberTasksView extends StatefulWidget {
  const PlumberTasksView({super.key});

  @override
  State<PlumberTasksView> createState() => _PlumberTasksViewState();
}

class _PlumberTasksViewState extends State<PlumberTasksView> {
  String _statusFilter = 'All';

  // Sample tasks state
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'taskNumber': 'TSK-PLM-701',
      'title': 'Main Inflow Valve Leakage Rectification',
      'description': 'Customer reported continuous seepage around main quarter-turn ball valve connection after pipeline installation.',
      'customerName': 'Rahul Verma',
      'customerMobile': '9999900001',
      'address': 'Flat 302, Palm Heights, Mumbai 400053',
      'status': 'ASSIGNED',
      'time': 'Today, 2:30 PM',
    },
    {
      'id': '2',
      'taskNumber': 'TSK-PLM-702',
      'title': 'Basin Mixer Tap Fitting & Seal Check',
      'description': 'Fit new designer basin mixer with Teflon sealant and pressure test water flow.',
      'customerName': 'Sanjay Deshmukh',
      'customerMobile': '9822001122',
      'address': 'Villa 14, Royal Palms, Mumbai 400065',
      'status': 'IN_PROGRESS',
      'time': 'Today, 11:00 AM',
    },
    {
      'id': '3',
      'taskNumber': 'TSK-PLM-689',
      'title': 'Anti-Cockroach Floor Trap Replacement',
      'description': 'Installed 304 SS floor drain and sealed joint with solvent cement.',
      'customerName': 'Kavita Nair',
      'customerMobile': '9877002233',
      'address': 'Plot 45, Sector 8, Navi Mumbai 400703',
      'status': 'COMPLETED',
      'time': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _statusFilter == 'All'
        ? _tasks
        : _tasks.where((t) => t['status'] == _statusFilter.toUpperCase()).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assigned Activities', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Assigned', 'In_Progress', 'Completed'].map((status) {
                  final isSelected = _statusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status.replaceAll('_', ' ')),
                      selected: isSelected,
                      selectedColor: AppColors.plumberColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _statusFilter = status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final task = filtered[index];
                Color statusColor;
                switch (task['status']) {
                  case 'COMPLETED':
                    statusColor = AppColors.success;
                    break;
                  case 'IN_PROGRESS':
                    statusColor = AppColors.warning;
                    break;
                  default:
                    statusColor = AppColors.info;
                    break;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task['taskNumber'],
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                task['status'].replaceAll('_', ' '),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task['description'],
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Text('${task['customerName']} • ${task['customerMobile']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(task['address'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ),
                          ],
                        ),
                        if (task['status'] != 'COMPLETED') ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      task['status'] = 'IN_PROGRESS';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Status updated to In Progress')),
                                    );
                                  },
                                  child: const Text('Start Work'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                  onPressed: () {
                                    setState(() {
                                      task['status'] = 'COMPLETED';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Activity marked completed!')),
                                    );
                                  },
                                  child: const Text('Complete'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
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
}
