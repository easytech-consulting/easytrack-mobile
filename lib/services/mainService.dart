import 'package:easytrack/models/mainModels.dart';

Product getProductById(int id) {
  Product response;
  for (var product in products) {
    if (product.id == id) response = product;
  }
  return response;
}

Cart getCartById(int id) {
  Cart response;
  for (var cart in carts) {
    if (cart.id == id) response = cart;
  }
  return response;
}

class FormatCommand {
  final Command command;
  final List<Product> products;
  final List<int> qties;
  FormatCommand({this.command, this.products, this.qties});
}

List<FormatCommand> fetchRecentCommands() {
  return commands.map((command) {
    Cart cart = getCartById(command.cartId);
    List<int> qties = [];
    List<Product> products = [];
    for (int i = 0; i < cart.proIds.length; i++) {
      products.add(getProductById(cart.proIds[i]));
      qties.add(cart.qty[i]);
    }
    return FormatCommand(command: command, products: products, qties: qties);
  }).toList();
}
