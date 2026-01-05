import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/data/models/auth_model.dart';
import 'package:l_mobile_sales_mini/data/models/user/user_model.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/auth_provider.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/section_title.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  void goToSettings(BuildContext context) {}

  void handleLogout(BuildContext context) {}

  List<Map<String, dynamic>> getNotifications() {
    final Random random = Random();

    bool shouldGenerateEmpty = random.nextBool();

    if (shouldGenerateEmpty) {
      return [];
    }

    // generate a list of 1 to 5 notifications
    return List.generate(random.nextInt(5) + 1, (index) {
      return {
        'id': index,
        'title': 'Notification ${index + 1}',
        'message': 'Random alert Sales.',
        'timestamp': DateTime.now().subtract(Duration(minutes: index * 10)),
        'isRead': random.nextBool(),
      };
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviderAsync = ref.watch(authProviderNotifier);

    return authProviderAsync.when(
      data: (authData) {
        return Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
          ),
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildUserProfile(context, authData),
                  const SizedBox(height: 10),
                  buildNotificationsArea(context),
                  const Spacer(),

                  buildFooter(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading auth data: $e')),
    );
  }

  Widget buildUserProfile(BuildContext context, AuthModel authData) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 180),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildUserAvatar(context, authData.userData!.profileImage!),
                buildUserDetails(context, authData),
              ],
            ),
            const SizedBox(height: 8),
            buildUserRoleInfo(context, authData),
          ],
        ),
      ),
    );
  }

  Widget buildUserAvatar(BuildContext context, String profileImage) {
    return Container(
      height: 80, // Adjust size as needed
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          //profileImage
          'https://picsum.photos/400/300?1',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, size: 40, color: Colors.grey);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.green[700]!,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildUserDetails(BuildContext context, AuthModel authData) {
    final User? userData = authData.userData;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userData?.displayName ?? 'Leysco User',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          userData?.email ?? 'email@leysco.com',
          style: textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget buildUserRoleInfo(BuildContext context, AuthModel authData) {
    final User? userData = authData.userData;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: RichText(
        text: TextSpan(
          style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: userData?.region ?? 'Region'),
            TextSpan(text: ' | '),
            TextSpan(text: userData?.department ?? 'Department'),
            TextSpan(text: ' | '),
            TextSpan(text: userData?.role ?? 'Role'),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationsArea(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 250),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[600]!,
              blurRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            buildNotificationsHead(context),
            const SizedBox(height: 10),
            buildNotificationsBody(context),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationsHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SectionTitle(title: 'Notifications'),

        buildExpandButton(context, () {
          print('Expand notifications');
        }),
      ],
    );
  }

  Widget buildExpandButton(BuildContext context, Function() onTap) {
    return TextButton.icon(
      onPressed: onTap,
      style: ButtonStyle(iconAlignment: IconAlignment.end),
      label: Text(
        'More',
        style: TextTheme.of(
          context,
        ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      icon: Icon(Icons.arrow_forward, size: 20, color: Colors.black),
    );
  }

  Widget buildNotificationsBody(BuildContext context) {
    final List<Map<String, dynamic>> notifications = getNotifications();

    if (notifications.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none_outlined,
                size: 64,
                color: Colors.grey[500]!,
              ),
              const SizedBox(height: 10),
              Text(
                'No notifications yet',
                style: TextTheme.of(context).bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey[400]!, indent: 10, endIndent: 10),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item['isRead']
                  ? Colors.orange[100]
                  : Colors.orange,
              radius: 5, // indicate unread status
            ),
            title: Text(
              item['title'],
              style: TextTheme.of(context).bodyMedium?.copyWith(
                color: item['isRead'] ? Colors.grey[500] : Colors.black,
              ),
            ),
            subtitle: Text(
              item['message'],
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: item['isRead'] ? Colors.grey[500] : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              "${item['timestamp'].hour}:${item['timestamp'].minute}",
              style: TextTheme.of(context).labelMedium,
            ),
          );
        },
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildSettingsButton(context),
        const SizedBox(height: 10),
        buildLogoutButton(context),
        const SizedBox(height: 20),
        buildVersioning(context),
      ],
    );
  }

  Widget buildSettingsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          elevation: 2,
        ),
        onPressed: () => goToSettings(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings',
              style: TextTheme.of(context).bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            Icon(Icons.settings, size: 20),
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          elevation: 2,
        ),
        onPressed: () => handleLogout(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: TextTheme.of(context).bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 5),
            Icon(Icons.logout, size: 20),
          ],
        ),
      ),
    );
  }

  Widget buildVersioning(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('Leysco Mobile Sales', style: textTheme.bodyMedium),
        Text(
          'Version 1.0.0',
          style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
