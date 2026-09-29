import 'package:eventary_prototype/models/property.dart';
import 'package:eventary_prototype/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../model/maintenance_model.dart';
import '../viewmodel/maintenance_viewmodel.dart';
import 'maintenance_detail.dart';
import 'maintenance_form.dart';

class MaintenanceScreen extends StatefulWidget {
  final List<Property> properties;

  const MaintenanceScreen({
    super.key,
    required this.properties,
  });

  @override
  State<MaintenanceScreen> createState() =>
      _MaintenanceScreenState();
}

class _MaintenanceScreenState
    extends State<MaintenanceScreen> {
  late final MaintenanceViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = MaintenanceViewModel();

    _viewModel.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();

    super.dispose();
  }

  // ==============================================================
  // PROPERTY
  // ==============================================================

  String _propertyName(
    String propertyId,
  ) {
    for (final property in widget.properties) {
      if (property.id == propertyId) {
        return property.name;
      }
    }

    return 'Property $propertyId';
  }

  // ==============================================================
  // FORMAT
  // ==============================================================

  String _formatCurrency(double value) {
    final text =
        value.toStringAsFixed(0);

    return 'Rp ${text.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ==============================================================
  // ADD
  // ==============================================================

  void _showAddMaintenance() {
    if (widget.properties.isEmpty) {
      _showMessage(
        'Belum ada property yang tersedia.',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return MaintenanceForm(
          properties: widget.properties,
          onSubmit: ({
            required propertyId,
            required issue,
            required description,
            required category,
            required priority,
            required status,
            required pic,
            required estimatedCost,
            required notes,
            scheduledDate,
          }) {
            _viewModel.addMaintenance(
              propertyId: propertyId,
              issue: issue,
              description: description,
              category: category,
              priority: priority,
              pic: pic,
              estimatedCost: estimatedCost,
              notes: notes,
              scheduledDate: scheduledDate,
            );

            Navigator.of(context).pop();

            _showMessage(
              'Maintenance berhasil ditambahkan.',
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // EDIT
  // ==============================================================

  void _showEditMaintenance(
    MaintenanceRecord record,
  ) {
    if (widget.properties.isEmpty) {
      _showMessage(
        'Belum ada property yang tersedia.',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return MaintenanceForm(
          properties: widget.properties,
          record: record,
          onSubmit: ({
            required propertyId,
            required issue,
            required description,
            required category,
            required priority,
            required status,
            required pic,
            required estimatedCost,
            required notes,
            scheduledDate,
          }) {
            _viewModel.updateMaintenance(
              id: record.id,
              propertyId: propertyId,
              issue: issue,
              description: description,
              category: category,
              priority: priority,
              status: status,
              pic: pic,
              estimatedCost: estimatedCost,
              notes: notes,
              scheduledDate: scheduledDate,
            );

            Navigator.of(context).pop();

            _showMessage(
              'Maintenance berhasil diperbarui.',
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // DELETE
  // ==============================================================

  void _deleteMaintenance(
    MaintenanceRecord record,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppRadius.lg,
            ),
          ),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      AppColors.danger
                          .withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color:
                      AppColors.danger,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              const Text(
                'Hapus Maintenance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${record.issue}"?',
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'Batal',
              ),
            ),
            FilledButton(
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    AppColors.danger,
              ),
              onPressed: () {
                _viewModel.deleteMaintenance(
                  record.id,
                );

                Navigator.of(
                  dialogContext,
                ).pop();

                _showMessage(
                  'Data maintenance berhasil dihapus.',
                );
              },
              child: const Text(
                'Hapus',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // DETAIL
  // ==============================================================

  void _showDetail(
    MaintenanceRecord record,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return MaintenanceDetail(
          record: record,
          propertyName:
              _propertyName(
            record.propertyId,
          ),
          onStatusChanged: (
            newStatus,
          ) {
            _viewModel.updateStatus(
              record.id,
              newStatus,
            );

            Navigator.of(context).pop();

            _showMessage(
              'Status maintenance berhasil diperbarui.',
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // MESSAGE
  // ==============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final records =
        _viewModel.filteredRecords(
      _propertyName,
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 20),

        _buildSummaryCards(),

        const SizedBox(height: 20),

        Expanded(
          child: _buildMainPanel(
            records,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // HEADER
  // ==============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Maintenance & Inspection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Monitor kondisi, inspeksi, dan pemeliharaan properti.',
                style: TextStyle(
                  fontSize: 13.5,
                  color:
                      AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        FilledButton.icon(
          onPressed:
              _showAddMaintenance,
          icon: const Icon(
            Icons.add_rounded,
            size: 18,
          ),
          label: const Text(
            'Tambah Maintenance',
          ),
          style:
              FilledButton.styleFrom(
            backgroundColor:
                AppColors.accent,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                AppRadius.md,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // SUMMARY
  // ==============================================================

  Widget _buildSummaryCards() {
    final cards = [
      _SummaryCard(
        title: 'Total Maintenance',
        value:
            '${_viewModel.totalCount}',
        subtitle: 'Seluruh laporan',
        icon:
            Icons.build_circle_outlined,
        iconColor:
            AppColors.accent,
      ),

      _SummaryCard(
        title: 'Perlu Ditangani',
        value:
            '${_viewModel.reportedCount}',
        subtitle: 'Menunggu proses',
        icon:
            Icons.report_problem_outlined,
        iconColor:
            AppColors.danger,
      ),

      _SummaryCard(
        title: 'Sedang Dikerjakan',
        value:
            '${_viewModel.inProgressCount}',
        subtitle: 'Dalam proses',
        icon:
            Icons.construction_outlined,
        iconColor:
            AppColors.warning,
      ),

      _SummaryCard(
        title: 'Selesai',
        value:
            '${_viewModel.completedCount}',
        subtitle:
            'Maintenance selesai',
        icon:
            Icons.check_circle_outline,
        iconColor:
            AppColors.success,
      ),
    ];

    return LayoutBuilder(
      builder:
          (context, constraints) {
        if (constraints.maxWidth <
            800) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                cards.map(
              (card) {
                return SizedBox(
                  width:
                      (constraints.maxWidth -
                              12) /
                          2,
                  child: card,
                );
              },
            ).toList(),
          );
        }

        return Row(
          children: [
            for (int i = 0;
                i < cards.length;
                i++) ...[
              Expanded(
                child: cards[i],
              ),
              if (i != cards.length - 1)
                const SizedBox(
                  width: 12,
                ),
            ],
          ],
        );
      },
    );
  }

  // ==============================================================
  // MAIN PANEL
  // ==============================================================

  Widget _buildMainPanel(
    List<MaintenanceRecord> records,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow:
            AppShadows.subtle,
      ),
      child: Column(
        children: [
          _buildToolbar(),

          const Divider(
            height: 1,
          ),

          Expanded(
            child: records.isEmpty
                ? _buildEmptyState()
                : _buildList(records),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // TOOLBAR
  // ==============================================================

  Widget _buildToolbar() {
    return Padding(
      padding:
          const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment:
            WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 42,
            child: TextField(
              onChanged:
                  _viewModel.setSearchQuery,
              decoration:
                  InputDecoration(
                hintText:
                    'Cari maintenance atau property...',
                prefixIcon:
                    const Icon(
                  Icons.search_rounded,
                  size: 19,
                ),
                filled: true,
                fillColor:
                    AppColors.surface,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    AppRadius.md,
                  ),
                  borderSide:
                      BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 14,
                ),
              ),
            ),
          ),

          _FilterChip(
            label: 'Semua',
            selected:
                _viewModel.statusFilter ==
                    null,
            onTap: () {
              _viewModel
                  .setStatusFilter(null);
            },
          ),

          _FilterChip(
            label: 'Reported',
            selected:
                _viewModel.statusFilter ==
                    'Reported',
            onTap: () {
              _viewModel
                  .setStatusFilter(
                'Reported',
              );
            },
          ),

          _FilterChip(
            label: 'In Progress',
            selected:
                _viewModel.statusFilter ==
                    'In Progress',
            onTap: () {
              _viewModel
                  .setStatusFilter(
                'In Progress',
              );
            },
          ),

          _FilterChip(
            label: 'Completed',
            selected:
                _viewModel.statusFilter ==
                    'Completed',
            onTap: () {
              _viewModel
                  .setStatusFilter(
                'Completed',
              );
            },
          ),

          const SizedBox(width: 4),

          Text(
            'Estimasi biaya: '
            '${_formatCurrency(
              _viewModel.totalEstimatedCost,
            )}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // LIST
  // ==============================================================

  Widget _buildList(
    List<MaintenanceRecord> records,
  ) {
    return ListView.separated(
      padding:
          const EdgeInsets.all(16),
      itemCount: records.length,
      separatorBuilder:
          (_, __) =>
              const SizedBox(height: 10),
      itemBuilder:
          (context, index) {
        final record =
            records[index];

        return _MaintenanceTile(
          record: record,
          propertyName:
              _propertyName(
            record.propertyId,
          ),
          formatCurrency:
              _formatCurrency,
          formatDate:
              _formatDate,
          onDetail: () {
            _showDetail(record);
          },
          onEdit: () {
            _showEditMaintenance(
              record,
            );
          },
          onDelete: () {
            _deleteMaintenance(
              record,
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // EMPTY
  // ==============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 46,
            color:
                AppColors.textSecondary
                    .withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Maintenance tidak ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Coba ubah kata pencarian atau filter.',
            style: TextStyle(
              fontSize: 13,
              color:
                  AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


// ==================================================================
// SUMMARY CARD
// ==================================================================

class _SummaryCard
    extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow:
            AppShadows.subtle,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(
              color: iconColor
                  .withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        AppColors
                            .textPrimary,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  subtitle,
                  style:
                      const TextStyle(
                    fontSize: 10.5,
                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ==================================================================
// FILTER CHIP
// ==================================================================

class _FilterChip
    extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(20),
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 150,
        ),
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? AppColors.accent
              : AppColors.surface,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
            color: selected
                ? Colors.white
                : AppColors
                    .textSecondary,
          ),
        ),
      ),
    );
  }
}


// ==================================================================
// MAINTENANCE TILE
// ==================================================================

class _MaintenanceTile
    extends StatelessWidget {
  final MaintenanceRecord record;
  final String propertyName;
  final String Function(double)
      formatCurrency;
  final String Function(DateTime?)
      formatDate;
  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MaintenanceTile({
    required this.record,
    required this.propertyName,
    required this.formatCurrency,
    required this.formatDate,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final statusColor =
        _statusColor(
      record.status,
    );

    return Material(
      color: AppColors.surface,
      borderRadius:
          BorderRadius.circular(
        AppRadius.md,
      ),
      child: InkWell(
        onTap: onDetail,
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        child: Padding(
          padding:
              const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(
                  color: statusColor
                      .withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  _categoryIcon(
                    record.category,
                  ),
                  color: statusColor,
                  size: 21,
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      record.issue,
                      style:
                          const TextStyle(
                        fontSize: 13.5,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      propertyName,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '${record.id} • ${record.category}',
                      style:
                          const TextStyle(
                        fontSize: 10.5,
                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 95,
                child:
                    _PriorityBadge(
                  priority:
                      record.priority,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              SizedBox(
                width: 115,
                child:
                    _StatusBadge(
                  status:
                      record.status,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              SizedBox(
                width: 110,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .end,
                  children: [
                    Text(
                      formatCurrency(
                        record
                            .estimatedCost,
                      ),
                      style:
                          const TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      formatDate(
                        record
                            .reportedDate,
                      ),
                      style:
                          const TextStyle(
                        fontSize: 10.5,
                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              PopupMenuButton<
                  String>(
                tooltip: 'Aksi',
                onSelected:
                    (value) {
                  switch (value) {
                    case 'detail':
                      onDetail();
                      break;

                    case 'edit':
                      onEdit();
                      break;

                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder:
                    (context) {
                  return const [
                    PopupMenuItem(
                      value:
                          'detail',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .visibility_outlined,
                            size: 18,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Detail',
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value:
                          'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .edit_outlined,
                            size: 18,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Edit',
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value:
                          'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .delete_outline,
                            size: 18,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Hapus',
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(
    String category,
  ) {
    switch (category) {
      case 'HVAC':
        return Icons
            .ac_unit_rounded;

      case 'Electrical':
        return Icons
            .electrical_services_rounded;

      case 'Civil':
        return Icons
            .foundation_rounded;

      case 'Building':
        return Icons
            .business_rounded;

      default:
        return Icons
            .fact_check_outlined;
    }
  }

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case 'Completed':
        return AppColors.success;

      case 'In Progress':
        return AppColors.warning;

      default:
        return AppColors.danger;
    }
  }
}


// ==================================================================
// STATUS BADGE
// ==================================================================

class _StatusBadge
    extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final color =
        _statusColor(status);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
        color: color
            .withOpacity(0.10),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        status,
        textAlign:
            TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case 'Completed':
        return AppColors.success;

      case 'In Progress':
        return AppColors.warning;

      default:
        return AppColors.danger;
    }
  }
}


// ==================================================================
// PRIORITY BADGE
// ==================================================================

class _PriorityBadge
    extends StatelessWidget {
  final String priority;

  const _PriorityBadge({
    required this.priority,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final color =
        _priorityColor(
      priority,
    );

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
        color: color
            .withOpacity(0.08),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: color
              .withOpacity(0.20),
        ),
      ),
      child: Text(
        priority,
        textAlign:
            TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  Color _priorityColor(
    String priority,
  ) {
    switch (priority) {
      case 'High':
        return AppColors.danger;

      case 'Medium':
        return AppColors.warning;

      default:
        return AppColors.success;
    }
  }
}