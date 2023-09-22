import 'package:lansonndehplumbing/core/utils/general_utils.dart';
import 'package:lansonndehplumbing/models/store_menu.dart';
import 'package:flutter/material.dart';

class MenuItemSummary extends StatefulWidget {
  final StoreMenuItem storeMenuItem;
  final int orderedQuantity;
  final String currencyCode;
  const MenuItemSummary(
      {super.key,
      required this.storeMenuItem,
      required this.orderedQuantity,
      required this.currencyCode});

  @override
  State<MenuItemSummary> createState() => _MenuItemSummaryState();
}

class _MenuItemSummaryState extends State<MenuItemSummary> {
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
                '${widget.orderedQuantity}  ${widget.storeMenuItem.itemName}',
                style: style,
              ),
              Text(
                getFormatedCurrency(widget.currencyCode,
                    widget.orderedQuantity * widget.storeMenuItem.itemPrice),
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
