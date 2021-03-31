import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pizza_order_app/bloc/pizza_order_bloc.dart';
import 'package:pizza_order_app/bloc/pizza_order_provider.dart';
import 'package:pizza_order_app/models/ingredient.dart';
import 'package:pizza_order_app/widgets/pizza_cart_button.dart';
import 'package:pizza_order_app/widgets/pizza_ingredient.dart';
import 'package:pizza_order_app/widgets/pizza_size_button.dart';

const _pizzaCartSize = 55.0;

class PizzaOrderDetails extends StatefulWidget {
  @override
  _PizzaOrderDetailsState createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  final bloc = PizzaOrderBLoC();

  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      bloc: bloc,
      child: Scaffold(
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
                      flex: 4,
                      child: _PizzaDetails(),
                    ),
                    Expanded(
                      flex: 2,
                      child: PizzaIngredients(),
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
              child: PizzaCartButton(
                onTap: () {
                  bloc.startPizzaBoxAnimation();
                  print('cart');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PizzaDetails extends StatefulWidget {
  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationRotationController;
  final _keyPizza = GlobalKey();
  List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaConstraints;

  Widget _buildIngredientsWidgets(Ingredient deletedIngredient) {
    List<Widget> elements = [];
    final listIngredients =
        List.from(PizzaOrderProvider.of(context).listIngredients);
    if (deletedIngredient != null) {
      listIngredients.add(deletedIngredient);
    }
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        final ingredientWidget = Image.asset(ingredient.imageUnit, height: 40);
        for (int j = 0; j < ingredient.positions.length; j++) {
          final animation = _animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx;
          final positionY = position.dy;
          if (i == listIngredients.length - 1 &&
              _animationController.isAnimating) {
            double fromX = 0.0, fromY = 0.0;
            if (j < 1) {
              fromX = -_pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = _pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -_pizzaConstraints.maxHeight * (1 - animation.value);
            } else {
              fromY = _pizzaConstraints.maxHeight * (1 - animation.value);
            }
            final opacity = animation.value;

            if (animation.value > 0) {
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        fromX + _pizzaConstraints.maxWidth * positionX,
                        fromY + _pizzaConstraints.maxHeight * positionY,
                      ),
                    child: ingredientWidget,
                  ),
                ),
              );
            }
          } else {
            elements.add(
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _pizzaConstraints.maxWidth * positionX,
                    _pizzaConstraints.maxHeight * positionY,
                  ),
                child: ingredientWidget,
              ),
            );
          }
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  void _buildIngredientsAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
      curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      parent: _animationController,
    ));
    _animationList.add(CurvedAnimation(
      curve: Interval(0.2, 0.8, curve: Curves.decelerate),
      parent: _animationController,
    ));
    _animationList.add(CurvedAnimation(
      curve: Interval(0.4, 1.0, curve: Curves.decelerate),
      parent: _animationController,
    ));
    _animationList.add(CurvedAnimation(
      curve: Interval(0.1, 0.7, curve: Curves.decelerate),
      parent: _animationController,
    ));
    _animationList.add(CurvedAnimation(
      curve: Interval(0.3, 1.0, curve: Curves.decelerate),
      parent: _animationController,
    ));
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animationRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierPizzaBoxAnimation.addListener(() {

        if(bloc.notifierPizzaBoxAnimation.value){
          _addPizzaToCart();
        }

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(
            onAccept: (ingredient) {
              print('onAccept');
              bloc.notifierFocus.value = false;
              bloc.addIngredient(ingredient);
              _buildIngredientsAnimation();
              _animationController.forward(from: 0.0);
            },
            onWillAccept: (ingredient) {
              print('onWillAccept');
              bloc.notifierFocus.value = true;

              return !bloc.containsIngredients(ingredient);
            },
            onLeave: (ingredient) {
              print('onLeave');
              bloc.notifierFocus.value = false;
            },
            builder: (context, list, rejects) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  _pizzaConstraints = constraints;
                  return ValueListenableBuilder<PizzaMetaData>(
                      valueListenable: bloc.notifierImagePizza,
                      builder: (context, data, child) {
                        if (data != null) {
                          Future.microtask(() => _startPizzaBoxAnimation(data));
                        }
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 60),
                          opacity: data != null ? 0.0 : 1,
                          child: ValueListenableBuilder<PizzaSizeState>(
                            valueListenable: bloc.notifierPizzaSize,
                            builder: (context, pizzaSize, _) {
                              return RepaintBoundary(
                                key: _keyPizza,
                                child: RotationTransition(
                                  turns: CurvedAnimation(
                                    curve: Curves.elasticOut,
                                    parent: _animationRotationController,
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: bloc.notifierFocus,
                                            builder: (context, focused, _) {
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                width: focused
                                                    ? constraints.maxWidth *
                                                        pizzaSize.factor
                                                    : constraints.maxWidth *
                                                            pizzaSize.factor -
                                                        30,
                                                child: Stack(
                                                  children: [
                                                    DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 15.0,
                                                            color: Colors.black26,
                                                            offset:
                                                                Offset(0.0, 5.0),
                                                            spreadRadius: 5.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Image.asset(
                                                          'assets/pizza_order/dish.png'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Image.asset(
                                                          'assets/pizza_order/pizza-1.png'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      ValueListenableBuilder<Ingredient>(
                                          valueListenable:
                                              bloc.notifierDeleteIngredient,
                                          builder:
                                              (context, deletedIngredient, _) {
                                            _animateDeletedIngredient(
                                                deletedIngredient);

                                            return AnimatedBuilder(
                                              animation: _animationController,
                                              builder: (context, _) {
                                                return _buildIngredientsWidgets(
                                                    deletedIngredient);
                                              },
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        ValueListenableBuilder<int>(
          valueListenable: bloc.notifierTotal,
          builder: (context, totalValue, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: Offset(0.0, 0.0),
                        end: Offset(0.0, animation.value),
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: Text(
                '\$$totalValue',
                key: UniqueKey(),
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        ValueListenableBuilder<PizzaSizeState>(
          valueListenable: bloc.notifierPizzaSize,
          builder: (context, pizzaSize, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PizzaSizeButton(
                  text: 'S',
                  onTap: () {
                    updatePizzaSize(PizzaSizeValue.s);
                  },
                  selected: pizzaSize.value == PizzaSizeValue.s,
                ),
                PizzaSizeButton(
                  text: 'M',
                  onTap: () {
                    updatePizzaSize(PizzaSizeValue.m);
                  },
                  selected: pizzaSize.value == PizzaSizeValue.m,
                ),
                PizzaSizeButton(
                  text: 'L',
                  onTap: () {
                    updatePizzaSize(PizzaSizeValue.l);
                  },
                  selected: pizzaSize.value == PizzaSizeValue.l,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _animateDeletedIngredient(Ingredient deletedIngredient) async {
    if (deletedIngredient != null) {
      await _animationController.reverse(from: 1.0);
      final bloc = PizzaOrderProvider.of(context);
      bloc.refreshDeletedIngredient();
    }
  }

  void updatePizzaSize(PizzaSizeValue value) {
    final bloc = PizzaOrderProvider.of(context);
    bloc.notifierPizzaSize.value = PizzaSizeState(value);
    _animationRotationController.forward(from: 0.0);
  }

  void _addPizzaToCart() {
    final bloc = PizzaOrderProvider.of(context);
    RenderRepaintBoundary boundary =
        _keyPizza.currentContext.findRenderObject();
    bloc.transformToImage(boundary);
  }

  OverlayEntry _overlayEntry;

  void _startPizzaBoxAnimation(PizzaMetaData metaData) {
    final bloc = PizzaOrderProvider.of(context);
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return PizzaOrderAnimation(
          metaData: metaData,
          onComplete: (){
            _overlayEntry.remove();
            _overlayEntry = null;
            bloc.reset();
          },
        );
      });
      Overlay.of(context).insert(_overlayEntry);
    }
  }
}

class PizzaOrderAnimation extends StatefulWidget {
  const PizzaOrderAnimation({Key key, this.metaData, this.onComplete})
      : super(key: key);
  final PizzaMetaData metaData;
  final VoidCallback onComplete;

  @override
  _PizzaOrderAnimationState createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata  = widget.metaData;
    return Positioned(
      top: metadata.position.dy,
      left: metadata.position.dx,
      width: metadata.size.width,
      height: metadata.size.height,
      child: GestureDetector(
        onTap: (){
          widget.onComplete();
        },
        child: Center(
          child: Image.memory(
            widget.metaData.imageBytes,
          ),
        ),
      ),
    );
  }
}
