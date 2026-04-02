import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get shipping => subtotal > 50 ? 0 : 5.99;
  double get tax => subtotal * 0.0875;
  double get total => subtotal + shipping + tax;
  bool get isEmpty => _items.isEmpty;

  void addItem(Product product, {int quantity = 1, Map<String, String> variants = const {}}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id && _mapEquals(item.selectedVariants, variants));

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(quantity: _items[existingIndex].quantity + quantity);
    } else {
      _items.add(CartItem(product: product, quantity: quantity, selectedVariants: variants));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) { removeItem(productId); return; }
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}

class WishlistProvider extends ChangeNotifier {
  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);
  bool isWishlisted(String productId) => _ids.contains(productId);

  void toggle(String productId) {
    if (_ids.contains(productId)) {
      _ids.remove(productId);
    } else {
      _ids.add(productId);
    }
    notifyListeners();
  }
}
