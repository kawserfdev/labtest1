import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labtest1/providers/github_providers.dart';
import 'package:labtest1/providers/state_notifier.dart';
import 'package:labtest1/widgets/loading_widgets.dart';

final repoNotifierProvider = ChangeNotifierProvider((ref) {
  final service = ref.read(githubServiceProvider);
  return RepoChangeNotifier(service)..loadRepos();
});

class RepositoriesScreen extends ConsumerStatefulWidget {
  const RepositoriesScreen({super.key});

  @override
  ConsumerState<RepositoriesScreen> createState() => _RepositoriesScreenState();
}

class _RepositoriesScreenState extends ConsumerState<RepositoriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final notifier = ref.read(repoNotifierProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !notifier.isLoading &&
        notifier.hasMore) {
      ref.read(repoNotifierProvider.notifier).loadRepos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(repoNotifierProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(repoNotifierProvider.notifier)
              .loadRepos(refresh: true);
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: size.height * 0.06,
              floating: true,
              pinned: true,
              elevation: 0,
              //backgroundColor: const Color(0xFF1976D2),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, size: size.height * 0.03),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Repositories',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            if (notifier.repos.isEmpty && notifier.isLoading)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => //CircularProgressIndicator(),
                    ShimmerLoading(child: RepoCardSkeleton()),
                    childCount: 6,
                  ),
                ),
              )
            else if (notifier.repos.isEmpty && !notifier.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No repositories found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This user doesn\'t have any public repositories',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Text(
                        '${notifier.repos.length} repositories found',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (notifier.hasMore)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'More available',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < notifier.repos.length) {
                        final repo = notifier.repos[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: _buildRepoCard(repo, context),
                        );
                      } else if (notifier.isLoading) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Loading more repositories...',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      }
                      return null;
                    },
                    childCount:
                        notifier.repos.length + (notifier.isLoading ? 1 : 0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRepoCard(repo, BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    repo.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${repo.stargazersCount}',
                        style: TextStyle(
                          color: Colors.amber[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (repo.description != null && repo.description!.isNotEmpty)
              Text(
                repo.description!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                'No description available',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                if (repo.language != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getLanguageColor(repo.language!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getLanguageColor(
                          repo.language!,
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getLanguageColor(repo.language!),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          repo.language!,
                          style: TextStyle(
                            color: _getLanguageColor(repo.language!),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getLanguageColor(String language) {
    final colors = {
      'Dart': const Color(0xFF0175C2),
      'JavaScript': const Color(0xFFF7DF1E),
      'Python': const Color(0xFF3776AB),
      'Java': const Color(0xFFED8B00),
      'Swift': const Color(0xFFFA7343),
      'Kotlin': const Color(0xFF0095D5),
      'TypeScript': const Color(0xFF007ACC),
      'Go': const Color(0xFF00ADD8),
      'Rust': const Color(0xFF000000),
      'C++': const Color(0xFF00599C),
      'C#': const Color(0xFF239120),
      'PHP': const Color(0xFF777BB4),
      'Ruby': const Color(0xFFCC342D),
    };
    return colors[language] ?? Colors.grey[600]!;
  }
}
