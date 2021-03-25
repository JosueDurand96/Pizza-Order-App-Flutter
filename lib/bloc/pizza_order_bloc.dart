import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:pizza_order_app/models/ingredient.dart';

class PizzaOrderBLoC with ChangeNotifier {

  final listIngredients = <Ingredient>[];
  final notifierTotal  = ValueNotifier(15);

  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    notifierTotal.value ++;
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
