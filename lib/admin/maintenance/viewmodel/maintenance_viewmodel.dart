import 'package:flutter/foundation.dart';

import '../model/maintenance_model.dart';

class MaintenanceViewModel extends ChangeNotifier {
  MaintenanceViewModel()
      : _records = List<MaintenanceRecord>.from(
          dummyMaintenanceRecords,
        );

  List<MaintenanceRecord> _records;

  String _query = '';
  String? _statusFilter;

  // ==============================================================
  // GETTERS
  // ==============================================================

  List<MaintenanceRecord> get records {
    return List.unmodifiable(_records);
  }

  String get query => _query;

  String? get statusFilter => _statusFilter;

  int get totalCount => _records.length;

  int get reportedCount {
    return _records
        .where((item) => item.status == 'Reported')
        .length;
  }

  int get inProgressCount {
    return _records
        .where((item) => item.status == 'In Progress')
        .length;
  }

  int get completedCount {
    return _records
        .where((item) => item.status == 'Completed')
        .length;
  }

  double get totalEstimatedCost {
    return _records.fold(
      0,
      (sum, item) => sum + item.estimatedCost,
    );
  }

  // ==============================================================
  // SEARCH + FILTER
  // ==============================================================

  List<MaintenanceRecord> filteredRecords(
    String Function(String propertyId) propertyName,
  ) {
    final search = _query.toLowerCase().trim();

    return _records.where((record) {
      final property = propertyName(
        record.propertyId,
      ).toLowerCase();

      final matchesSearch = search.isEmpty ||
          record.id.toLowerCase().contains(search) ||
          record.issue.toLowerCase().contains(search) ||
          record.category.toLowerCase().contains(search) ||
          record.pic.toLowerCase().contains(search) ||
          property.contains(search);

      final matchesStatus =
          _statusFilter == null ||
              record.status == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setStatusFilter(String? value) {
    _statusFilter = value;
    notifyListeners();
  }

  // ==============================================================
  // CREATE
  // ==============================================================

  void addMaintenance({
    required String propertyId,
    required String issue,
    required String description,
    required String category,
    required String priority,
    required String pic,
    required double estimatedCost,
    required String notes,
    DateTime? scheduledDate,
  }) {
    final record = MaintenanceRecord(
      id: _generateId(),
      propertyId: propertyId,
      issue: issue,
      description: description,
      category: category,
      priority: priority,
      status: 'Reported',
      pic: pic.isEmpty
          ? 'Belum ditentukan'
          : pic,
      reportedDate: DateTime.now(),
      scheduledDate: scheduledDate,
      estimatedCost: estimatedCost,
      notes: notes,
    );

    _records.insert(0, record);

    notifyListeners();
  }

  // ==============================================================
  // UPDATE
  // ==============================================================

  void updateMaintenance({
    required String id,
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
  }) {
    final index = _records.indexWhere(
      (item) => item.id == id,
    );

    if (index == -1) return;

    final oldRecord = _records[index];

    _records[index] = oldRecord.copyWith(
      propertyId: propertyId,
      issue: issue,
      description: description,
      category: category,
      priority: priority,
      status: status,
      pic: pic.isEmpty
          ? 'Belum ditentukan'
          : pic,
      estimatedCost: estimatedCost,
      notes: notes,
      scheduledDate: scheduledDate,
    );

    notifyListeners();
  }

  // ==============================================================
  // DELETE
  // ==============================================================

  void deleteMaintenance(String id) {
    _records.removeWhere(
      (item) => item.id == id,
    );

    notifyListeners();
  }

  // ==============================================================
  // CHANGE STATUS
  // ==============================================================

  void updateStatus(
    String id,
    String status,
  ) {
    final index = _records.indexWhere(
      (item) => item.id == id,
    );

    if (index == -1) return;

    _records[index] = _records[index].copyWith(
      status: status,
    );

    notifyListeners();
  }

  // ==============================================================
  // ID GENERATOR
  // ==============================================================

  String _generateId() {
    int number = 1;

    while (true) {
      final id =
          'MNT-${number.toString().padLeft(3, '0')}';

      final exists = _records.any(
        (item) => item.id == id,
      );

      if (!exists) {
        return id;
      }

      number++;
    }
  }

  // ==============================================================
  // RESET FILTER
  // ==============================================================

  void resetFilter() {
    _query = '';
    _statusFilter = null;

    notifyListeners();
  }
}