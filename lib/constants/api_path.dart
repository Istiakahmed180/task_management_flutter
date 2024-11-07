class ApiPath {
  // Base URL API Path
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";

  // Authentication API Path
  static const String registration = "$_baseUrl/Registration";
  static const String login = "$_baseUrl/Login";
  static const String emailAddressVerify = "$_baseUrl/RecoverVerifyEmail";
  static const String pinCodeVerify = "$_baseUrl/RecoverVerifyOTP";
  static const String setPassword = "$_baseUrl/RecoverResetPassword";

  // Task API Path
  static const String createNewTask = "$_baseUrl/createTask";
  static const String newTaskList = "$_baseUrl/listTaskByStatus/New";
  static const String completeTaskList = "$_baseUrl/listTaskByStatus/Completed";
  static const String canceledTaskList = "$_baseUrl/listTaskByStatus/Canceled";
  static const String progressTaskList = "$_baseUrl/listTaskByStatus/Progress";
}
