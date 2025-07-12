class APIs {
  static const String baseUrl = "https://api.github.com";
  static const String userName = "kawserfdev";


  static String repo(String username, int page) {
    return "$baseUrl/users/$username/repos?per_page=10&page=$page";
  }
}
