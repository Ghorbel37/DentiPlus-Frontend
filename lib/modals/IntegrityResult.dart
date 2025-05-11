class IntegrityResult {
  final String message;
  final int consultationId;
  final bool isValid;

  IntegrityResult({
    required this.message,
    required this.consultationId,
    required this.isValid,
  });

  factory IntegrityResult.fromJson(Map<String, dynamic> json) {
    return IntegrityResult(
      message: json['message'] as String,
      consultationId: json['consultation_id'] as int,
      isValid: json['is_valid'] as bool,
    );
  }
}