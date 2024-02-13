import 'package:cheyyan/db/db_helper%20copy.dart';
import 'package:cheyyan/models/abilities.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AbilityController extends GetxController {
  var abilityList = <Abilities>[].obs;
  var list = GetStorage();

  Future<int> addAbility({Abilities? abilities}) async {
    return await DBHelper2.insertAbilities(abilities);
  }

  void getAbilities() async {
    List<Map<String, dynamic>> abilities = await DBHelper2.queryAbilities();
    abilityList
        .assignAll(abilities.map((data) => Abilities.fromJson(data)).toList());
  }

  Future<RxList<Abilities>> getTaskList() async {
    getAbilities();
    return abilityList;
  }

  void updateAbilityName(String ability, int Score) async {
    await DBHelper2.updateAbilities(ability, Score);
    getAbilities();
  }

  void incrementAbilityName(String ability) async {
    await DBHelper2.incrementAbilities(ability);
    getAbilities();
  }

  void levelUP(double value) async {
    await DBHelper2.expBonus(value);
    getAbilities();
  }
}

  // Add more methods as needed for updating abilities

  // For example:
  // void updateAbilityName(int id, String newName) async {
  //   await DBHelper.updateAbilityName(id, newName);
  //   getAbilities();
  // }
