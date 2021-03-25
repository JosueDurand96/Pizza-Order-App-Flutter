import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:pizza_order_app/models/ingredient.dart';

class PizzaOrderBLoC with ChangeNotifier {
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(15);
  final notifierDeleteIngredient = ValueNotifier<Ingredient>(null);

  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    notifierTotal.value++;
  }

  void removeIngredient(Ingredient ingredient) {
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeleteIngredient.value = ingredient;
  }

  void refreshDeletedIngredient(){
    notifierDeleteIngredient.value = null;
  }

  bool containsIngredients(Ingredient ingredient) {
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }
}
