import 'dart:io';

import 'package:cheyyan/auth/auth_gate.dart';
import 'package:cheyyan/controllers/ability_controller.dart';
import 'package:cheyyan/ui/calander.dart';
import 'package:cheyyan/ui/quests.dart';
import 'package:cheyyan/ui/theme.dart';
import 'package:cheyyan/ui/widgets/shopz.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:health/health.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class _ProfileState extends State<Profile> {
  final AbilityController _abilityController = Get.find();

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    _abilityController.getAbilities();
    if (_state != AppState.AUTHORIZED) {
      authorize();
    } else {
      fetchData();
      fetchStepData();
    }
  }

  // Define the types to get.
  // NOTE: These are only the ones supported on Androids new API Health Connect.
  // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
  // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
  // static final types = HealthDataType.STEPS;
  // Or selected types
  static final types = [
    HealthDataType.STEPS,
    //   // Uncomment these lines on iOS - only available on iOS
    //   // HealthDataType.AUDIOGRAM
  ];

  // with corresponsing permissions
  // READ only
  // final permissions = types.map((e) => HealthDataAccess.READ).toList();
  // Or READ and WRITE
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  // Future authorize() async {
  //   // If we are trying to read Step Count, Workout, Sleep or other data that requires
  //   // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
  //   // This requires a special request authorization call.
  //   //
  //   // The location permission is requested for Workouts using the Distance information.
  //   await Permission.activityRecognition.request();
  //   await Permission.location.request();
//
  //   // Check if we have permission
  //   bool? hasPermissions =
  //       await health.hasPermissions(types, permissions: permissions);
//
  //   // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
  //   // Hence, we have to request with WRITE as well.
  //   hasPermissions = false;
//
  //   bool authorized = false;
  //   if (!hasPermissions) {
  //     // requesting access to the data types before reading them
  //     try {
  //       authorized =
  //           await health.requestAuthorization(types, permissions: permissions);
  //     } catch (error) {
  //       print("Exception in authorize: $error");
  //     }
  //   }
//
  //   setState(() => _state =
  //       (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  // }

  Future<void> authorize() async {
    // Request necessary permissions
    await Permission.activityRecognition.request();
    // await Permission.location.request();

    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);
    bool authorized = false;

    if (hasPermissions.isNull ||
        hasPermissions != true ||
        authorized == false) {
      try {
        authorized = await health.requestAuthorization(types);
      } catch (error) {
        print("Exception in authorize: $error");
      }
      // try {
      //   authorized = await health.requestAuthorization(types);
      // } catch (error) {
      //   print("Exception in authorize: $error");
      // }
    }
    if (mounted) {
      setState(() {
        _state = (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED;
      });
    }

    if (authorized) {
      fetchData();
      fetchStepData();
    }
  }

  Future<void> fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    // final yesterday = DateTime(now.year, now.month, now.day);
    _healthDataList.clear();

    try {
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(yesterday, now, types);
      _healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }

    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
    // for (var x in _healthDataList) {
    //   // print(x);
    // }

    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    });
  }

  /// Add some random health data.
  Future addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 20));

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;
    success &= await health.writeHealthData(
        1.925, HealthDataType.HEIGHT, earlier, now);
    success &=
        await health.writeHealthData(90, HealthDataType.WEIGHT, earlier, now);
    success &= await health.writeHealthData(
        90, HealthDataType.HEART_RATE, earlier, now);
    success &=
        await health.writeHealthData(90, HealthDataType.STEPS, earlier, now);
    success &= await health.writeHealthData(
        200, HealthDataType.ACTIVE_ENERGY_BURNED, earlier, now);
    success &= await health.writeHealthData(
        70, HealthDataType.HEART_RATE, earlier, now);
    success &= await health.writeHealthData(
        37, HealthDataType.BODY_TEMPERATURE, earlier, now);
    success &= await health.writeBloodOxygen(98, earlier, now, flowRate: 1.0);
    success &= await health.writeHealthData(
        105, HealthDataType.BLOOD_GLUCOSE, earlier, now);
    success &=
        await health.writeHealthData(1.8, HealthDataType.WATER, earlier, now);
    success &= await health.writeWorkoutData(
        HealthWorkoutActivityType.AMERICAN_FOOTBALL,
        now.subtract(const Duration(minutes: 15)),
        now,
        totalDistance: 2430,
        totalEnergyBurned: 400);
    success &= await health.writeBloodPressure(90, 80, earlier, now);
    // success &= await health.writeHealthData(
    // 0.0, HealthDataType.SLEEP_REM, earlier, now);
    // success &= await health.writeHealthData(
    //     0.0, HealthDataType.SLEEP_ASLEEP, earlier, now);
    // success &= await health.writeHealthData(
    //     0.0, HealthDataType.SLEEP_AWAKE, earlier, now);
    // success &= await health.writeHealthData(
    //     0.0, HealthDataType.SLEEP_DEEP, earlier, now);

    // success &= await health.writeMeal(
    //     earlier, now, 1000, 50, 25, 50, "Banana", MealType.SNACK);
    // Store an Audiogram
    // Uncomment these on iOS - only available on iOS
    // const frequencies = [125.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0];
    // const leftEarSensitivities = [49.0, 54.0, 89.0, 52.0, 77.0, 35.0];
    // const rightEarSensitivities = [76.0, 66.0, 90.0, 22.0, 85.0, 44.5];

    // success &= await health.writeAudiogram(
    //   frequencies,
    //   leftEarSensitivities,
    //   rightEarSensitivities,
    //   now,
    //   now,
    //   metadata: {
    //     "HKExternalUUID": "uniqueID",
    //     "HKDeviceName": "bluetooth headphone",
    //   },
    // );

    setState(() {
      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    });
  }

  // /// Delete some random health data.
  // Future deleteData() async {
  //   final now = DateTime.now();
  //   final earlier = now.subtract(const Duration(hours: 24));

  //   bool success = true;
  //   for (HealthDataType type in types) {
  //     success &= await health.delete(type, earlier, now);
  //   }

  //   setState(() {
  //     _state = success ? AppState.DATA_DELETED : AppState.DATA_NOT_DELETED;
  //   });
  // }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _steps = (steps == null) ? '0' : steps.toString();
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Future revokeAccess() async {
    try {
      await health.revokePermissions();
    } catch (error) {
      print("Caught exception in revokeAccess: $error");
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              strokeWidth: 10,
            )),
        const Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text(p.unitString),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
              trailing: Text(
                  (p.value as WorkoutHealthValue).workoutActivityType.name),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is NutritionHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString} ${(p.value as NutritionHealthValue).mealType}: ${(p.value as NutritionHealthValue).name}"),
              trailing:
                  Text('${(p.value as NutritionHealthValue).calories} kcal'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text(p.unitString),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return const Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
    );
  }

  Widget _authorized() {
    return const Text('Authorization granted!');
  }

  Widget _authorizationNotGranted() {
    return const Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return const Text('Data points inserted successfully!');
  }

  Widget _dataDeleted() {
    return const Text('Data points deleted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return const Text('Failed to add data');
  }

  Widget _dataNotDeleted() {
    return const Text('Failed to delete data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY) {
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTHORIZED)
      return _authorized();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.DATA_ADDED)
      return _dataAdded();
    else if (_state == AppState.DATA_DELETED)
      return _dataDeleted();
    else if (_state == AppState.STEPS_READY)
      return _stepsFetched();
    else if (_state == AppState.DATA_NOT_ADDED)
      return _dataNotAdded();
    else if (_state == AppState.DATA_NOT_DELETED)
      return _dataNotDeleted();
    else
      return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    String currentLevel = '';
    double progress = 0.0;
    double maxLevel = 1;
    File? _profileImage = File("images/profile.jpg");

    // print(_abilityController.abilityList);
    for (var x in _abilityController.abilityList) {
      progress = x.exp.toDouble() - x.exp.floor().toDouble();
      maxLevel = x.exp.ceil().toDouble() - x.exp.floor().toDouble();
      if (progress == 0.0 && maxLevel == 0.0) {
        maxLevel += 1.0;
      }
      currentLevel = x.exp.floor().toString();
    }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: pinkClr,
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Quests'),
              onTap: () async {
                await Get.to(() => const Quests());
              },
            ),
            ListTile(
              title: const Text('Shop'),
              onTap: () async {
                await Get.to(() => DownloadPage());
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () async {
                await Get.to(() => const Profile());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.colorScheme.background,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: const [
            // CircleAvatar(
            //   backgroundImage: AssetImage("images/profile.jpg"),
            // ),
            SizedBox(
              width: 20,
            ),
          ]),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [bluishClr, greenClr],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.deepOrange.shade300,
                  child: ListTile(
                    title: Text(
                      _steps,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text(
                      'Step Count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Stats:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    children: _abilityController.abilityList
                        .map(
                          (ability) => ListTile(
                            title: Text('Strength: ${ability.strength} \n'
                                'Intelligence: ${ability.intelligence}\n'
                                'Charisma: ${ability.charisma}\n'
                                'Constitution: ${ability.constitution}'),

                            // Add more details or actions as needed
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  ('Level: ${currentLevel}'),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress / maxLevel,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete quests to level up quicker and gain more experience!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //   body: Column(
    //     children: [
    //       Wrap(
    //         spacing: 10,
    //         children: [
    //           TextButton(
    //               onPressed: authorize,
    //               style: const ButtonStyle(
    //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
    //               child: const Text("Auth",
    //                   style: TextStyle(color: Colors.white))),
    //           TextButton(
    //               onPressed: fetchData,
    //               style: const ButtonStyle(
    //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
    //               child: const Text("Fetch Data",
    //                   style: TextStyle(color: Colors.white))),
    //           TextButton(
    //               onPressed: addData,
    //               style: const ButtonStyle(
    //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
    //               child: const Text("Add Data",
    //                   style: TextStyle(color: Colors.white))),
    //           TextButton(
    //               onPressed: deleteData,
    //               style: const ButtonStyle(
    //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
    //               child: const Text("Delete Data",
    //                   style: TextStyle(color: Colors.white))),
    //           TextButton(
    //               onPressed: fetchStepData,
    //               style: const ButtonStyle(
    //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
    //               child: const Text("Fetch Step Data",
    //                   style: TextStyle(color: Colors.white))),
    //           TextButton(
    //               onPressed: revokeAccess,
    //               style: const ButtonStyle(
    //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
    //               child: const Text("Revoke Access",
    //                   style: TextStyle(color: Colors.white))),
    //         ],
    //       ),
    //       const Divider(thickness: 3),
    //       Expanded(child: Center(child: _content()))
    //     ],
    //   ),
    // );
  }

  _showBottomSheet(
    BuildContext context,
  ) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      color: Get.isDarkMode ? darkGreyClr : white,
      height: MediaQuery.of(context).size.height * 0.18,
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          SignOutButton(),
          _bottomSheetButton(
            label: "Close",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthGate()),
              );
            },
            clr: pinkClr,
            isClose: true,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(label,
              style: isClose
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
