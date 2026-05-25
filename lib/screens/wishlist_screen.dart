import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../models/product.dart';
import '../theme/ajio_theme.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  void _showSizeSelectorAndMove(BuildContext context, Product product) {
    String? selectedSize;
    final store = Provider.of<StoreProvider>(context, listen: false);

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
                        'CHOOSE SIZE TO BAG',
                        style: TextStyle(
                          fontSize: 15,
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
                    children: product.sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setStateSheet(() {
                            selectedSize = size;
                          });
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedSize == null
                          ? null
                          : () {
                              store.addToCart(product, selectedSize!);
                              store.toggleWishlist(product); // Remove from wishlist
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Moved ${product.brand} (Size $selectedSize) to Bag!',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  backgroundColor: AjioTheme.successGreen,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                      child: const Text('CONFIRM AND MOVE'),
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

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final savedItems = store.wishlist;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'W I S H L I S T',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            color: AjioTheme.darkSlate,
          ),
        ),
      ),
      body: savedItems.isEmpty
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
                        Icons.favorite_outline_rounded,
                        size: 64,
                        color: AjioTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'YOUR WISHLIST IS EMPTY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AjioTheme.darkSlate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore our hottest fashion brands and save your top choices here!',
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
                          store.setTabIndex(0); // Switch to Home
                        },
                        child: const Text('CONTINUE SHOPPING'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.50, // Modified ratio to accommodate the "Move to Bag" button below
              ),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final product = savedItems[index];
                return Column(
                  children: [
                    Expanded(
                      child: ProductCard(product: product),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () => _showSizeSelectorAndMove(context, product),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: AjioTheme.darkSlate, width: 1.0),
                        ),
                        child: const Text(
                          'MOVE TO BAG',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
