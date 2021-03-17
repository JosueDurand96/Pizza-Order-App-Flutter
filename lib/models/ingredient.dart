import 'package:flutter/cupertino.dart';

class Ingredient {
  const Ingredient(this.image);
  final String image;

  bool compare(Ingredient ingredient) => ingredient.image == image;
}

final ingredients = const <Ingredient>[
  Ingredient('assets/pizza_order/chili.png'),
  Ingredient('assets/pizza_order/garlic.png'),
  Ingredient('assets/pizza_order/olive.png'),
  Ingredient('assets/pizza_order/onion.png'),
  Ingredient('assets/pizza_order/pea.png'),
  Ingredient('assets/pizza_order/pickle.png'),
  Ingredient('assets/pizza_order/potato.png'),
];