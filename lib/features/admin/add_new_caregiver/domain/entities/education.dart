class Education {
  final String degree;
  final String institution;
  final DateTime? completionDate;

  Education({
    required this.degree,
    required this.institution,
    this.completionDate,
  });
}