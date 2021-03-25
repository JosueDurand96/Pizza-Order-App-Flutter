import 'package:flutter/material.dart';
import 'package:pizza_order_app/bloc/pizza_order_provider.dart';
import 'package:pizza_order_app/models/ingredient.dart';

const itemSize = 45.0;

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return ValueListenableBuilder(
        valueListenable: bloc.notifierTotal,
        builder: (context, value, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return PizzaIngredientItem(
                ingredient: ingredient,
                exist: bloc.containsIngredients(ingredient),
                onTap: (){
                  bloc.removeIngredient(ingredient);
                  print('delete me');
                },
              );
            },
          );
        });
  }
}

class PizzaIngredientItem extends StatelessWidget {
  const PizzaIngredientItem({
    Key key,
    this.ingredient,
    this.exist,
    this.onTap,
  }) : super(key: key);
  final Ingredient ingredient;
  final bool exist;
  final VoidCallback onTap;

  Widget _buildChild({bool withImage = true}) {
    return GestureDetector(
      onTap: exist ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Container(
          height: itemSize,
          width: itemSize,
          decoration: BoxDecoration(
              color: Color(0xFFF5EED3),
              shape: BoxShape.circle,
              border: exist ? Border.all(color: Colors.red, width: 2) : null),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: withImage
                ? Image.asset(
                    ingredient.image,
                    fit: BoxFit.contain,
                  )
                : SizedBox.fromSize(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: exist
          ? _buildChild()
          : Draggable(
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
                child: _buildChild(),
              ),
              data: ingredient,
              child: _buildChild(),
            ),
    );
  }
}
