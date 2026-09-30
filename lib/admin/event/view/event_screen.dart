import 'package:flutter/material.dart';

import '../viewmodel/event_viewmodel.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final EventViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = EventViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Container(
          color: const Color(0xFFF7F8FC),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 24),

                _buildSummaryCards(),

                const SizedBox(height: 24),

                _buildToolbar(),

                const SizedBox(height: 20),

                Expanded(
                  child: _buildEventTable(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Events',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172033),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kelola kegiatan yang menggunakan properti.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        ElevatedButton.icon(
          onPressed: () {
            // Form tambah event akan dibuat setelah screen selesai.
          },
          icon: const Icon(Icons.add),
          label: const Text('Tambah Event'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SUMMARY CARDS
  // ============================================================

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Total Event',
            value: viewModel.totalEvents,
            icon: Icons.event_outlined,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _summaryCard(
            title: 'Scheduled',
            value: viewModel.scheduledEvents,
            icon: Icons.schedule_outlined,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _summaryCard(
            title: 'Ongoing',
            value: viewModel.ongoingEvents,
            icon: Icons.play_circle_outline,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _summaryCard(
            title: 'Completed',
            value: viewModel.completedEvents,
            icon: Icons.check_circle_outline,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE7E9F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event,
              color: Color(0xFF6366F1),
            ),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOOLBAR
  // ============================================================

  Widget _buildToolbar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: viewModel.search,
            decoration: InputDecoration(
              hintText: 'Cari event, penyelenggara, atau ID...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            initialValue: viewModel.selectedStatus,
            decoration: InputDecoration(
              labelText: 'Status',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Semua',
                child: Text('Semua'),
              ),
              DropdownMenuItem(
                value: 'Scheduled',
                child: Text('Scheduled'),
              ),
              DropdownMenuItem(
                value: 'Ongoing',
                child: Text('Ongoing'),
              ),
              DropdownMenuItem(
                value: 'Completed',
                child: Text('Completed'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.setStatus(value);
              }
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TABLE
  // ============================================================

  Widget _buildEventTable() {
    final events = viewModel.filteredEvents;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE7E9F0),
        ),
      ),
      child: events.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: DataTable(
                headingRowHeight: 54,
                dataRowMinHeight: 64,
                dataRowMaxHeight: 72,
                columnSpacing: 28,
                columns: const [
                  DataColumn(
                    label: Text('Event'),
                  ),
                  DataColumn(
                    label: Text('Properti'),
                  ),
                  DataColumn(
                    label: Text('Tanggal'),
                  ),
                  DataColumn(
                    label: Text('Penyelenggara'),
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text('Aksi'),
                  ),
                ],
                rows: events.map((event) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              event.id,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      DataCell(
                        Text(event.propertyName),
                      ),

                      DataCell(
                        Text(
                          _formatDateRange(
                            event.startDate,
                            event.endDate,
                          ),
                        ),
                      ),

                      DataCell(
                        Text(event.organizer),
                      ),

                      DataCell(
                        _statusBadge(event.status),
                      ),

                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Detail',
                              onPressed: () {
                                // Detail akan dibuat nanti.
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 20,
                              ),
                            ),

                            IconButton(
                              tooltip: 'Edit',
                              onPressed: () {
                                // Edit akan dibuat nanti.
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                            ),

                            IconButton(
                              tooltip: 'Hapus',
                              onPressed: () {
                                _showDeleteDialog(event.id);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _statusColor(status),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Scheduled':
        return Colors.blue;
      case 'Ongoing':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 14),

            const Text(
              'Event tidak ditemukan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Coba ubah kata pencarian atau filter.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _showDeleteDialog(String eventId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Event'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus event ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                viewModel.deleteEvent(eventId);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDateRange(
    DateTime start,
    DateTime end,
  ) {
    return '${start.day}/${start.month}/${start.year}'
        ' - '
        '${end.day}/${end.month}/${end.year}';
  }
}