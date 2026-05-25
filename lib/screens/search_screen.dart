import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/ajio_theme.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _popularTags = [
    'Jacket',
    'Kurta',
    'Sneakers',
    'GAP',
    'Nike',
    'Dress',
    'Tee',
    'Saree'
  ];

  @override
  void initState() {
    super.initState();
    // Synchronize text controller with provider search query
    final store = Provider.of<StoreProvider>(context, listen: false);
    _searchController.text = store.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortSheet() {
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      'SORT BY',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AjioTheme.darkSlate,
                      ),
                    ),
                  ),
                  const Divider(color: AjioTheme.borderGrey),
                  ...['Relevance', 'Price: Low to High', 'Price: High to Low', 'Rating', 'Discount'].map((sortOption) {
                    final isSelected = store.sortBy == sortOption;
                    return ListTile(
                      onTap: () {
                        store.setSortBy(sortOption);
                        Navigator.pop(context);
                      },
                      leading: Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AjioTheme.ajioGold : AjioTheme.textGrey,
                      ),
                      title: Text(
                        sortOption,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: AjioTheme.darkSlate,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterSheet() {
    final store = Provider.of<StoreProvider>(context, listen: false);
    double localMinPrice = store.minPrice;
    double localMaxPrice = store.maxPrice;
    String? localBrand = store.selectedBrand;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FILTERS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AjioTheme.darkSlate,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateSheet(() {
                            localMinPrice = 0;
                            localMaxPrice = 15000;
                            localBrand = null;
                          });
                        },
                        child: const Text(
                          'RESET ALL',
                          style: TextStyle(color: AjioTheme.discountRed, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AjioTheme.borderGrey),
                  const SizedBox(height: 12),

                  // Price range section
                  Text(
                    'PRICE RANGE (₹${localMinPrice.toInt()} - ₹${localMaxPrice.toInt()})',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                  ),
                  RangeSlider(
                    values: RangeValues(localMinPrice, localMaxPrice),
                    min: 0,
                    max: 15000,
                    divisions: 30,
                    activeColor: AjioTheme.darkSlate,
                    inactiveColor: AjioTheme.lightGrey,
                    labels: RangeLabels(
                      '₹${localMinPrice.toInt()}',
                      '₹${localMaxPrice.toInt()}',
                    ),
                    onChanged: (RangeValues values) {
                      setStateSheet(() {
                        localMinPrice = values.start;
                        localMaxPrice = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Brands section
                  const Text(
                    'SELECT BRAND',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Nike', 'Adidas', 'Zara', 'GAP', 'Superdry', 'Levis', 'BIBA', 'Puma'].map((b) {
                      final isSelected = localBrand?.toLowerCase() == b.toLowerCase();
                      return ChoiceChip(
                        label: Text(
                          b,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AjioTheme.darkSlate,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AjioTheme.darkSlate,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        onSelected: (bool selected) {
                          setStateSheet(() {
                            localBrand = selected ? b : null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('CANCEL'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            store.setPriceRange(localMinPrice, localMaxPrice);
                            store.setBrand(localBrand);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('APPLY FILTERS'),
                        ),
                      ),
                    ],
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
    final results = store.filteredProducts;

    final categoriesList = ['All', 'Men', 'Women', 'Kids', 'Footwear', 'Indie', 'Accessories'];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  onChanged: (val) {
                    store.setSearchQuery(val);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search clothes, footwear, accessories...',
                    prefixIcon: Icon(Icons.search, color: AjioTheme.textGrey),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: AjioTheme.darkSlate),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                    store.setSearchQuery('');
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Capsule Categories horizontal selector
          Container(
            height: 48,
            margin: const EdgeInsets.only(top: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                final cat = categoriesList[index];
                final isSelected = (cat == 'All' && store.selectedCategory == null) ||
                    (store.selectedCategory != null &&
                        store.selectedCategory!.toLowerCase() == cat.toLowerCase());

                return GestureDetector(
                  onTap: () {
                    if (cat == 'All') {
                      store.setCategory(null);
                    } else {
                      store.setCategory(cat);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AjioTheme.darkSlate : AjioTheme.lightGrey,
                      border: Border.all(
                        color: isSelected ? AjioTheme.darkSlate : AjioTheme.borderGrey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: isSelected ? Colors.white : AjioTheme.darkSlate,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Sorting & Filter bar row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AjioTheme.borderGrey),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _showSortSheet,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sort, size: 16, color: AjioTheme.darkSlate),
                        const SizedBox(width: 6),
                        Text(
                          'SORT: ${store.sortBy.toUpperCase()}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AjioTheme.borderGrey,
                ),
                Expanded(
                  child: InkWell(
                    onTap: _showFilterSheet,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          size: 16,
                          color: (store.selectedBrand != null || store.minPrice > 0 || store.maxPrice < 15000)
                              ? AjioTheme.ajioGold
                              : AjioTheme.darkSlate,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'FILTERS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: (store.selectedBrand != null || store.minPrice > 0 || store.maxPrice < 15000)
                                ? AjioTheme.ajioGold
                                : AjioTheme.darkSlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Suggestions if search bar is empty and no catalog results yet
          if (store.searchQuery.isEmpty &&
              store.selectedCategory == null &&
              store.selectedBrand == null &&
              store.minPrice == 0 &&
              store.maxPrice == 15000)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POPULAR SEARCHES',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AjioTheme.darkSlate,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: _popularTags.map((tag) {
                          return GestureDetector(
                            onTap: () {
                              _searchController.text = tag;
                              store.setSearchQuery(tag);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AjioTheme.borderGrey),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(fontSize: 12, color: AjioTheme.darkSlate),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      // Aesthetic visual card
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AjioTheme.lightGrey,
                          border: Border.all(color: AjioTheme.borderGrey),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.3,
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600&q=80',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'THE AJIO LOOKBOOK',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                      color: AjioTheme.darkSlate,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Discover premium collections custom curated for you',
                                    style: TextStyle(fontSize: 10, color: AjioTheme.textGrey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // Main grid of products
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: AjioTheme.textGrey),
                            const SizedBox(height: 16),
                            const Text(
                              'NO PRODUCTS FOUND',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try adjusting your search filters or browse other sections.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AjioTheme.textGrey, fontSize: 13),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                onPressed: () {
                                  store.resetFilters();
                                  _searchController.clear();
                                },
                                child: const Text('RESET ALL'),
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
                        childAspectRatio: 0.58,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: results[index]);
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
