import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/ajio_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showMockDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          content: Text(body, style: const TextStyle(fontSize: 13, color: AjioTheme.darkSlate)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE', style: TextStyle(color: AjioTheme.ajioGold, fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: AjioTheme.lightGrey,
          child: Icon(icon, color: AjioTheme.ajioGold, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate, letterSpacing: 0.5),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AjioTheme.textGrey, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final orders = store.placedOrders;

    // --- GUEST VIEW (NOT LOGGED IN) ---
    if (!store.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'M Y  A C C O U N T',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: AjioTheme.darkSlate,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Golden-black elegant welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF907028)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'AJIO VIP COUTURE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'TAILORED EXCLUSIVELY FOR YOU',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'SIGN IN TO EXPERIENCE AJIO VIP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: AjioTheme.darkSlate,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your luxury fashion orders, apply premium promotional coupons, check loyalty wallet balances, and configure saved addresses.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, height: 1.5, color: AjioTheme.textGrey),
              ),
              const SizedBox(height: 32),
              
              // Sign In / Register Button
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('SIGN IN / REGISTER'),
                ),
              ),
              
              const SizedBox(height: 48),
              const Divider(color: AjioTheme.borderGrey),
              const SizedBox(height: 24),
              
              // Key customer loyalty benefits
              _buildBenefitRow(Icons.wallet_giftcard_outlined, 'Instant Cashback', 'Earn flat ₹1,500 mock wallet cashback instantly upon sign-up.'),
              const SizedBox(height: 16),
              _buildBenefitRow(Icons.local_shipping_outlined, 'VIP Priority Shipping', 'Get express standard 48-hour delivery on premium high-street fashion.'),
              const SizedBox(height: 16),
              _buildBenefitRow(Icons.cached_outlined, 'Hassle-Free returns', 'Enjoy a worry-free, easy 15-day home pickup return policy.'),
            ],
          ),
        ),
      );
    }

    // --- AUTHENTICATED VIEW (LOGGED IN) ---
    final avatarLetter = store.currentUserName.isNotEmpty ? store.currentUserName[0].toUpperCase() : 'U';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'M Y  A C C O U N T',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: AjioTheme.darkSlate,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Personalized Header Card
            Container(
              padding: const EdgeInsets.all(20),
              color: AjioTheme.lightGrey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: AjioTheme.darkSlate,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          avatarLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.currentUserName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AjioTheme.darkSlate,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            store.currentUserEmail,
                            style: const TextStyle(fontSize: 12, color: AjioTheme.textGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // AJIO VIP club mockup card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1E293B),
                          Color(0xFF0F172A),
                          Color(0xFF907028),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AJIO VIP CLUB',
                              style: TextStyle(
                                color: Colors.amber.shade200,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const Icon(Icons.stars, color: Colors.amber, size: 20),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Available VIP points',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                        const Text(
                          '4,850 PTS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order History Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MY ORDERS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AjioTheme.darkSlate,
                    ),
                  ),
                  Text(
                    '${orders.length} ORDERS',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AjioTheme.textGrey),
                  ),
                ],
              ),
            ),

            // Orders list container
            if (orders.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AjioTheme.borderGrey),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: AjioTheme.textGrey, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'No placed orders yet',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                    ),
                    Text(
                      'Items you purchase will be logged here.',
                      style: TextStyle(fontSize: 11, color: AjioTheme.textGrey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final items = order['items'] as List;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AjioTheme.borderGrey, width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AjioTheme.lightGrey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['id'] as String,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
                                  ),
                                  Text(
                                    'Placed on: ${(order['date'] as DateTime).toString().substring(0, 10)}',
                                    style: const TextStyle(fontSize: 9, color: AjioTheme.textGrey),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                color: Colors.blue.shade50,
                                child: Text(
                                  order['status'] as String,
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Item Thumbnails
                        Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              final item = items[i];
                              return Container(
                                width: 45,
                                margin: const EdgeInsets.only(right: 8),
                                child: Image.network(
                                  item['image'] as String,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),

                        const Divider(height: 1, color: AjioTheme.borderGrey),

                        // Pricing and Delivery
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${items.length} ${items.length == 1 ? 'item' : 'items'}  •  Paid ₹${(order['totalPaid'] as double).toInt()}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Delivery: ${(order['estimatedDelivery'] as DateTime).toString().substring(0, 10)}',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const Divider(height: 32, color: AjioTheme.borderGrey),

            // Profile Menus List
            _buildProfileTile(
              context,
              Icons.wallet_giftcard_outlined,
              'AJIO Wallet Balance',
              '₹1,500 Cash available',
              () => _showMockDialog(context, 'AJIO WALLET', 'Your wallet has ₹1,500 in cashback balances ready to be applied on checkout!'),
            ),
            _buildProfileTile(
              context,
              Icons.home_work_outlined,
              'Saved Addresses',
              'Manage your home and work delivery locations',
              () => _showMockDialog(context, 'DELIVERY ADDRESS', 'Primary: Flat 405, Safwan Heights, Bengaluru, KA, 560001.'),
            ),
            _buildProfileTile(
              context,
              Icons.headset_mic_outlined,
              'Customer Support',
              'Talk to customer executives or browse FAQs',
              () => _showMockDialog(context, 'HELP DESK', 'Call us at 1800-889-9999 or email care@ajio.com (Open 24/7).'),
            ),
            _buildProfileTile(
              context,
              Icons.info_outline,
              'About AJIO',
              'Licensing, Terms, and Privacy Policies',
              () => _showMockDialog(context, 'ABOUT PLATFORM', 'AJIO Clone App v1.0.0. Powered by Reliance Fashion Retailers.'),
            ),
            _buildProfileTile(
              context,
              Icons.logout_outlined,
              'Logout Account',
              'Sign out from this device',
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    title: const Text('LOGOUT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to sign out from your AJIO VIP account?', style: TextStyle(fontSize: 13)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL', style: TextStyle(color: AjioTheme.textGrey, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          store.logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully logged out!'),
                              backgroundColor: AjioTheme.darkSlate,
                            ),
                          );
                        },
                        child: const Text('LOGOUT', style: TextStyle(color: AjioTheme.discountRed, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AjioTheme.borderGrey)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AjioTheme.darkSlate),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: AjioTheme.textGrey),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18, color: AjioTheme.textGrey),
      ),
    );
  }
}
