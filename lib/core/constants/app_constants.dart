class AppConstants {
  // ============================================================
  // SUPABASE CONFIG - thay bằng thông tin của bạn khi vào thi
  // ============================================================
  static const String supabaseUrl = 'https://zfwevluhwzygmvvlutog.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpmd2V2bHVod3p5Z212dmx1dG9nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQwMTAxNDUsImV4cCI6MjA4OTU4NjE0NX0.fPNNpStbHP2EydUrrgzWOM2AYjcCU9lue4cYKpQMatE';

  // ============================================================
  // GOOGLE SIGN IN - lấy từ Google Cloud Console
  // Web Client ID (OAuth 2.0 > Web client)
  // ============================================================
  static const String googleWebClientId =
      '571495207196-riomh8c94k5vghjb1f6nuorsh17egogb.apps.googleusercontent.com';

  // ============================================================
  // TABLE NAMES - đổi tên theo đề khi vào thi
  // ============================================================
  static const String tableMajor   = 'Major';
  static const String tableStudent = 'Student';

  // ============================================================
  // COLUMN NAMES - đổi theo đề khi vào thi
  // ============================================================
  // Major columns
  static const String majorId   = 'IDMajor';
  static const String majorName = 'nameMajor';

  // Student columns
  static const String studentId       = 'ID';
  static const String studentName     = 'name';
  static const String studentDate     = 'date';
  static const String studentGender   = 'gender';
  static const String studentEmail    = 'email';
  static const String studentAddress  = 'Address';
  static const String studentPhone    = 'Phone';
  static const String studentMajorId  = 'idMajor';
}
