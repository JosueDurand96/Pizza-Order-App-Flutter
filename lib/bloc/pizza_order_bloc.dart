import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pizza_order_app/models/ingredient.dart';

class PizzaMetaData {
  PizzaMetaData(this.imageBytes, this.position, this.size);

  final Uint8List imageBytes;
  final Offset position;
  final size;
}

enum PizzaSizeValue {
  s,
  m,
  l,
}

class PizzaSizeState {
  PizzaSizeState(this.value) : factor = _getFactorBySize(value);
  final PizzaSizeValue value;
  final double factor;

  static double _getFactorBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.7;
      case PizzaSizeValue.m:
        return 0.8;
      case PizzaSizeValue.l:
        return 0.9;
    }
    return 0.8;
  }
}

const initialTotal = 15;

class PizzaOrderBLoC with ChangeNotifier {
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(initialTotal);
  final notifierDeleteIngredient = ValueNotifier<Ingredient>(null);
  final notifierFocus = ValueNotifier(false);
  final notifierPizzaSize = ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));
  final notifierPizzaBoxAnimation = ValueNotifier(false);
  final notifierImagePizza = ValueNotifier<PizzaMetaData>(null);
  final notifierCartIconAnimation = ValueNotifier(0);
  int _totalCart = 0;

  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    notifierTotal.value++;
  }

  void removeIngredient(Ingredient ingredient) {
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeleteIngredient.value = ingredient;
  }

  void refreshDeletedIngredient() {
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

  void reset() {
    notifierPizzaBoxAnimation.value = false;
    notifierImagePizza.value = null;
    listIngredients.clear();
    notifierTotal.value = initialTotal;
    notifierCartIconAnimation.value++;
  }

  void startPizzaBoxAnimation() {
    notifierPizzaBoxAnimation.value = true;
  }

  Future<void> transformToImage(RenderRepaintBoundary boundary) async {
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    notifierImagePizza.value =
        PizzaMetaData(byteData.buffer.asUint8List(), position, size);
  }
}
