import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final CartProvider cart;
  final WishlistProvider wishlist;

  const ProductDetailScreen({super.key, required this.product, required this.cart, required this.wishlist});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  final Map<String, String> selectedVariants = {};

  @override
  void initState() {
    super.initState();
    for (final entry in widget.product.variants.entries) {
      if (entry.value.isNotEmpty) selectedVariants[entry.key] = entry.value.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isWishlisted = widget.wishlist.isWishlisted(p.id);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, color: isWishlisted ? AppTheme.accentColor : null),
            onPressed: () => setState(() => widget.wishlist.toggle(p.id)),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Image
          Container(
            height: 300, color: AppTheme.backgroundColor,
            child: Center(child: Text(p.category == 'electronics' ? '📱' : p.category == 'clothing' ? '👕' : '📦', style: const TextStyle(fontSize: 80))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star, size: 18, color: AppTheme.starColor),
                  const SizedBox(width: 4),
                  Text('${p.rating} (${p.reviewCount} reviews)', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Text('\$${p.effectivePrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                  if (p.isOnSale) ...[
                    const SizedBox(width: 8),
                    Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: AppTheme.textMuted, decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('Save ${p.discountPercent.toStringAsFixed(0)}%', style: const TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ]),
                const SizedBox(height: 16),
                Text(p.description, style: const TextStyle(fontSize: 15, color: AppTheme.textSecondary, height: 1.5)),
                // Variants
                ...p.variants.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key.substring(0, 1).toUpperCase() + entry.key.substring(1), style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: entry.value.map((v) => ChoiceChip(
                        label: Text(v),
                        selected: selectedVariants[entry.key] == v,
                        onSelected: (_) => setState(() => selectedVariants[entry.key] = v),
                      )).toList()),
                    ],
                  ),
                )),
                // Quantity
                const SizedBox(height: 20),
                Row(children: [
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.borderColor), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: quantity > 1 ? () => setState(() => quantity--) : null),
                      Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      IconButton(icon: const Icon(Icons.add, size: 18), onPressed: () => setState(() => quantity++)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              widget.cart.addItem(p, quantity: quantity, variants: Map.from(selectedVariants));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} added to cart'), action: SnackBarAction(label: 'VIEW CART', onPressed: () => Navigator.pop(context))));
            },
            child: Text('Add to Cart — \$${(p.effectivePrice * quantity).toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}
