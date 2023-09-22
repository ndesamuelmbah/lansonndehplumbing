import 'package:lansonndehplumbing/core/utils/general_utils.dart';
import 'package:lansonndehplumbing/core/utils/strings.dart';
import 'package:lansonndehplumbing/models/ordered_item.dart';
import 'package:flutter/material.dart';

class OrderedMenuItemsSummary extends StatelessWidget {
  final OrderedMenuItems orderedMenuItems;
  final bool addDeliveryPrice;
  final String title;
  const OrderedMenuItemsSummary(
      {super.key,
      required this.orderedMenuItems,
      this.addDeliveryPrice = false,
      required this.title});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Roboto');

    double totalPrice = orderedMenuItems.getTotalPrice();
    double deliveryPrice = 0.0;
    if (addDeliveryPrice) {
      totalPrice += deliveryPrice;
    }
    List<Widget> items = [
      Flexible(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding:
                addDeliveryPrice ? const EdgeInsets.only(bottom: 10) : null,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blue, width: 2)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: style),
                        Text(getFormatedCurrency(r"$", totalPrice),
                            style: style),
                      ],
                    ),
                  ),
                ),
                if (addDeliveryPrice)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.includesDeliveryPriceOf.replaceAll('100', ''),
                          //style: style,
                        ),
                        Text(getFormatedCurrency(r"$", deliveryPrice),
                            style: style),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ];
    items.addAll(orderedMenuItems.orderedMenuItems.map((orderedItem) =>
        OrderedMenuItemSummary(
            orderedMenuItem: orderedItem, currencyCode: r"$")));
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items);
  }
}

class OrderedMenuItemSummary extends StatelessWidget {
  final OrderedMenuItem orderedMenuItem;
  final String currencyCode;
  const OrderedMenuItemSummary(
      {super.key, required this.orderedMenuItem, this.currencyCode = r'$'});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
    return Card(
      elevation: 5,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${orderedMenuItem.quantity}  ${orderedMenuItem.menuItem.itemName}',
                style: style,
              ),
              Text(
                getFormatedCurrency(
                    currencyCode,
                    orderedMenuItem.quantity *
                        orderedMenuItem.menuItem.itemPrice),
                textAlign: TextAlign.center,
                style: style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
