import 'package:flutter/material.dart';
import '../models/repo_model.dart';
import '../services/github_service.dart';
import '../utils/apis.dart';



class RepoChangeNotifier extends ChangeNotifier {
  final GitHubService _service;
  RepoChangeNotifier(this._service);

  final List<GitHubRepo> _repos = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _username = APIs.userName;
 

  List<GitHubRepo> get repos => _repos;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;


  Future<void> loadRepos({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _repos.clear();
      _page = 1;
      _hasMore = true;
    }
    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();
    try {
      final newRepos = await _service.fetchRepos(_username, _page);
      _repos.addAll(newRepos);
      _page++;
      if (newRepos.length < 10) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Error loading repos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
