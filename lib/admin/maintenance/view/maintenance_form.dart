import 'package:eventary_prototype/models/property.dart';
import 'package:eventary_prototype/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../model/maintenance_model.dart';

class MaintenanceForm extends StatefulWidget {
  final List<Property> properties;
  final MaintenanceRecord? record;

  final void Function({
    required String propertyId,
    required String issue,
    required String description,
    required String category,
    required String priority,
    required String status,
    required String pic,
    required double estimatedCost,
    required String notes,
    DateTime? scheduledDate,
  }) onSubmit;

  const MaintenanceForm({
    super.key,
    required this.properties,
    required this.onSubmit,
    this.record,
  });

  bool get isEdit => record != null;

  @override
  State<MaintenanceForm> createState() =>
      _MaintenanceFormState();
}

class _MaintenanceFormState
    extends State<MaintenanceForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _issueController;
  late TextEditingController _descriptionController;
  late TextEditingController _picController;
  late TextEditingController _costController;
  late TextEditingController _notesController;

  String? _propertyId;
  String _category = 'Inspection';
  String _priority = 'Medium';
  String _status = 'Reported';
  DateTime? _scheduledDate;

  final List<String> _categories = [
    'Inspection',
    'HVAC',
    'Electrical',
    'Civil',
    'Building',
  ];

  final List<String> _priorities = [
    'High',
    'Medium',
    'Low',
  ];

  final List<String> _statuses = [
    'Reported',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();

    final record = widget.record;

    _issueController = TextEditingController(
      text: record?.issue ?? '',
    );

    _descriptionController = TextEditingController(
      text: record?.description ?? '',
    );

    _picController = TextEditingController(
      text: record?.pic ?? '',
    );

    _costController = TextEditingController(
      text: record == null
          ? ''
          : record.estimatedCost
              .toStringAsFixed(0),
    );

    _notesController = TextEditingController(
      text: record?.notes ?? '',
    );

    _propertyId = _resolvePropertyId(
      record?.propertyId,
    );

    if (record != null) {
      _category = record.category;
      _priority = record.priority;
      _status = record.status;
      _scheduledDate = record.scheduledDate;
    }
  }

  String? _resolvePropertyId(
    String? currentId,
  ) {
    if (widget.properties.isEmpty) {
      return null;
    }

    if (currentId != null &&
        widget.properties.any(
          (property) => property.id == currentId,
        )) {
      return currentId;
    }

    return widget.properties.first.id;
  }

  @override
  void dispose() {
    _issueController.dispose();
    _descriptionController.dispose();
    _picController.dispose();
    _costController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ==============================================================
  // SUBMIT
  // ==============================================================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_propertyId == null) {
      _showError(
        'Silakan pilih property terlebih dahulu.',
      );
      return;
    }

    final cost = double.tryParse(
          _costController.text
              .replaceAll('.', '')
              .replaceAll(',', '')
              .trim(),
        ) ??
        0;

    widget.onSubmit(
      propertyId: _propertyId!,
      issue: _issueController.text.trim(),
      description:
          _descriptionController.text.trim(),
      category: _category,
      priority: _priority,
      status: _status,
      pic: _picController.text.trim(),
      estimatedCost: cost,
      notes: _notesController.text.trim(),
      scheduledDate: _scheduledDate,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==============================================================
  // DATE
  // ==============================================================

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        _scheduledDate = result;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Pilih tanggal';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 30,
      ),
      child: Container(
        width: 760,
        constraints: const BoxConstraints(
          maxHeight: 850,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
          boxShadow: AppShadows.floating,
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    24,
                    30,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildPropertySection(),
                      const SizedBox(height: 25),
                      _buildDetailSection(),
                      const SizedBox(height: 25),
                      _buildScheduleSection(),
                      const SizedBox(height: 25),
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // HEADER
  // ==============================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        28,
        22,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  AppColors.accent.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              widget.isEdit
                  ? Icons.edit_note_rounded
                  : Icons.build_circle_outlined,
              color: AppColors.accent,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEdit
                      ? 'Edit Maintenance'
                      : 'New Maintenance Request',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color:
                        AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isEdit
                      ? 'Perbarui informasi maintenance property.'
                      : 'Buat laporan maintenance baru untuk property.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color:
                        AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Tutup',
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // PROPERTY SECTION
  // ==============================================================

  Widget _buildPropertySection() {
    return _FormSection(
      title: 'Property Information',
      subtitle:
          'Tentukan property dan klasifikasi maintenance.',
      icon: Icons.business_outlined,
      child: Column(
        children: [
          _buildPropertyDropdown(),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildCategoryDropdown(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildPrioritySelector(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDropdown() {
    return DropdownButtonFormField<String>(
      value: _propertyId,
      isExpanded: true,
      decoration: _inputDecoration(
        label: 'Property',
        hint: 'Pilih property',
        icon: Icons.location_city_outlined,
      ),
      items: widget.properties.map((property) {
        return DropdownMenuItem<String>(
          value: property.id,
          child: Text(
            property.name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _propertyId = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Property wajib dipilih';
        }

        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _categories.contains(_category)
          ? _category
          : _categories.first,
      isExpanded: true,
      decoration: _inputDecoration(
        label: 'Kategori',
        hint: 'Pilih kategori',
        icon: Icons.category_outlined,
      ),
      items: _categories.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _category = value;
        });
      },
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioritas',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _priorities.map((priority) {
            final selected =
                _priority == priority;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right:
                      priority == _priorities.last
                          ? 0
                          : 7,
                ),
                child: _PriorityOption(
                  label: priority,
                  selected: selected,
                  onTap: () {
                    setState(() {
                      _priority = priority;
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==============================================================
  // DETAIL SECTION
  // ==============================================================

  Widget _buildDetailSection() {
    return _FormSection(
      title: 'Maintenance Details',
      subtitle:
          'Masukkan informasi kerusakan atau pekerjaan.',
      icon: Icons.construction_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _issueController,
            decoration: _inputDecoration(
              label: 'Masalah',
              hint:
                  'Contoh: AC tidak dingin',
              icon:
                  Icons.warning_amber_rounded,
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Masalah wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: _inputDecoration(
              label: 'Deskripsi',
              hint:
                  'Jelaskan kondisi atau masalah property.',
              icon: Icons.notes_outlined,
              alignIconTop: true,
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Deskripsi wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _picController,
                  decoration: _inputDecoration(
                    label: 'PIC',
                    hint: 'Nama PIC',
                    icon:
                        Icons.person_outline_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextFormField(
                  controller: _costController,
                  keyboardType:
                      TextInputType.number,
                  decoration: _inputDecoration(
                    label: 'Estimasi Biaya',
                    hint: '0',
                    icon:
                        Icons.payments_outlined,
                    prefixText: 'Rp ',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // SCHEDULE
  // ==============================================================

  Widget _buildScheduleSection() {
    return _FormSection(
      title: 'Schedule & Status',
      subtitle:
          'Atur jadwal dan status pekerjaan.',
      icon: Icons.calendar_month_outlined,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 9),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statuses.map((status) {
              final selected =
                  _status == status;

              return _StatusOption(
                label: status,
                selected: selected,
                color:
                    _statusColor(status),
                onTap: () {
                  setState(() {
                    _status = status;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          InkWell(
            onTap: _pickDate,
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
            child: Container(
              padding:
                  const EdgeInsets.all(14),
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
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.accent
                          .withOpacity(0.10),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.event_outlined,
                      color:
                          AppColors.accent,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jadwal Maintenance',
                          style: TextStyle(
                            fontSize: 10.5,
                            color:
                                AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatDate(
                            _scheduledDate,
                          ),
                          style:
                              const TextStyle(
                            fontSize: 12.5,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons
                        .calendar_today_outlined,
                    size: 18,
                    color:
                        AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // NOTES
  // ==============================================================

  Widget _buildNotesSection() {
    return _FormSection(
      title: 'Additional Notes',
      subtitle:
          'Tambahkan informasi tambahan jika diperlukan.',
      icon: Icons.sticky_note_2_outlined,
      child: TextFormField(
        controller: _notesController,
        maxLines: 4,
        decoration: _inputDecoration(
          label: 'Catatan',
          hint:
              'Contoh: Material sudah tersedia...',
          icon: Icons.notes_rounded,
          alignIconTop: true,
        ),
      ),
    );
  }

  // ==============================================================
  // FOOTER
  // ==============================================================

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        28,
        16,
        28,
        18,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.isEdit)
            Text(
              widget.record!.id,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color:
                    AppColors.textSecondary,
              ),
            ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
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
            child: const Text('Batal'),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: _submit,
            icon: Icon(
              widget.isEdit
                  ? Icons.save_outlined
                  : Icons.add_rounded,
              size: 18,
            ),
            label: Text(
              widget.isEdit
                  ? 'Simpan Perubahan'
                  : 'Simpan Maintenance',
            ),
            style: FilledButton.styleFrom(
              backgroundColor:
                  AppColors.accent,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
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
      ),
    );
  }

  // ==============================================================
  // INPUT DECORATION
  // ==============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    String? prefixText,
    bool alignIconTop = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
      prefixIcon: Padding(
        padding: EdgeInsets.only(
          left: 13,
          right: 10,
          top: alignIconTop ? 14 : 0,
        ),
        child: Icon(
          icon,
          size: 19,
          color: AppColors.textSecondary,
        ),
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide: const BorderSide(
          color: AppColors.accent,
          width: 1.4,
        ),
      ),
      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  // ==============================================================
  // COLORS
  // ==============================================================

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.success;

      case 'In Progress':
        return AppColors.warning;

      case 'Reported':
      default:
        return AppColors.danger;
    }
  }
}


// ==================================================================
// FORM SECTION
// ==================================================================

class _FormSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _FormSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:
                      AppColors.accent
                          .withOpacity(0.09),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 11),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}


// ==================================================================
// PRIORITY OPTION
// ==================================================================

class _PriorityOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _color(label);

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(10),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.10)
              : AppColors.surface,
          borderRadius:
              BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? color
                : AppColors.border,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
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

  Color _color(String value) {
    switch (value) {
      case 'High':
        return AppColors.danger;

      case 'Medium':
        return AppColors.warning;

      default:
        return AppColors.success;
    }
  }
}


// ==================================================================
// STATUS OPTION
// ==================================================================

class _StatusOption extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusOption({
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
              ? color.withOpacity(0.10)
              : AppColors.surface,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? color
                : AppColors.border,
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