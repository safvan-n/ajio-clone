import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/coupon.dart';
import '../data/dummy_data.dart';

class StoreProvider extends ChangeNotifier {
  // Products catalog
  final List<Product> _products = List.from(DummyData.products);
  List<Product> get products => _products;

  // Wishlist
  final List<Product> _wishlist = [];
  List<Product> get wishlist => _wishlist;

  // Cart / Shopping Bag
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  // Search & Filtering State
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  String? _selectedBrand;
  String? get selectedBrand => _selectedBrand;

  double _minPrice = 0;
  double _maxPrice = 15000;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  String _sortBy = 'Relevance'; // Relevance, Price: Low to High, Price: High to Low, Rating, Discount
  String get sortBy => _sortBy;

  // Applied Coupon
  Coupon? _appliedCoupon;
  Coupon? get appliedCoupon => _appliedCoupon;

  // Orders History
  final List<Map<String, dynamic>> _placedOrders = [];
  List<Map<String, dynamic>> get placedOrders => _placedOrders;

  // Global Tab Navigation Index
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Authentication State
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _currentUserName;
  String get currentUserName => _currentUserName ?? 'Guest';

  String? _currentUserEmail;
  String get currentUserEmail => _currentUserEmail ?? 'guest@ajio-clone.com';

  String? _currentUserPhone;
  String get currentUserPhone => _currentUserPhone ?? '';

  void login(String name, String email, String phone) {
    _isLoggedIn = true;
    _currentUserName = name;
    _currentUserEmail = email;
    _currentUserPhone = phone;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUserName = null;
    _currentUserEmail = null;
    _currentUserPhone = null;
    _placedOrders.clear(); // Clear session mock orders upon logout
    notifyListeners();
  }

  // --- WISHLIST OPERATIONS ---
  bool isWishlisted(Product product) {
    return _wishlist.any((item) => item.id == product.id);
  }

  void toggleWishlist(Product product) {
    final exists = isWishlisted(product);
    if (exists) {
      _wishlist.removeWhere((item) => item.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  // --- CART OPERATIONS ---
  void addToCart(Product product, String size, {int qty = 1}) {
    // Check if item with same ID and same size already in cart
    final existingIndex = _cart.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += qty;
    } else {
      _cart.add(CartItem(product: product, selectedSize: size, quantity: qty));
    }
    
    // Auto-validate coupon if order changes
    _validateCoupon();
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    _validateCoupon();
    notifyListeners();
  }

  void updateCartQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      removeFromCart(item);
      return;
    }
    item.quantity = quantity;
    _validateCoupon();
    notifyListeners();
  }

  void updateCartSize(CartItem item, String newSize) {
    // Check if the exact product with newSize already exists
    final sameProductIndex = _cart.indexWhere(
      (i) => i.product.id == item.product.id && i.selectedSize == newSize && i != item,
    );

    if (sameProductIndex >= 0) {
      // Merge them
      _cart[sameProductIndex].quantity += item.quantity;
      _cart.remove(item);
    } else {
      item.selectedSize = newSize;
    }
    notifyListeners();
  }

  // --- COUPON CALCULATIONS ---
  String? applyCoupon(String code) {
    final couponIndex = DummyData.coupons.indexWhere(
      (c) => c.code.toUpperCase() == code.trim().toUpperCase(),
    );

    if (couponIndex < 0) {
      return 'Invalid coupon code';
    }

    final coupon = DummyData.coupons[couponIndex];
    if (cartSubtotal < coupon.minPurchaseAmount) {
      return 'Min purchase of ₹${coupon.minPurchaseAmount.toInt()} required';
    }

    _appliedCoupon = coupon;
    notifyListeners();
    return null; // Null means success
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  void _validateCoupon() {
    if (_appliedCoupon != null) {
      if (cartSubtotal < _appliedCoupon!.minPurchaseAmount) {
        _appliedCoupon = null; // Auto remove if subtotal drops
      }
    }
  }

  // --- BILLING GETTERS ---
  double get cartSubtotal {
    double total = 0.0;
    for (var item in _cart) {
      total += item.totalPrice;
    }
    return total;
  }

  double get cartOriginalSubtotal {
    double total = 0.0;
    for (var item in _cart) {
      total += item.totalOriginalPrice;
    }
    return total;
  }

  double get cartTotalSavings {
    double total = 0.0;
    for (var item in _cart) {
      total += item.totalSavings;
    }
    return total;
  }

  double get couponDiscount {
    if (_appliedCoupon == null) return 0.0;
    return _appliedCoupon!.calculateDiscount(cartSubtotal);
  }

  double get deliveryFee {
    if (cartSubtotal == 0) return 0.0;
    return cartSubtotal >= 999.0 ? 0.0 : 99.0;
  }

  double get cartTotalPayable {
    if (cartSubtotal == 0) return 0.0;
    return cartSubtotal - couponDiscount + deliveryFee;
  }

  // --- CATALOG FILTERS & SEARCH ---
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setBrand(String? brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedBrand = null;
    _minPrice = 0;
    _maxPrice = 15000;
    _sortBy = 'Relevance';
    notifyListeners();
  }

  List<Product> get filteredProducts {
    List<Product> list = List.from(_products);

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) => 
        p.brand.toLowerCase().contains(q) || 
        p.title.toLowerCase().contains(q) || 
        p.category.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q)
      ).toList();
    }

    // Apply Category Filter
    if (_selectedCategory != null) {
      list = list.where((p) => p.category.toLowerCase() == _selectedCategory!.toLowerCase()).toList();
    }

    // Apply Brand Filter
    if (_selectedBrand != null) {
      list = list.where((p) => p.brand.toLowerCase() == _selectedBrand!.toLowerCase()).toList();
    }

    // Apply Price Filter
    list = list.where((p) => p.price >= _minPrice && p.price <= _maxPrice).toList();

    // Apply Sorting
    if (_sortBy == 'Price: Low to High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Discount') {
      list.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    }

    return list;
  }

  // --- CHECKOUT / ORDER SUCCESS ---
  bool checkout() {
    if (_cart.isEmpty) return false;

    // Create a mock order structure
    final order = {
      'id': 'AJIO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'date': DateTime.now(),
      'items': _cart.map((item) => {
        'brand': item.product.brand,
        'title': item.product.title,
        'size': item.selectedSize,
        'qty': item.quantity,
        'price': item.product.price,
        'image': item.product.images.first,
      }).toList(),
      'subtotal': cartSubtotal,
      'couponCode': _appliedCoupon?.code,
      'couponDiscount': couponDiscount,
      'deliveryFee': deliveryFee,
      'totalPaid': cartTotalPayable,
      'status': 'Processing',
      'estimatedDelivery': DateTime.now().add(const Duration(days: 4)),
    };

    _placedOrders.insert(0, order); // Add latest at top
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
    return true;
  }
}
