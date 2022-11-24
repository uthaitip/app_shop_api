import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItems({
    super.key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: ((direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      }),
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (cxt) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart? '),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('NO')),
            ],
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text(price.toString()))),
          ),
          title: Text(title),
          subtitle: Text('total: \$${(price * quantity)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
