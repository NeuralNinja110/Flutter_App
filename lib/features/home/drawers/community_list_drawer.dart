import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:wemace/core/common/error_text.dart';
import 'package:wemace/core/common/loader.dart';
import 'package:wemace/core/constants/constants.dart';
import 'package:wemace/features/auth/controller/auth_controller.dart';
import 'package:wemace/features/community/controller/community_controller.dart';
import 'package:wemace/models/community_model.dart';
import 'package:wemace/theme/pallete.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({Key? key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                user.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: currentTheme.dividerColor),
              ),
              accountEmail: GestureDetector(
                onTap: () => navigateToUserProfile(context, user.uid),
                child: Text(
                  'View Profile',
                  style: TextStyle(color: currentTheme.dividerColor),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              decoration: BoxDecoration(),
            ),
            ListTile(
              leading: const Icon(
                Icons.add_business_outlined,
                color: Colors.purple,
              ),
              title: const Text('Create a Community'),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final community = communities[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: currentTheme.indicatorColor,
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 24,
                          ),
                          title: Text('${community.name}'),
                          onTap: () {
                            navigateToCommunity(context, community);
                          },
                        );
                      },
                    ),
                  ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
            const Divider(),
            const SizedBox(height: 8),
            ListTile(
              leading: Image.asset(Constants.googleAnalytics),
              title: const Text('Google Analytics'),
              onTap: () {},
            ),
            // Settings
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.deepPurple,
              ),
              title: const Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
