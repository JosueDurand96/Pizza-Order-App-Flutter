import 'package:flutter/material.dart';
import 'package:pizza_order_app/models/ingredient.dart';

const _pizzaCartSize = 55.0;

class PizzaOrderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pizza Raul Rímac',
          style: TextStyle(
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart_outlined),
            color: Colors.black,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 50,
            right: 10,
            left: 10,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Column(
                children: [
                  Expanded(
                    flex: 15,
                    child: _PizzaDetails(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _PizzaIngredients(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            height: _pizzaCartSize,
            width: _pizzaCartSize,
            left: MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
            child: _PizzaCartButton(),
          )
        ],
      ),
    );
  }
}

class _PizzaDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(
            onAccept: (ingredient) {
              print('onAccept');
            },
            onWillAccept: (ingredient) {
              print('onWillAccept');
            },
            onLeave: (ingredient) {
              print('onLeave');
            },
            builder: (context, list, rejects) {
              return Stack(
                children: [
                  Image.asset('assets/pizza_order/dish.png'),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/pizza_order/pizza-1.png'),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '\$15',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
      ],
    );
  }
}

class _PizzaCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.withOpacity(0.5),
              Colors.orange,
            ]),
      ),
      child: Icon(
        Icons.shopping_cart_outlined,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class _PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return _PizzaIngredientItem(ingredient: ingredient);
      },
    );
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  const _PizzaIngredientItem({Key key, this.ingredient}) : super(key: key);
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Container(
        height: 45,
        width: 45,
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
    return Draggable(feedback: child, data: ingredient, child: child);
  }
}
