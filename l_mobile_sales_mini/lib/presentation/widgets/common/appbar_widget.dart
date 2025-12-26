import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void showNotifications() {
    print('Show notifications');
  }

  void openMenu() {
    print('Open menu');
  }

  void showProfile() {
    print('Show profile');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      leading: buildMenuIcon(context),
      actions: [
        buildNotifications(context),
        const SizedBox(height: 10,),
        buildUserProfileWidget(context),
      ],
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 24
      ),
    );
  }

  Widget buildMenuIcon(BuildContext context) {
    return IconButton(
        onPressed: openMenu,
        icon: Icon(
          Icons.menu,
        )
    );
  }

  Widget buildNotifications(BuildContext context) {
    return InkWell(
      onTap: showNotifications,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications,
          ),
          // Notification badge
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  '3',
                  style: TextTheme.of(context).labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildUserProfileWidget(BuildContext context) {
    return InkWell(
      onTap: showProfile,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.network(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
          height: Size.fromHeight(kToolbarHeight).height,
        ),
      ),
    );
  }
}
