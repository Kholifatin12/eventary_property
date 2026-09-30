import '../admin/event/model/event_model.dart';

final List<Event> dummyEvents = [
  Event(
    id: 'EVT-001',
    name: 'Jakarta Fashion Week',
    type: 'Exhibition',
    propertyId: 'PROP-001',
    propertyName: 'Mall ABC',
    startDate: DateTime(2026, 10, 10),
    endDate: DateTime(2026, 10, 12),
    organizer: 'PT Fashion Indonesia',
    pic: 'Andi Pratama',
    status: 'Scheduled',
    description:
        'Event fashion yang menggunakan area utama properti.',
  ),

  Event(
    id: 'EVT-002',
    name: 'Food Exhibition',
    type: 'Exhibition',
    propertyId: 'PROP-002',
    propertyName: 'Mall XYZ',
    startDate: DateTime(2026, 10, 20),
    endDate: DateTime(2026, 10, 22),
    organizer: 'PT Kuliner Nusantara',
    pic: 'Budi Santoso',
    status: 'Ongoing',
    description:
        'Pameran makanan dan minuman dengan beberapa tenant.',
  ),

  Event(
    id: 'EVT-003',
    name: 'Music Festival',
    type: 'Festival',
    propertyId: 'PROP-003',
    propertyName: 'Event Venue A',
    startDate: DateTime(2026, 9, 5),
    endDate: DateTime(2026, 9, 7),
    organizer: 'PT Music Indonesia',
    pic: 'Citra Dewi',
    status: 'Completed',
    description:
        'Festival musik yang telah selesai dilaksanakan.',
  ),
];