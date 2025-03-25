import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/models/farmer.dart';
import 'package:kijani_pgc_app/app/models/garden.dart';
import 'package:kijani_pgc_app/app/models/group.dart';
import 'package:kijani_pgc_app/app/models/user_model.dart';
import 'package:kijani_pgc_app/app/repositories/farmer_repository.dart';
import 'package:kijani_pgc_app/app/repositories/garden_repository.dart';
import 'package:kijani_pgc_app/app/repositories/user_repository.dart';
import 'package:kijani_pgc_app/app/repositories/parish_repository.dart';
import 'package:kijani_pgc_app/app/repositories/group_repository.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';

class AppRepository {
  final UserRepository userRepo = Get.find<UserRepository>();
  final ParishRepository parishRepo = Get.find<ParishRepository>();
  final GroupRepository groupRepo = Get.find<GroupRepository>();
  final FarmerRepository farmerRepo = FarmerRepository();
  final GardenRepository gardenRepo = GardenRepository();
  final StorageService storageService = Get.find<StorageService>();

  Future<void> updateAllData() async {
    try {
      User? currentUser = await userRepo.fetchLocalUser();
      if (currentUser == null) {
        if (kDebugMode) print('No logged-in user found');
        return;
      }
      await _updateParishData(currentUser.parishesIDs);
    } catch (e) {
      if (kDebugMode) print('Error updating all data: $e');
    }
  }

  Future<void> _updateParishData(String parishListString) async {
    await parishRepo.saveParishList(parishListString);
    List<String> parishIds =
        parishListString.split(',').map((e) => e.trim()).toList();
    List<Group> fetchedgroups = await groupRepo.fetchAndSaveAllParishGroups(
      parishIds,
    ); // Use GroupRepository

    //fetch farmers
    for (Group group in fetchedgroups) {
      List<Farmer> farmers = await farmerRepo.fetchFarmersByGroup(group.id);
      print('Fetched ${farmers.length} farmers for group: ${group.name}');
      //fetch gardens for each farmer
      for (Farmer farmer in farmers) {
        //fetch gardens
        List<Garden> gardens = await gardenRepo.fetchGardensByFarmer(
          farmer.farmerId,
        );

        print('Fetched ${gardens.length} gardens for farmer: ${farmer.id}');
      }
    }
  }
}
