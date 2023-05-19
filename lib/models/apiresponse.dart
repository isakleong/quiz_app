class ApiResponse {
  final String message;
  final int code;

  ApiResponse({required this.message, required this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
    };
  }
}