class GitHubRepo {
  final String name;
  final String? description;
  final int stargazersCount;
  final String? language;
  final String htmlUrl;

  GitHubRepo({
    required this.name,
    required this.description,
    required this.stargazersCount,
    required this.language,
    required this.htmlUrl,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'],
      description: json['description'],
      stargazersCount: json['stargazers_count'],
      language: json['language'],
      htmlUrl: json['html_url'],
    );
  }
}

