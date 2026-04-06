import '../data/demo_data.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../theme/app_theme.dart';

// Demo products loaded from demo_data.dart
final _products = DemoProducts.products;
final _categories = DemoProducts.categories;

class HomeScreen extends StatelessWidget {
  final CartProvider cart;
  final WishlistProvider wishlist;
  final void Function(Product) onProductTap;
  final VoidCallback onCartTap;
  final void Function(String) onCategoryTap;
  final VoidCallback onSearchTap;

  const HomeScreen({
    super.key,
    required this.cart,
    required this.wishlist,
    required this.onProductTap,
    required this.onCartTap,
    required this.onCategoryTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final featured = MockDataService.products.where((p) => p.isOnSale).toList();
    final bestsellers = MockDataService.products.where((p) => p.tags.contains('bestseller')).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopKit', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: onSearchTap),
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: onCartTap),
              if (cart.itemCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                    child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.primaryColor, Color(0xFF16213E)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Spring Sale', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Up to 30% off selected items', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),

          // Categories
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockDataService.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final cat = MockDataService.categories[i];
                return GestureDetector(
                  onTap: () => onCategoryTap(cat.id),
                  child: Column(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderColor)),
                        child: Center(child: Text(cat.icon, style: const TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(height: 6),
                      Text(cat.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              },
            ),
          ),

          // On Sale
          if (featured.isNotEmpty) ...[
            const SizedBox(height: 24),
            _sectionHeader('On Sale 🔥'),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(
                  width: 180,
                  child: ProductCard(
                    product: featured[i],
                    onTap: () => onProductTap(featured[i]),
                    onWishlist: () => wishlist.toggle(featured[i].id),
                    isWishlisted: wishlist.isWishlisted(featured[i].id),
                  ),
                ),
              ),
            ),
          ],

          // Bestsellers grid
          const SizedBox(height: 24),
          _sectionHeader('Bestsellers'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: bestsellers.length,
              itemBuilder: (_, i) => ProductCard(
                product: bestsellers[i],
                onTap: () => onProductTap(bestsellers[i]),
                onWishlist: () => wishlist.toggle(bestsellers[i].id),
                isWishlisted: wishlist.isWishlisted(bestsellers[i].id),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        TextButton(onPressed: () {}, child: const Text('See All')),
      ],
    ),
  );
}
