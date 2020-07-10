class Product {
  final int id;
  final String name;
  Product({this.id, this.name});
}

class Cart {
  final int id;
  final List<int> proIds;
  final List<int> qty;
  Cart({this.id, this.proIds, this.qty});
}

class Command {
  final int id;
  final String title;
  final int cartId;
  final int state;
  final String date;
  Command({this.id, this.date, this.state, this.cartId, this.title});
}

List<Product> products = [
  Product(id: 0, name: 'Booster'),
  Product(id: 1, name: 'Guinness'),
  Product(id: 2, name: 'Jus d\'ananas'),
  Product(id: 3, name: 'Kadji'),
  Product(id: 4, name: 'Chivas Regal'),
];

List<Cart> carts = [
  Cart(id: 0, proIds: [0, 1], qty: [3, 2]),
  Cart(id: 1, proIds: [2], qty: [1]),
  Cart(id: 2, proIds: [3, 4], qty: [5, 1]),
  Cart(id: 3, proIds: [0, 1], qty: [3, 2]),
  Cart(id: 4, proIds: [0, 1], qty: [3, 2]),
  Cart(id: 5, proIds: [2], qty: [1]),
  Cart(id: 6, proIds: [0, 1], qty: [3, 2]),
  Cart(id: 7, proIds: [0, 1], qty: [3, 2]),
  Cart(id: 8, proIds: [3, 4], qty: [5, 1]),
];

List<Command> commands = [
  Command(id: 0, cartId: 0, title: 'S0-1301', state: 1, date: '5min'),
  Command(id: 0, cartId: 1, title: 'S0-1300', state: -1, date: '15min'),
  Command(id: 0, cartId: 2, title: 'S0-1299', state: 0, date: '1h'),
  Command(id: 0, cartId: 3, title: 'S0-1298', state: 1, date: '5h'),
  Command(id: 0, cartId: 4, title: 'S0-1297', state: 1, date: '20h'),
  Command(id: 0, cartId: 5, title: 'S0-1296', state: 0, date: '1jour'),
  Command(id: 0, cartId: 6, title: 'S0-1295', state: 1, date: '2semaine'),
  Command(id: 0, cartId: 7, title: 'S0-1294', state: -1, date: '1mois'),
];
