import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:labtest1/models/repo_model.dart';
import 'package:labtest1/utils/apis.dart';

class GitHubService {
  Future<List<GitHubRepo>> fetchRepos(String username, int page) async {
    final response = await http.get(Uri.parse(APIs.repo(username, page)));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => GitHubRepo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
