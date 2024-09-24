import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kijani_pmc_app/controllers/report_controller.dart';
import 'package:kijani_pmc_app/utilities/constants.dart';
import 'package:kijani_pmc_app/utilities/image_picker.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  //form key
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final ReportController controller = Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Form"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Button to select activities
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23566d),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Select Activities",
                          content: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: Obx(
                              () => SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      for (String activity
                                          in controller.activities.keys)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(activity),
                                              trailing: Checkbox(
                                                activeColor: Colors.green,
                                                value: controller
                                                    .activities[activity],
                                                onChanged: (value) {
                                                  controller.toggleItem(
                                                      'activities',
                                                      activity,
                                                      value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Select Activities'),
                    ),
                    const SizedBox(height: 10),
                    // Display TextFormFields for selected activities
                    for (String activity in controller.activities.keys)
                      if (controller.activities[activity]! == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: activity == 'Pest and disease control '
                                  ? "Enter number of gardens for Pest and disease control"
                                  : "Enter number for $activity",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xff23566d),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.updateItemDetails(
                                  'activities', activity, value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                    const SizedBox(height: 10),
                    // Button to select garden challenges
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23566d),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Select Garden Challenges",
                          content: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: Obx(
                              () => SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      for (String challenge
                                          in controller.gardenChallenges.keys)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(challenge),
                                              trailing: Checkbox(
                                                activeColor: Colors.green,
                                                value:
                                                    controller.gardenChallenges[
                                                        challenge],
                                                onChanged: (value) {
                                                  controller.toggleItem(
                                                      'gardenChallenges',
                                                      challenge,
                                                      value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Select Garden Challenges'),
                    ),
                    const SizedBox(height: 10),
                    // Display TextFormFields for selected garden challenges
                    for (String challenge in controller.gardenChallenges.keys)
                      if (controller.gardenChallenges[challenge]! == true)
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "photo of $challenge",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            XFile? image =
                                await ImagePickerBrain().takePicture(context);
                            if (image != null) {
                              controller.updateItemDetails(
                                'gardenChallenges',
                                challenge,
                                image.path,
                              );
                            }
                          },
                        ),
                    // Button to select farmer challenges
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23566d),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Select Farmer Challenges",
                          content: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: Obx(
                              () => SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      for (String challenge
                                          in controller.farmerChallenges.keys)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(challenge),
                                              trailing: Checkbox(
                                                activeColor: Colors.green,
                                                value:
                                                    controller.farmerChallenges[
                                                        challenge],
                                                onChanged: (value) {
                                                  controller.toggleItem(
                                                      'farmerChallenges',
                                                      challenge,
                                                      value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Select Farmer Challenges'),
                    ),
                    const SizedBox(height: 10),
                    // Display TextFormFields for selected farmer challenges
                    for (String challenge in controller.farmerChallenges.keys)
                      if (controller.farmerChallenges[challenge]! == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Details for $challenge",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xff23566d),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.updateItemDetails(
                                  'farmerChallenges', challenge, value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter details for $challenge';
                              }
                              return null;
                            },
                          ),
                        ),
                    // Button to select individual challenges
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23566d),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Select Individual Challenges",
                          content: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: Obx(
                              () => SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      for (String challenge in controller
                                          .individualChallenges.keys)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(challenge),
                                              trailing: Checkbox(
                                                activeColor: Colors.green,
                                                value: controller
                                                        .individualChallenges[
                                                    challenge],
                                                onChanged: (value) {
                                                  controller.toggleItem(
                                                      'individualChallenges',
                                                      challenge,
                                                      value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Select Individual Challenges'),
                    ),
                    const SizedBox(height: 10),
                    // Display TextFormFields for selected individual challenges
                    for (String challenge
                        in controller.individualChallenges.keys)
                      if (controller.individualChallenges[challenge]! == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Details for $challenge",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xff23566d),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.updateItemDetails(
                                  'individualChallenges', challenge, value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter details for $challenge';
                              }
                              return null;
                            },
                          ),
                        ),
                    const SizedBox(height: 20),
                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kijaniGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        //validate form
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                          final selectedActivities = controller
                              .getSelectedItemsWithDetails('activities');
                          final selectedGardenChallenges = controller
                              .getSelectedItemsWithDetails('gardenChallenges');
                          final selectedFarmerChallenges = controller
                              .getSelectedItemsWithDetails('farmerChallenges');
                          final selectedIndividualChallenges =
                              controller.getSelectedItemsWithDetails(
                                  'individualChallenges');

                          // You can now use these lists to process or send data
                          print('Selected Activities: $selectedActivities');
                          print(
                              'Selected Garden Challenges: $selectedGardenChallenges');
                          print(
                              'Selected Farmer Challenges: $selectedFarmerChallenges');
                          print(
                              'Selected Individual Challenges: $selectedIndividualChallenges');
                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Report submitted successfully'),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit Report'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
