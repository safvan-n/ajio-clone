import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/ajio_theme.dart';
import 'bag_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  String? _selectedSize;
  bool _isDetailsExpanded = true;
  bool _isDeliveryExpanded = false;

  void _showSizeSelectorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SELECT SIZE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AjioTheme.darkSlate,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.product.sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setStateSheet(() {
                            _selectedSize = size;
                          });
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? AjioTheme.darkSlate : Colors.white,
                            border: Border.all(
                              color: isSelected ? AjioTheme.darkSlate : AjioTheme.borderGrey,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AjioTheme.darkSlate,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedSize == null
                          ? null
                          : () {
                              Navigator.pop(context);
                              _addToBag();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AjioTheme.darkSlate,
                      ),
                      child: const Text('CONFIRM AND ADD TO BAG'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addToBag() {
    if (_selectedSize == null) {
      _showSizeSelectorSheet();
      return;
    }

    final store = Provider.of<StoreProvider>(context, listen: false);
    store.addToCart(widget.product, _selectedSize!);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added ${widget.product.brand} (Size $_selectedSize) to Bag!',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AjioTheme.successGreen,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'GO TO BAG',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BagScreen(showBackButton: true)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final isSaved = store.isWishlisted(widget.product);
    final cartCount = store.cart.fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          widget.product.brand.toUpperCase(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          // Wishlist Action
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? AjioTheme.discountRed : AjioTheme.darkSlate,
            ),
            onPressed: () => store.toggleWishlist(widget.product),
          ),
          // Cart/Bag Action
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BagScreen(showBackButton: true)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16, left: 8),
              child: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  cartCount.toString(),
                  style: const TextStyle(fontSize: 9, color: Colors.white),
                ),
                backgroundColor: AjioTheme.discountRed,
                child: const Icon(Icons.shopping_bag_outlined, color: AjioTheme.darkSlate),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel with Dots
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  color: AjioTheme.lightGrey,
                  child: PageView.builder(
                    itemCount: widget.product.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.product.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.broken_image, size: 64, color: AjioTheme.textGrey),
                        ),
                      );
                    },
                  ),
                ),
                // Indicator dots
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.product.images.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? AjioTheme.darkSlate
                              : Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
                // Premium "Trending" overlay tag
                if (widget.product.isTrending)
                  Positioned(
                    top: 16,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: AjioTheme.ajioGold,
                      child: const Text(
                        'TRENDING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Details Block
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Name
                  Text(
                    widget.product.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AjioTheme.darkSlate,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Title
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AjioTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: AjioTheme.lightGrey,
                        child: Row(
                          children: [
                            Text(
                              widget.product.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.reviewsCount} Customer Ratings',
                        style: const TextStyle(fontSize: 12, color: AjioTheme.textGrey),
                      ),
                    ],
                  ),
                  const Divider(height: 32, color: AjioTheme.borderGrey),

                  // Price Breakdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${widget.product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AjioTheme.darkSlate,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'MRP ₹${widget.product.originalPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: AjioTheme.textGrey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '(${widget.product.discountPercentage.toInt()}% OFF)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AjioTheme.discountRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price inclusive of all taxes',
                    style: TextStyle(fontSize: 11, color: Colors.green[800], fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.green.shade50,
                    child: Text(
                      'You save ₹${widget.product.savings} on this purchase!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Size Selection Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SELECT SIZE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Size Chart',
                          style: TextStyle(
                            color: AjioTheme.ajioGold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Sizes Wrap
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.product.sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        child: Container(
                          width: 54,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? AjioTheme.darkSlate : Colors.white,
                            border: Border.all(
                              color: isSelected ? AjioTheme.darkSlate : AjioTheme.borderGrey,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AjioTheme.darkSlate,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Custom Ajio Coupons Banner Drawer
                  const Text(
                    'OFFERS & PROMOTIONS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildOfferCard('AJIOMANIA', 'GET FLAT 30% OFF', 'On orders above ₹2,999'),
                        _buildOfferCard('TRENDS40', 'EXTRA 40% DISCOUNT', 'On select high-street styles'),
                        _buildOfferCard('FIRSTBUY', '₹500 SIGN-UP OFF', 'For new user’s fashion bag'),
                      ],
                    ),
                  ),

                  const Divider(height: 48, color: AjioTheme.borderGrey),

                  // Collapsible Product Description
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: _isDetailsExpanded,
                      title: const Text(
                        'PRODUCT DETAILS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AjioTheme.darkSlate),
                      ),
                      onExpansionChanged: (val) => setState(() => _isDetailsExpanded = val),
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            widget.product.description,
                            style: const TextStyle(fontSize: 13, height: 1.5, color: AjioTheme.darkSlate),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AjioTheme.borderGrey),

                  // Collapsible Delivery & Returns
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: _isDeliveryExpanded,
                      title: const Text(
                        'DELIVERY & RETURNS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AjioTheme.darkSlate),
                      ),
                      onExpansionChanged: (val) => setState(() => _isDeliveryExpanded = val),
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_shipping_outlined, size: 16, color: AjioTheme.textGrey),
                                  SizedBox(width: 8),
                                  Text('Free Delivery above ₹999 (Express shipping)', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.assignment_return_outlined, size: 16, color: AjioTheme.textGrey),
                                  SizedBox(width: 8),
                                  Text('Easy 15-day return policy', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.payment_outlined, size: 16, color: AjioTheme.textGrey),
                                  SizedBox(width: 8),
                                  Text('Cash on Delivery available', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Padding to prevent cover by bottom persistent sheet
                ],
              ),
            ),
          ],
        ),
      ),
      // Persistent Bottom Action Buttons
      bottomSheet: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Wishlist Toggle
            OutlinedButton(
              onPressed: () => store.toggleWishlist(widget.product),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                side: const BorderSide(color: AjioTheme.darkSlate, width: 1.5),
              ),
              child: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? AjioTheme.discountRed : AjioTheme.darkSlate,
              ),
            ),
            const SizedBox(width: 12),
            // Add To Bag Button
            Expanded(
              child: ElevatedButton(
                onPressed: _addToBag,
                child: const Text('ADD TO BAG'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(String code, String offer, String desc) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AjioTheme.ajioGold.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AjioTheme.lightGrey,
                child: Text(
                  code,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: AjioTheme.ajioGold,
                  ),
                ),
              ),
              const Icon(Icons.local_offer_outlined, size: 14, color: AjioTheme.ajioGold),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            offer,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AjioTheme.darkSlate,
            ),
          ),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 10,
              color: AjioTheme.textGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
