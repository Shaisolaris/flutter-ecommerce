import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'models/models.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const ShopKitApp());
}

class ShopKitApp extends StatefulWidget {
  const ShopKitApp({super.key});

  @override
  State<ShopKitApp> createState() => _ShopKitAppState();
}

class _ShopKitAppState extends State<ShopKitApp> {
  final _cart = CartProvider();
  final _wishlist = WishlistProvider();

  @override
  void initState() {
    super.initState();
    _cart.addListener(() => setState(() {}));
    _wishlist.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopKit',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        cart: _cart,
        wishlist: _wishlist,
        onProductTap: (product) => _pushProductDetail(context, product),
        onCartTap: () => _pushCart(context),
        onCategoryTap: (category) => _pushSearch(context, category: category),
        onSearchTap: () => _pushSearch(context),
      ),
    );
  }

  void _pushProductDetail(BuildContext context, Product product) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProductDetailScreen(product: product, cart: _cart, wishlist: _wishlist),
    ));
  }

  void _pushCart(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CartScreen(
        cart: _cart,
        onCheckout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checkout — Stripe integration ready')),
          );
        },
      ),
    ));
  }

  void _pushSearch(BuildContext context, {String? category}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SearchScreen(
        onProductTap: (product) => _pushProductDetail(context, product),
        wishlist: _wishlist,
        initialCategory: category,
      ),
    ));
  }

  @override
  void dispose() {
    _cart.dispose();
    _wishlist.dispose();
    super.dispose();
  }
}
