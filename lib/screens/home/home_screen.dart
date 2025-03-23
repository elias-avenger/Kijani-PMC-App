import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/controllers/user_controller.dart';
import 'package:kijani_pgc_app/app/models/group.dart';
import 'package:kijani_pgc_app/app/models/user_model.dart';
import 'package:kijani_pgc_app/app/repositories/app_repository.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find<UserController>();
  final AppRepository appRepo = Get.find<AppRepository>();
  final StorageService storageService = Get.find<StorageService>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Obx(() {
        if (userController.currentUser.value == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
          return const Center(child: CircularProgressIndicator());
        }

        final user = userController.currentUser.value!;
        return RefreshIndicator(
          onRefresh: _updateData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(user)),
              SliverToBoxAdapter(child: const SizedBox(height: 16)),
              SliverToBoxAdapter(
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildParishGroupsList(user.parishesIDs),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 24)),
              SliverToBoxAdapter(child: _buildActionButtons()),
            ],
          ),
        );
      }),
    );
  }

  // Header with user info
  Widget _buildHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.green[700],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${user.firstName} ${user.lastName}!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Parish IDs: ${user.parishesIDs}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            'You are successfully logged in.',
            style: const TextStyle(fontSize: 14, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  // List of parishes and groups
  Widget _buildParishGroupsList(String parishIdsString) {
    List<String> parishIds =
        parishIdsString.split(',').map((id) => id.trim()).toList();
    Map<String, dynamic> allGroups = storageService.fetchAllEntities(
      kGroupsDataKey,
      Group.fromJson,
    );

    if (allGroups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'No groups available yet. Try updating data.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            parishIds.map((parishId) {
              List<Group> parishGroups =
                  allGroups.values
                      .where(
                        (group) =>
                            (group as Group).parishId.trim() == parishId.trim(),
                      )
                      .cast<Group>()
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Parish ID: $parishId',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  if (parishGroups.isEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No groups found for this parish.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  else
                    ...parishGroups.map((group) => _buildGroupCard(group)),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
      ),
    );
  }

  // Card for each group
  Widget _buildGroupCard(Group group) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.group, color: Colors.green[700], size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${group.id}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Coordinates: ${group.coordinates}',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }

  // Action buttons (Logout and Update)
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.exit_to_app, size: 20),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _updateData,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Update Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update data method
  Future<void> _updateData() async {
    setState(() => isLoading = true);
    try {
      await appRepo.updateAllData();
      setState(() {});
      Get.snackbar(
        'Success',
        'Data updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Logout method
  Future<void> _logout() async {
    await storageService.deleteEntity(kUserDataKey, 'current');
    userController.currentUser.value = null;
    Get.offAllNamed('/login');
  }
}
