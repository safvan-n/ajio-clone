class Coupon {
  final String code;
  final String title;
  final String description;
  final double discountPercentage;
  final double minPurchaseAmount;
  final double maxDiscountAmount;

  Coupon({
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.minPurchaseAmount,
    required this.maxDiscountAmount,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minPurchaseAmount) return 0.0;
    double discount = subtotal * (discountPercentage / 100);
    return discount > maxDiscountAmount ? maxDiscountAmount : discount;
  }
}
