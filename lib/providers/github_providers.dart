import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labtest1/models/repo_model.dart';
import 'package:labtest1/services/github_service.dart';
import 'package:labtest1/utils/apis.dart';

final githubServiceProvider = Provider((ref) => GitHubService());

final usernameProvider = StateProvider<String>((ref) => APIs.userName);

final repoListProvider = FutureProvider.family<List<GitHubRepo>, int>((
  ref,
  page,
) async {
  final username = ref.watch(usernameProvider);
  final service = ref.read(githubServiceProvider);
  return service.fetchRepos(username, page);
});
