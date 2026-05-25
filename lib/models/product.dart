class Product {
  final String id;
  final String brand;
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final String category;
  final List<String> images;
  final List<String> sizes;
  final double rating;
  final int reviewsCount;
  final bool isNew;
  final bool isTrending;

  Product({
    required this.id,
    required this.brand,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.category,
    required this.images,
    required this.sizes,
    required this.rating,
    required this.reviewsCount,
    this.isNew = false,
    this.isTrending = false,
  });

  // Calculate discount dynamically if needed
  int get savings => (originalPrice - price).toInt();
}
