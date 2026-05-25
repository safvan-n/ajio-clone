import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../data/dummy_data.dart';
import '../theme/ajio_theme.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _activeBannerIndex = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    // Auto-scroll the banner slider every 4 seconds for a premium live-app feel!
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _activeBannerIndex + 1;
        if (nextPage >= DummyData.carouselBanners.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final trendingProducts = store.products.where((p) => p.isTrending).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'A J I O',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'serif',
            fontWeight: FontWeight.w900,
            letterSpacing: 6.0,
            color: AjioTheme.darkSlate,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          child: const Icon(Icons.menu, color: AjioTheme.darkSlate),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AjioTheme.darkSlate),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications. Check back for sales!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AjioTheme.darkSlate),
            onPressed: () => store.setTabIndex(2), // Switches to Wishlist!
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Search Bar - Tapping redirects to search tab
            GestureDetector(
              onTap: () {
                store.setTabIndex(1);
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AjioTheme.lightGrey,
                  border: Border.all(color: AjioTheme.borderGrey),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: AjioTheme.textGrey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Search by Brand, Product, Category...',
                      style: TextStyle(color: AjioTheme.textGrey, fontSize: 13),
                    ),
                    Spacer(),
                    Icon(Icons.camera_alt_outlined, color: AjioTheme.textGrey, size: 20),
                  ],
                ),
              ),
            ),

            // Horizontal Categories list
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: DummyData.categories.length,
                itemBuilder: (context, index) {
                  final cat = DummyData.categories[index];
                  return GestureDetector(
                    onTap: () {
                      store.resetFilters();
                      store.setCategory(cat['title']);
                      store.setTabIndex(1); // Jump to Explore
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 18),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AjioTheme.ajioGold, width: 1.5),
                              image: DecorationImage(
                                image: NetworkImage(cat['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['title']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AjioTheme.darkSlate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Promo banner Carousel Slider
            Stack(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: DummyData.carouselBanners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _activeBannerIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Standard banner promotional filter
                          store.resetFilters();
                          store.setTabIndex(1);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.zero,
                            child: Image.network(
                              DummyData.carouselBanners[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AjioTheme.lightGrey,
                                child: const Icon(Icons.image, size: 48),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Indicator dots overlay
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      DummyData.carouselBanners.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _activeBannerIndex == index ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: _activeBannerIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Visual header for BIG BOLD SALE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              color: Colors.white,
              child: const Column(
                children: [
                  Text(
                    'THE BIG BOLD SALE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.0,
                      color: AjioTheme.discountRed,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '50% - 90% OFF ON FASHION BRAND FAVORITES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AjioTheme.ajioGold,
                    ),
                  ),
                ],
              ),
            ),

            // Big Bold Sale Grid (2x2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: DummyData.saleGrids.length,
                itemBuilder: (context, index) {
                  final sale = DummyData.saleGrids[index];
                  return GestureDetector(
                    onTap: () {
                      store.resetFilters();
                      if (sale['title'] == 'ETHNIC WEAR') {
                        store.setCategory('Indie');
                      } else if (sale['title'] == 'CASUAL SHIRTS') {
                        store.setCategory('Men');
                      } else if (sale['title'] == 'SPORTSWEAR') {
                        store.setCategory('Footwear');
                      } else if (sale['title'] == 'BAGS & MORE') {
                        store.setCategory('Accessories');
                      }
                      store.setTabIndex(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(sale['color'] as int),
                        border: Border.all(color: AjioTheme.ajioGold.withOpacity(0.6), width: 1.5),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.65,
                              child: Image.network(
                                sale['image'] as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  sale['title'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  sale['offer'] as String,
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  sale['tagline'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Top Brands Row
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'SHOP BY BRAND',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AjioTheme.darkSlate,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 54,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: DummyData.topBrands.length,
                itemBuilder: (context, index) {
                  final brand = DummyData.topBrands[index];
                  return GestureDetector(
                    onTap: () {
                      store.resetFilters();
                      store.setBrand(brand);
                      store.setTabIndex(1);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AjioTheme.darkSlate, width: 1.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        brand.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: AjioTheme.darkSlate,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Trending / Catalog Segment
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HOT ON TREND',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AjioTheme.darkSlate,
                    ),
                  ),
                  Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AjioTheme.ajioGold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Product Grid list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.58,
                ),
                itemCount: trendingProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: trendingProducts[index]);
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
