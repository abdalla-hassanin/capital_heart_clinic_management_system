class WorkHistory {
  final String jobTitle;
  final String employer;
  final DateTime? startDate;
  final DateTime? endDate;
  final String responsibilities;

  WorkHistory({
    required this.jobTitle,
    required this.employer,
    this.startDate,
    this.endDate,
    required this.responsibilities,
  });
}