/// Demo data for the e-commerce app — renders immediately with no backend.
class DemoProducts {
  static final List<Map<String, dynamic>> products = [
    {'id': '1', 'name': 'Wireless Headphones', 'price': 79.99, 'category': 'Electronics', 'rating': 4.7, 'reviews': 234, 'inStock': true},
    {'id': '2', 'name': 'Leather Backpack', 'price': 129.99, 'category': 'Accessories', 'rating': 4.8, 'reviews': 156, 'inStock': true},
    {'id': '3', 'name': 'Smart Watch', 'price': 249.99, 'category': 'Electronics', 'rating': 4.5, 'reviews': 89, 'inStock': true},
    {'id': '4', 'name': 'Running Shoes', 'price': 119.99, 'category': 'Sports', 'rating': 4.6, 'reviews': 312, 'inStock': true},
    {'id': '5', 'name': 'Coffee Maker', 'price': 89.99, 'category': 'Home', 'rating': 4.9, 'reviews': 445, 'inStock': false},
    {'id': '6', 'name': 'Yoga Mat', 'price': 39.99, 'category': 'Sports', 'rating': 4.4, 'reviews': 67, 'inStock': true},
  ];
  static final List<String> categories = ['All', 'Electronics', 'Accessories', 'Sports', 'Home'];
  static final Map<String, dynamic> cart = {'items': [], 'subtotal': 0.0, 'shipping': 5.99, 'total': 5.99};
}
