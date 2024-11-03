class ApiPath {
  // Base URL API Path
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";

  // Authentication API Path
  static const String registration = "$_baseUrl/Registration";
  static const String login = "$_baseUrl/Login";
  static const String emailAddressVerify = "$_baseUrl/RecoverVerifyEmail";
  static const String pinCodeVerify = "$_baseUrl/RecoverVerifyOTP";
  static const String setPassword = "$_baseUrl/RecoverResetPassword";

  // User Profile API Path
  static const String userProfile = "$_baseUrl/ProfileDetails";

  // Task API Path
  static const String createNewTask = "$_baseUrl/createTask";
  static const String taskListByStatus = "$_baseUrl/listTaskByStatus";
  static const String deleteTask = "$_baseUrl/deleteTask";

  // Profile API Path
  static const String profileUpdate = "$_baseUrl/ProfileUpdate";
}
