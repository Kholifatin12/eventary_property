import 'package:eventary_prototype/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../model/maintenance_model.dart';

class MaintenanceDetail extends StatelessWidget {
  final MaintenanceRecord record;
  final String propertyName;
  final ValueChanged<String> onStatusChanged;

  const MaintenanceDetail({
    super.key,
    required this.record,
    required this.propertyName,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 30,
      ),
      child: Container(
        width: 650,
        constraints: const BoxConstraints(
          maxHeight: 760,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius:
              BorderRadius.circular(
            AppRadius.xl,
          ),
          boxShadow: AppShadows.floating,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(context),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      label: 'Property',
                      value: propertyName,
                      icon: Icons
                          .location_city_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoBox(
                      label: 'Kategori',
                      value: record.category,
                      icon:
                          Icons.category_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      label: 'Prioritas',
                      value: record.priority,
                      icon: Icons
                          .priority_high_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoBox(
                      label: 'PIC',
                      value: record.pic,
                      icon: Icons
                          .person_outline_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildDescription(),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      label: 'Dilaporkan',
                      value: _formatDate(
                        record.reportedDate,
                      ),
                      icon: Icons
                          .calendar_today_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoBox(
                      label: 'Jadwal',
                      value: _formatDate(
                        record.scheduledDate,
                      ),
                      icon: Icons
                          .event_available_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _InfoBox(
                label: 'Estimasi Biaya',
                value: _formatCurrency(
                  record.estimatedCost,
                ),
                icon:
                    Icons.payments_outlined,
              ),

              const SizedBox(height: 24),

              const Text(
                'Status Maintenance',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusAction(
                    label: 'Reported',
                    selected:
                        record.status ==
                            'Reported',
                    color:
                        AppColors.danger,
                    onTap: () {
                      onStatusChanged(
                        'Reported',
                      );
                    },
                  ),
                  _StatusAction(
                    label: 'In Progress',
                    selected:
                        record.status ==
                            'In Progress',
                    color:
                        AppColors.warning,
                    onTap: () {
                      onStatusChanged(
                        'In Progress',
                      );
                    },
                  ),
                  _StatusAction(
                    label: 'Completed',
                    selected:
                        record.status ==
                            'Completed',
                    color:
                        AppColors.success,
                    onTap: () {
                      onStatusChanged(
                        'Completed',
                      );
                    },
                  ),
                ],
              ),

              if (record.notes
                  .trim()
                  .isNotEmpty) ...[
                const SizedBox(height: 24),

                const Text(
                  'Catatan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:
                        AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(
                      AppRadius.md,
                    ),
                    border: Border.all(
                      color:
                          AppColors.border,
                    ),
                  ),
                  child: Text(
                    record.notes,
                    style:
                        const TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // HEADER
  // ==============================================================

  Widget _buildHeader(
    BuildContext context,
  ) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color:
                AppColors.accent
                    .withOpacity(0.10),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.build_circle_outlined,
            color: AppColors.accent,
            size: 23,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                record.id,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      AppColors.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                record.issue,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close_rounded,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // DESCRIPTION
  // ==============================================================

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
          ),
          child: Text(
            record.description.isEmpty
                ? '-'
                : record.description,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.55,
              color:
                  AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // INFO BOX
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
}


// ==================================================================
// INFO BOX
// ==================================================================

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color:
                        AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w600,
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
// STATUS ACTION
// ==================================================================

class _StatusAction extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusAction({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(20),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.12)
              : AppColors.surface,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? color
                : AppColors.border,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons
                      .radio_button_checked_rounded
                  : Icons
                      .radio_button_unchecked_rounded,
              size: 15,
              color: selected
                  ? color
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight:
                    FontWeight.w600,
                color: selected
                    ? color
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}