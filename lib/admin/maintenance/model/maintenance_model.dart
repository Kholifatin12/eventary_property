class MaintenanceRecord {
  final String id;
  final String propertyId;
  final String issue;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String pic;
  final DateTime reportedDate;
  final DateTime? scheduledDate;
  final double estimatedCost;
  final String notes;

  const MaintenanceRecord({
    required this.id,
    required this.propertyId,
    required this.issue,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.pic,
    required this.reportedDate,
    this.scheduledDate,
    required this.estimatedCost,
    this.notes = '',
  });

  MaintenanceRecord copyWith({
    String? propertyId,
    String? issue,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? pic,
    DateTime? reportedDate,
    DateTime? scheduledDate,
    double? estimatedCost,
    String? notes,
  }) {
    return MaintenanceRecord(
      id: id,
      propertyId: propertyId ?? this.propertyId,
      issue: issue ?? this.issue,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      pic: pic ?? this.pic,
      reportedDate: reportedDate ?? this.reportedDate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      notes: notes ?? this.notes,
    );
  }
}


// ================================================================
// DUMMY DATA
// ================================================================

final List<MaintenanceRecord> dummyMaintenanceRecords = [
  MaintenanceRecord(
    id: 'MNT-001',
    propertyId: 'PROP-001',
    issue: 'AC tidak dingin',
    description:
        'Sistem pendingin pada area utama membutuhkan pemeriksaan karena suhu ruangan tidak stabil.',
    category: 'HVAC',
    priority: 'High',
    status: 'In Progress',
    pic: 'Andi Property',
    reportedDate: DateTime(2026, 9, 22),
    scheduledDate: DateTime(2026, 9, 30),
    estimatedCost: 4500000,
    notes: 'Menunggu pengecekan teknisi HVAC.',
  ),

  MaintenanceRecord(
    id: 'MNT-002',
    propertyId: 'PROP-002',
    issue: 'Lampu area ballroom',
    description:
        'Beberapa lampu pada area ballroom tidak menyala dan perlu dilakukan penggantian.',
    category: 'Electrical',
    priority: 'Medium',
    status: 'Reported',
    pic: 'Budi Facility',
    reportedDate: DateTime(2026, 9, 25),
    estimatedCost: 1800000,
    notes: 'Perlu pengecekan panel dan lampu.',
  ),

  MaintenanceRecord(
    id: 'MNT-003',
    propertyId: 'PROP-003',
    issue: 'Perbaikan lantai',
    description:
        'Terdapat kerusakan ringan pada beberapa bagian lantai area outdoor.',
    category: 'Civil',
    priority: 'Low',
    status: 'Completed',
    pic: 'Citra Facility',
    reportedDate: DateTime(2026, 9, 10),
    scheduledDate: DateTime(2026, 9, 15),
    estimatedCost: 2500000,
    notes: 'Perbaikan telah selesai.',
  ),

  MaintenanceRecord(
    id: 'MNT-004',
    propertyId: 'PROP-004',
    issue: 'Pengecatan ulang',
    description:
        'Dinding bagian depan property membutuhkan pengecatan ulang sebelum digunakan kembali.',
    category: 'Building',
    priority: 'Medium',
    status: 'In Progress',
    pic: 'Dimas Property',
    reportedDate: DateTime(2026, 9, 20),
    scheduledDate: DateTime(2026, 10, 2),
    estimatedCost: 3200000,
    notes: 'Material cat sudah tersedia.',
  ),

  MaintenanceRecord(
    id: 'MNT-005',
    propertyId: 'PROP-005',
    issue: 'Pemeriksaan rutin',
    description:
        'Pemeriksaan kondisi fasilitas dan utilitas property secara berkala.',
    category: 'Inspection',
    priority: 'Low',
    status: 'Completed',
    pic: 'Eka Facility',
    reportedDate: DateTime(2026, 9, 5),
    scheduledDate: DateTime(2026, 9, 8),
    estimatedCost: 750000,
    notes: 'Tidak ditemukan kerusakan besar.',
  ),
];