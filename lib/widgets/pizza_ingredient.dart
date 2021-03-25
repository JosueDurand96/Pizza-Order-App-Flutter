import 'package:flutter/material.dart';
import 'package:pizza_order_app/models/ingredient.dart';

const itemSize = 45.0;

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return PizzaIngredientItem(ingredient: ingredient);
      },
    );
  }
}


class PizzaIngredientItem extends StatelessWidget {
  const PizzaIngredientItem({Key key, this.ingredient}) : super(key: key);
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Container(
        height: itemSize,
        width: itemSize,
        decoration: BoxDecoration(
          color: Color(0xFFF5EED3),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            ingredient.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
    return Center(
      child: Draggable(
        feedback: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.black26,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 5.0),
            ],
          ),
          child: child,
        ),
        data: ingredient,
        child: child,
      ),
    );
  }
}