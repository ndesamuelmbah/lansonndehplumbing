import 'package:lansonndehplumbing/models/plumbing_menu_items.dart';

class OrderedMenuItem {
  final PlumbingMenuItem menuItem;
  int quantity;

  OrderedMenuItem({
    required this.menuItem,
    required this.quantity,
  });

  // Factory method to create a PlumbingMenuItem object from a JSON map
  factory OrderedMenuItem.fromJson(Map<String, dynamic> json) {
    final plumbingMenuItem = PlumbingMenuItem(
      itemId: json['itemId'] as int,
      itemName: json['itemName'],
      itemPrice: json['itemPrice'].toDouble(),
      itemImage: json['itemImage'],
      stringPrice: json['stringPrice'],
    );
    return OrderedMenuItem(
        menuItem: plumbingMenuItem, quantity: json['quantity'] as int);
  }

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }
}

class OrderedMenuItems {
  List<OrderedMenuItem> orderedMenuItems;

  OrderedMenuItems({
    required this.orderedMenuItems,
  });

  // Factory method to create a PlumbingMenuItem object from a JSON map
  factory OrderedMenuItems.fromJson(Map<String, dynamic> json,
      {String key = 'orderedMenuItems'}) {
    return OrderedMenuItems(
        orderedMenuItems: (json[key] as List<dynamic>)
            .map((e) => OrderedMenuItem.fromJson(e))
            .toList());
  }

  double getTotalPrice() {
    return orderedMenuItems
        .map((e) => e.quantity * e.menuItem.itemPrice)
        .reduce((value, element) => value + element);
  }

  List<Map<String, dynamic>> toJson() {
    return orderedMenuItems.map((e) {
      var orderedMenuItem = e.menuItem.toJson();
      orderedMenuItem['totalPrice'] = e.menuItem.itemPrice * e.quantity;
      orderedMenuItem['quantity'] = e.quantity;
      return orderedMenuItem;
    }).toList();
  }

  bool hasItems() => orderedMenuItems.isNotEmpty;

  void addItem(PlumbingMenuItem addedItem) {
    bool hasUpdated = false;
    for (int index = 0; index < orderedMenuItems.length; index++) {
      var currentItem = orderedMenuItems[index];
      if (currentItem.menuItem == addedItem) {
        currentItem.increaseQuantity();
        orderedMenuItems[index] = currentItem;
        hasUpdated = true;
        break;
      }
    }
    if (!hasUpdated) {
      orderedMenuItems.add(OrderedMenuItem(menuItem: addedItem, quantity: 1));
    }
  }

  void removeItem(PlumbingMenuItem removedItem) {
    for (int index = 0; index < orderedMenuItems.length; index++) {
      var currentItem = orderedMenuItems[index];
      if (currentItem.menuItem == removedItem) {
        currentItem.decreaseQuantity();
        orderedMenuItems[index] = currentItem;
        if (currentItem.quantity <= 0) {
          orderedMenuItems
              .removeWhere((element) => element.menuItem == removedItem);
        }
        break;
      }
    }
  }
}
