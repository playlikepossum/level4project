import 'package:cheyyan/db/db_helper%20copy.dart';
import 'package:cheyyan/models/abilities.dart';
import 'package:get/get.dart';

class AbilityController extends GetxController {
  var abilityList = <Abilities>[].obs;

  Future<int> addAbility({Abilities? abilities}) async {
    return await DBHelper2.insertAbilities(abilities);
  }

  void getAbilities() async {
    List<Map<String, dynamic>> abilities = await DBHelper2.queryAbilities();
    abilityList
        .assignAll(abilities.map((data) => Abilities.fromJson(data)).toList());
  }

  void updateAbilityName(String ability, int Score) async {
    await DBHelper2.updateAbilities(ability, Score);
    getAbilities();
  }
}

  // Add more methods as needed for updating abilities

  // For example:
  // void updateAbilityName(int id, String newName) async {
  //   await DBHelper.updateAbilityName(id, newName);
  //   getAbilities();
  // }
