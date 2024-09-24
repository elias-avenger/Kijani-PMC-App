import 'package:get/get.dart';

class ReportController extends GetxController {
  // Reactive maps for different categories
  var activities = {
    'Pest and disease control ': false,
    'garden weeded': false,
    'Garden pruned': false,
    'Garden thinned': false,
    'Contracts signed with farmers': false,
    'Fireline created': false,
    'groups remobilized': false,
    'Outstanding Farmers identified in a parish': false,
    'Old groups remobilized to work again with us': false,
    'Old farmers remobilized to continue planting with us': false,
  }.obs;

  var gardenChallenges = {
    'Gardens full of weed.': false,
    'Garden not pruned': false,
    'Garden poorly pruned': false,
    'Trees planted at poor spacing': false,
    'Empty pots left in the garden during planting': false,
    'Mixing of species by farmers during planting': false,
    'Trees affected by disease': false,
    'Trees affected by pests': false,
    'Fireline not created at all': false,
    'Fireline not properly created': false,
    'Garden not thinned': false,
    'Garden poorly thinned.': false,
  }.obs;

  var farmerChallenges = {
    'Some farmers are harshly demanding for the copy of their contract.': false,
    'Few farmers are refusing to sign the contract yet they planted with us.':
        false,
    'Some farmers always demand for money once you seek their support.': false,
    'Hostility shown by some farmers due to the delay on incentive payment.':
        false,
    'Some farmers have been misled by other organizations.': false,
    'Some farmers are not willing to provide equipment for managing their plantation.':
        false,
  }.obs;

  var individualChallenges = {
    'Large working area to be covered by only one PMC.': false,
    'Delay on the provision of field facilitation like fuel delays daily activity.':
        false,
    'Insecurity.': false,
    'Wild animals attack.': false,
    'House rent is more expensive than the one given by the company.': false,
  }.obs;

  // Maps to store details for each category when selected
  var activityDetails = <String, String>{}.obs;
  var gardenChallengeDetails = <String, String>{}.obs;
  var farmerChallengeDetails = <String, String>{}.obs;
  var individualChallengeDetails = <String, String>{}.obs;

  // General method to toggle the item state in any category
  void toggleItem(String category, String item, bool value) {
    RxMap<String, bool>? map = _getMapByCategory(category);
    if (map != null) {
      map[item] = value;
      if (!value) {
        // Clear details if the item is deselected
        _getDetailsMapByCategory(category)?.remove(item);
      }
      update(); // Add this line to rebuild the UI
    }
  }

  // General method to update details for a selected item in any category
  void updateItemDetails(String category, String item, String details) {
    RxMap<String, String>? detailsMap = _getDetailsMapByCategory(category);
    if (detailsMap != null) {
      detailsMap[item] = details;
    }
  }

  // General method to get a list of selected items with their details for a category
  List<Map<String, String>> getSelectedItemsWithDetails(String category) {
    RxMap<String, bool>? map = _getMapByCategory(category);
    RxMap<String, String>? detailsMap = _getDetailsMapByCategory(category);
    if (map == null || detailsMap == null) return [];

    return map.entries
        .where((entry) => entry.value)
        .map((entry) => {
              'item': entry.key,
              'details': detailsMap[entry.key] ?? '',
            })
        .toList();
  }

  // Helper method to get the reactive map by category name
  RxMap<String, bool>? _getMapByCategory(String category) {
    switch (category) {
      case 'activities':
        return activities;
      case 'gardenChallenges':
        return gardenChallenges;
      case 'farmerChallenges':
        return farmerChallenges;
      case 'individualChallenges':
        return individualChallenges;
      default:
        return null;
    }
  }

  // Helper method to get the details map by category name
  RxMap<String, String>? _getDetailsMapByCategory(String category) {
    switch (category) {
      case 'activities':
        return activityDetails;
      case 'gardenChallenges':
        return gardenChallengeDetails;
      case 'farmerChallenges':
        return farmerChallengeDetails;
      case 'individualChallenges':
        return individualChallengeDetails;
      default:
        return null;
    }
  }
}
