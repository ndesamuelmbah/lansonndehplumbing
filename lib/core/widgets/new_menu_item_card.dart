import 'package:flutter/material.dart';
import 'package:lansonndehplumbing/core/widgets/action_button.dart';
import 'package:lansonndehplumbing/models/ordered_item.dart';
import 'package:lansonndehplumbing/models/plumbing_menu_items.dart';

class NewMenuItemCard extends StatelessWidget {
  final PlumbingMenuItem menuItem;
  final OrderedMenuItems orderedMenuItems;
  final void Function() onItemAdded;

  final void Function() onItemRemoved;

  NewMenuItemCard({
    super.key,
    required this.menuItem,
    required this.orderedMenuItems,
    required this.onItemAdded,
    required this.onItemRemoved,
  });

  @override
  Widget build(BuildContext context) {
    int quantityInCart = 0;
    bool itemIsInCart = orderedMenuItems.orderedMenuItems.any(
      (element) => element.menuItem == menuItem,
    );
    if (itemIsInCart) {
      quantityInCart = orderedMenuItems.orderedMenuItems
          .where(
            (element) => element.menuItem == menuItem,
          )
          .map((e) => e.quantity)
          .reduce((value, element) => value + element);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
            color: itemIsInCart ? Colors.green.shade600 : Colors.white,
            width: 2), // Set the border color to blue
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(menuItem.itemImage),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        text: menuItem.stringPrice,
                        color: Colors.transparent,
                        fontColor: Colors.black,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white,
                        radius: 5,
                        maxWidth: 150,
                        onPressed: () {},
                      ),
                      itemIsInCart
                          ? ActionButton(
                              text: itemIsInCart
                                  ? quantityInCart == 1
                                      ? '$quantityInCart  is in Cart'
                                      : '$quantityInCart  are in Cart'
                                  : 'Add To Cart',
                              color: Colors.green,
                              fontColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.green.shade300,
                              radius: 5,
                              maxWidth: 150,
                              onPressed: () {
                                onItemAdded();
                              },
                            )
                          : ActionButton(
                              text: 'Add To Cart',
                              color: Colors.blue,
                              fontColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.blue.shade300,
                              radius: 5,
                              maxWidth: 150,
                              onPressed: () {
                                onItemAdded();
                              },
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 23.0, vertical: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      menuItem.itemName,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (itemIsInCart)
              Positioned(
                right: 1,
                top: 1,
                child: GestureDetector(
                  onTap: onItemRemoved,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.red.shade300, width: 3),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Center(
                      child: Icon(
                        Icons.remove,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                // child: CustomIconButton(
                //   color: Colors.white,
                //   onPressed: () {
                //     orderedMenuItems.removeItem(menuItem);
                //   },
                //   icon: Icon(
                //     Icons.minimize_outlined,
                //     size: 30,
                //     color: Colors.red,
                //   ),
                // ),
              ),
            //),
          ],
        ),
      ),
    );
  }
}
