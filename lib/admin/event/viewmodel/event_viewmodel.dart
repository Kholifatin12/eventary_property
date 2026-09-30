import 'package:flutter/foundation.dart';

import '../../../data/dummy_events.dart';
import '../model/event_model.dart';

class EventViewModel extends ChangeNotifier {
  final List<Event> _events = List.from(dummyEvents);

  String _searchQuery = '';
  String _selectedStatus = 'Semua';

  List<Event> get events => List.unmodifiable(_events);

  String get searchQuery => _searchQuery;

  String get selectedStatus => _selectedStatus;

  List<Event> get filteredEvents {
    return _events.where((event) {
      final query = _searchQuery.toLowerCase();

      final matchSearch =
          event.name.toLowerCase().contains(query) ||
          event.organizer.toLowerCase().contains(query) ||
          event.id.toLowerCase().contains(query);

      final matchStatus =
          _selectedStatus == 'Semua' ||
          event.status == _selectedStatus;

      return matchSearch && matchStatus;
    }).toList();
  }

  int get totalEvents => _events.length;

  int get scheduledEvents =>
      _events.where((e) => e.status == 'Scheduled').length;

  int get ongoingEvents =>
      _events.where((e) => e.status == 'Ongoing').length;

  int get completedEvents =>
      _events.where((e) => e.status == 'Completed').length;

  void search(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _selectedStatus = value;
    notifyListeners();
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void updateEvent(Event event) {
    final index = _events.indexWhere(
      (item) => item.id == event.id,
    );

    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere(
      (event) => event.id == id,
    );

    notifyListeners();
  }

  String generateId() {
    return 'EVT-${(_events.length + 1).toString().padLeft(3, '0')}';
  }
}