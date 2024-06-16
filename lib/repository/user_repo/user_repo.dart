abstract class UserRepo {
  Future<Map<String, dynamic>> signIn({
    required String event,
  });
  Future<Map<String, dynamic>> welcomeUser({
    required String eventID,
    required String name,
    required String email,
  });
  Future<Map<String, dynamic>> chnageName({
    required String name,
  });
}
