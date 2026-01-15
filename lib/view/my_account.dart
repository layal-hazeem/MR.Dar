import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/view/settings_screen.dart';
import '../controller/my_account_controller.dart';
import '../controller/auth_controller.dart';
import '../model/user_model.dart';
import 'edit_profile.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  final MyAccountController controller = Get.find<MyAccountController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading State
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      }

      final user = controller.user.value;

      // No User Data
      if (user == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off,
                size: 80,
                color: Theme.of(context).disabledColor,
              ),
              SizedBox(height: 20),
              Text(
                "No Profile Data".tr,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.loadProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  "Try Again".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.refreshProfile();
        },
        color: Theme.of(context).colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Cached Data Indicator
              if (controller.isDataFromLocal.value) _cachedDataBanner(context),

              _buildProfileHeader(context, user),
              const SizedBox(height: 30),
              _buildOptionsSection(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  Widget _cachedDataBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 18, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Showing cached data. Pull down to refresh.".tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Column(
      children: [
        // Profile Image
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 3),
          ),
          child: ClipOval(
            child: user.profileImage != null && user.profileImage!.isNotEmpty
                ? Image.network(
                    user.profileImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFF274668),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),

        const SizedBox(height: 16),

        // Name
        Text(
          "${user.firstName} ${user.lastName}",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Phone
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              size: 16,
              color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              user.phone,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Role
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: user.role == 'owner'.tr
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1)
                    : Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: getAccountStatusColor(user.status),
                  width: 1,
                ),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: user.role == 'owner'.tr
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Refresh Button
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            //
            //   child: OutlinedButton.icon(
            //     onPressed: () => controller.loadProfile(),
            //     icon: const Icon(Icons.refresh),
            //     label: Text(""),
            //     style: OutlinedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       side: BorderSide(
            //         color: Theme.of(context).colorScheme.primary,
            //         width: 2,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: getAccountStatusColor(
                  user.status,
                ).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: getAccountStatusColor(user.status),
                  width: 1,
                ),
              ),
              child: Text(
                getAccountStatusLabel(user.status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: getAccountStatusColor(user.status),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(Icons.person, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context) {
    return Column(
      children: [
        _buildOptionCard(
          context: context,
          icon: Icons.edit_outlined,
          title: "Edit Profile".tr,
          subtitle: "Update your personal information".tr,
          onTap: () async {
            await Get.to(() => EditProfileScreen())?.then((value) {
              if (value == 'updated') {
                controller.loadProfile();
              }
            });
          },
        ),
        const SizedBox(height: 12),

        _buildOptionCard(
          context: context,
          icon: Icons.settings_outlined,
          title: "Settings".tr,
          subtitle: "App preferences and configurations".tr,
          onTap: () => Get.to(() => SettingsScreen()),
        ),

        const SizedBox(height: 24),

        // ===== Logout =====
        _buildOptionCard(
          context: context,
          icon: Icons.logout,
          title: "Logout".tr,
          subtitle: "Sign out from your account".tr,
          onTap: () => controller.showLogoutDialog(),
        ),

        const SizedBox(height: 12),

        // ===== Delete Account =====
        _buildOptionCard(
          icon: Icons.delete_outline,
          title: "Delete Account".tr,
          subtitle: "This action cannot be undone".tr,
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () => controller.showDeleteAccountFlow(Get.context!),
          context: context,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            textColor ??
                            Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAccountStatusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'ACTIVE';
      case 'blocked':
        return 'BLOCKED';
      case 'rejected':
      default:
        return 'INACTIVE';
    }
  }

  Color getAccountStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'blocked':
        return Colors.red;
      case 'rejected':
      default:
        return Colors.orange;
    }
  }
}
