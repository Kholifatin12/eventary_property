class Event {
  final String id;
  final String name;
  final String type;
  final String propertyId;
  final String propertyName;
  final DateTime startDate;
  final DateTime endDate;
  final String organizer;
  final String pic;
  final String status;
  final String description;

  Event({
    required this.id,
    required this.name,
    required this.type,
    required this.propertyId,
    required this.propertyName,
    required this.startDate,
    required this.endDate,
    required this.organizer,
    required this.pic,
    required this.status,
    required this.description,
  });

  Event copyWith({
    String? id,
    String? name,
    String? type,
    String? propertyId,
    String? propertyName,
    DateTime? startDate,
    DateTime? endDate,
    String? organizer,
    String? pic,
    String? status,
    String? description,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      organizer: organizer ?? this.organizer,
      pic: pic ?? this.pic,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}