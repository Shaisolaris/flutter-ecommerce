import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  final CartProvider cart;
  final VoidCallback onCheckout;

  const CartScreen({super.key, required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🛒', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Add items to get started', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Browse Products')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.itemCount})'),
        actions: [
          TextButton(onPressed: cart.clear, child: const Text('Clear', style: TextStyle(color: AppTheme.accentColor))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...cart.items.map((item) => CartItemWidget(
            item: item,
            onQuantityChanged: (q) => cart.updateQuantity(item.product.id, q),
            onRemove: () => cart.removeItem(item.product.id),
          )),
          const Divider(height: 32),
          _summaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          _summaryRow('Shipping', cart.shipping == 0 ? 'Free' : '\$${cart.shipping.toStringAsFixed(2)}'),
          _summaryRow('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Text('\$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          if (cart.subtotal < 50) ...[
            const SizedBox(height: 8),
            Text('Add \$${(50 - cart.subtotal).toStringAsFixed(2)} more for free shipping!', style: const TextStyle(fontSize: 13, color: AppTheme.successColor, fontWeight: FontWeight.w500)),
          ],
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: onCheckout,
            child: Text('Checkout — \$${cart.total.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
