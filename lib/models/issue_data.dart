
class IssueData {
  final String title;
  final String notes;
  final String description;
  final String date;
  final String zone;
  final String zoneLocation;
  final String serial;
  final String status;
  final String id;

  IssueData({
    required this.title,
    required this.notes,
    required this.date,
    required this.description,
    required this.status,
    required this.zone,
    required this.zoneLocation,
    required this.serial,
    required this.id
  });
}