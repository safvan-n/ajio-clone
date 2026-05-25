import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../models/cart_item.dart';
import '../theme/ajio_theme.dart';
import 'login_screen.dart';

class BagScreen extends StatefulWidget {
  final bool showBackButton;

  const BagScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _showSizeSelector(BuildContext context, CartItem item) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHANGE SIZE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AjioTheme.darkSlate,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: item.product.sizes.map((size) {
                  final isSelected = item.selectedSize == size;
                  return GestureDetector(
                    onTap: () {
                      store.updateCartSize(item, size);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 58,
                      height: 46,
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
            ],
          ),
        );
      },
    );
  }

  void _showQtySelector(BuildContext context, CartItem item) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHANGE QUANTITY',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AjioTheme.darkSlate,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(5, (index) => index + 1).map((qty) {
                  final isSelected = item.quantity == qty;
                  return GestureDetector(
                    onTap: () {
                      store.updateCartQuantity(item, qty);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 58,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isSelected ? AjioTheme.darkSlate : Colors.white,
                        border: Border.all(
                          color: isSelected ? AjioTheme.darkSlate : AjioTheme.borderGrey,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        qty.toString(),
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
            ],
          ),
        );
      },
    );
  }

  void _showCouponDrawer(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final subtotal = store.cartSubtotal;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (context) {
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
                    'APPLY PROMO COUPON',
                    style: TextStyle(
                      fontSize: 14,
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
              const Divider(color: AjioTheme.borderGrey),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    _buildCouponItem(
                      context,
                      'AJIOMANIA',
                      'Get Flat 30% discount on orders above ₹2,999.',
                      subtotal >= 2999,
                      'Min Purchase: ₹2,999',
                    ),
                    _buildCouponItem(
                      context,
                      'TRENDS40',
                      'Save flat 40% off on premium styles above ₹3,499.',
                      subtotal >= 3499,
                      'Min Purchase: ₹3,499',
                    ),
                    _buildCouponItem(
                      context,
                      'FIRSTBUY',
                      'Extra 15% off for first order above ₹1,499.',
                      subtotal >= 1499,
                      'Min Purchase: ₹1,499',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCouponItem(
    BuildContext context,
    String code,
    String description,
    bool isEligible,
    String footer,
  ) {
    final store = Provider.of<StoreProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEligible ? Colors.white : AjioTheme.lightGrey,
        border: Border.all(
          color: isEligible ? AjioTheme.ajioGold : AjioTheme.borderGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                color: isEligible ? Colors.amber.shade50 : AjioTheme.borderGrey,
                child: Text(
                  code,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isEligible ? AjioTheme.ajioGold : AjioTheme.textGrey,
                  ),
                ),
              ),
              if (isEligible)
                TextButton(
                  onPressed: () {
                    store.applyCoupon(code);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coupon $code Applied Successfully!'),
                        backgroundColor: AjioTheme.successGreen,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'APPLY',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AjioTheme.ajioGold),
                  ),
                )
              else
                Text(
                  'NOT ELIGIBLE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red.shade400),
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AjioTheme.darkSlate),
          ),
          const SizedBox(height: 6),
          Text(
            footer,
            style: const TextStyle(fontSize: 10, color: AjioTheme.textGrey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _triggerCheckoutDialog(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final totalPayable = store.cartTotalPayable;
    final orderId = 'AJIO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AjioTheme.successGreen,
                  size: 72,
                ),
                const SizedBox(height: 16),
                const Text(
                  'ORDER PLACED!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: AjioTheme.darkSlate,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Order ID: $orderId',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AjioTheme.ajioGold),
                ),
                const SizedBox(height: 16),
                const Divider(color: AjioTheme.borderGrey),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Paid:', style: TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                    Text(
                      '₹${totalPayable.toInt()}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment Mode:', style: TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                    Text(
                      'Cash on Delivery',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AjioTheme.successGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated Delivery:', style: TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                    Text(
                      'In 4-5 working days',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      store.checkout(); // Process checkout state, saves order to profile, clears cart
                      Navigator.pop(context); // Close dialog
                      if (widget.showBackButton) {
                        Navigator.pop(context); // Pop detailed screen back
                      }
                      store.setTabIndex(4); // Switches to Profile Tab to view history!
                    },
                    child: const Text('VIEW MY ORDERS'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final cart = store.cart;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AjioTheme.darkSlate),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'S H O P P I N G  B A G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: AjioTheme.darkSlate,
          ),
        ),
      ),
      body: cart.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AjioTheme.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: AjioTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'YOUR BAG IS EMPTY!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AjioTheme.darkSlate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We have thousands of styles waiting for you. Let’s add some fashion!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AjioTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          store.setTabIndex(0); // Switch to Home Tab
                          if (widget.showBackButton) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('CONTINUE SHOPPING'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cart items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: AjioTheme.borderGrey, width: 1.0),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Thumbnail
                            Container(
                              width: 80,
                              height: 104,
                              color: AjioTheme.lightGrey,
                              child: Image.network(
                                item.product.images.first,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.product.brand.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.0,
                                          color: AjioTheme.darkSlate,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.delete_outline, size: 20, color: AjioTheme.textGrey),
                                        onPressed: () => store.removeFromCart(item),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: AjioTheme.textGrey),
                                  ),
                                  const SizedBox(height: 8),
                                  // Size and Qty selectors
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _showSizeSelector(context, item),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AjioTheme.borderGrey),
                                          ),
                                          child: Row(
                                            children: [
                                              Text('Size: ${item.selectedSize}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.keyboard_arrow_down, size: 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => _showQtySelector(context, item),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AjioTheme.borderGrey),
                                          ),
                                          child: Row(
                                            children: [
                                              Text('Qty: ${item.quantity}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.keyboard_arrow_down, size: 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Price
                                  Row(
                                    children: [
                                      Text(
                                        '₹${item.product.price.toInt() * item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AjioTheme.darkSlate,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '₹${item.product.originalPrice.toInt() * item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          decoration: TextDecoration.lineThrough,
                                          color: AjioTheme.textGrey,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${item.product.discountPercentage.toInt()}% OFF)',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AjioTheme.discountRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  // Coupon Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'APPLY PROMO CODE',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Coupon (e.g. AJIOMANIA)',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_couponController.text.trim().isEmpty) return;
                                  final err = store.applyCoupon(_couponController.text);
                                  if (err != null) {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(err),
                                        backgroundColor: AjioTheme.discountRed,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Coupon ${_couponController.text.toUpperCase()} Applied!'),
                                        backgroundColor: AjioTheme.successGreen,
                                      ),
                                    );
                                    _couponController.clear();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AjioTheme.darkSlate,
                                ),
                                child: const Text('APPLY'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _showCouponDrawer(context),
                          icon: const Icon(Icons.percent, size: 14, color: AjioTheme.ajioGold),
                          label: const Text(
                            'View all active promo offers & coupons',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AjioTheme.ajioGold,
                            ),
                          ),
                        ),

                        // Active coupon notification banner
                        if (store.appliedCoupon != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: AjioTheme.successGreen, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'COUPON ${store.appliedCoupon!.code} ACTIVE',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AjioTheme.successGreen),
                                      ),
                                      Text(
                                        'Saved an extra ₹${store.couponDiscount.toInt()} on your bag!',
                                        style: TextStyle(fontSize: 11, color: Colors.green.shade900),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AjioTheme.discountRed, size: 20),
                                  onPressed: () => store.removeCoupon(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Divider(height: 8, thickness: 8, color: AjioTheme.lightGrey),

                  // Order Summary Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORDER DETAILS',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Bag Total (MRP)', style: TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                            Text('₹${store.cartOriginalSubtotal.toInt()}', style: const TextStyle(fontSize: 13, color: AjioTheme.darkSlate)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Bag Discount', style: TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                            Text('-₹${store.cartTotalSavings.toInt()}', style: const TextStyle(fontSize: 13, color: AjioTheme.discountRed, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (store.appliedCoupon != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Coupon Discount (${store.appliedCoupon!.code})', style: const TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                              Text('-₹${store.couponDiscount.toInt()}', style: const TextStyle(fontSize: 13, color: AjioTheme.discountRed, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee', style: TextStyle(fontSize: 13, color: AjioTheme.textGrey)),
                            Text(
                              store.deliveryFee == 0 ? 'FREE' : '₹${store.deliveryFee.toInt()}',
                              style: TextStyle(
                                fontSize: 13,
                                color: store.deliveryFee == 0 ? AjioTheme.successGreen : AjioTheme.darkSlate,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: AjioTheme.borderGrey),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Payable',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                            ),
                            Text(
                              '₹${store.cartTotalPayable.toInt()}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Prevention overlap
                ],
              ),
            ),
      bottomSheet: cart.isEmpty
          ? null
          : Container(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₹${store.cartTotalPayable.toInt()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AjioTheme.darkSlate,
                          ),
                        ),
                        const Text(
                          'View detailed breakdown',
                          style: TextStyle(fontSize: 10, color: AjioTheme.ajioGold, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!store.isLoggedIn) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                onLoginSuccess: () {
                                  _triggerCheckoutDialog(context);
                                },
                              ),
                            ),
                          );
                        } else {
                          _triggerCheckoutDialog(context);
                        }
                      },
                      child: const Text('PLACE ORDER'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
