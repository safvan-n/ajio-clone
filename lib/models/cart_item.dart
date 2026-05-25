import 'product.dart';

class CartItem {
  final Product product;
  String selectedSize;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  double get totalOriginalPrice => product.originalPrice * quantity;
  double get totalSavings => (product.originalPrice - product.price) * quantity;
}
