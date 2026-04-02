import '../models/models.dart';

class MockDataService {
  static const categories = [
    Category(id: 'electronics', name: 'Electronics', icon: '📱', productCount: 12),
    Category(id: 'clothing', name: 'Clothing', icon: '👕', productCount: 18),
    Category(id: 'home', name: 'Home & Garden', icon: '🏠', productCount: 9),
    Category(id: 'sports', name: 'Sports', icon: '⚽', productCount: 7),
    Category(id: 'books', name: 'Books', icon: '📚', productCount: 15),
    Category(id: 'beauty', name: 'Beauty', icon: '💄', productCount: 11),
  ];

  static const products = [
    Product(id: 'p1', name: 'Wireless Noise-Cancelling Headphones', description: 'Premium over-ear headphones with 30-hour battery life, active noise cancellation, and Hi-Res Audio support. Comfortable memory foam ear cushions for all-day wear.', price: 349.99, salePrice: 279.99, imageUrl: 'headphones.jpg', category: 'electronics', rating: 4.7, reviewCount: 2341, variants: {'color': ['Black', 'Silver', 'Navy']}, tags: ['bestseller', 'wireless']),
    Product(id: 'p2', name: 'Ultra-Slim Laptop Stand', description: 'Ergonomic aluminum laptop stand with adjustable height. Compatible with all laptops 10-17 inches. Improves posture and airflow.', price: 59.99, imageUrl: 'stand.jpg', category: 'electronics', rating: 4.5, reviewCount: 892, tags: ['ergonomic']),
    Product(id: 'p3', name: 'Organic Cotton T-Shirt', description: '100% organic cotton crew neck t-shirt. Pre-shrunk, sustainably sourced. Available in 8 colors.', price: 34.99, imageUrl: 'tshirt.jpg', category: 'clothing', rating: 4.3, reviewCount: 1567, variants: {'size': ['XS', 'S', 'M', 'L', 'XL'], 'color': ['White', 'Black', 'Navy', 'Gray', 'Olive', 'Burgundy', 'Sage', 'Cream']}, tags: ['organic', 'sustainable']),
    Product(id: 'p4', name: 'Smart Home Hub', description: 'Central hub for controlling all your smart home devices. Works with Alexa, Google Home, and HomeKit. Wi-Fi 6 and Zigbee support.', price: 129.99, salePrice: 99.99, imageUrl: 'hub.jpg', category: 'electronics', rating: 4.4, reviewCount: 678, tags: ['smart-home']),
    Product(id: 'p5', name: 'Premium Yoga Mat', description: 'Extra thick 6mm non-slip yoga mat with alignment lines. Made from eco-friendly TPE material. Includes carrying strap.', price: 49.99, imageUrl: 'yoga.jpg', category: 'sports', rating: 4.8, reviewCount: 3210, variants: {'color': ['Purple', 'Teal', 'Black', 'Pink']}, tags: ['eco-friendly', 'bestseller']),
    Product(id: 'p6', name: 'Minimalist Desk Lamp', description: 'LED desk lamp with 5 color temperatures, 10 brightness levels, and USB charging port. Touch control with memory function.', price: 79.99, imageUrl: 'lamp.jpg', category: 'home', rating: 4.6, reviewCount: 445, variants: {'color': ['White', 'Black', 'Rose Gold']}, tags: ['led', 'usb-charging']),
    Product(id: 'p7', name: 'Running Shoes Pro', description: 'Lightweight performance running shoes with responsive cushioning and breathable mesh upper. Carbon fiber plate for energy return.', price: 179.99, salePrice: 149.99, imageUrl: 'shoes.jpg', category: 'sports', rating: 4.6, reviewCount: 1890, variants: {'size': ['7', '8', '9', '10', '11', '12'], 'color': ['Black/White', 'Blue/Orange', 'Gray/Lime']}, tags: ['performance']),
    Product(id: 'p8', name: 'The Design of Everyday Things', description: 'Revised and expanded edition of the classic book on user-centered design by Don Norman.', price: 18.99, imageUrl: 'book.jpg', category: 'books', rating: 4.7, reviewCount: 4521),
    Product(id: 'p9', name: 'Ceramic Pour-Over Coffee Set', description: 'Handcrafted ceramic dripper with thermal carafe and 40 paper filters. Brews 2-4 cups of clean, flavorful coffee.', price: 64.99, imageUrl: 'coffee.jpg', category: 'home', rating: 4.5, reviewCount: 312, variants: {'color': ['White', 'Matte Black', 'Speckled']}, tags: ['handcrafted']),
    Product(id: 'p10', name: 'Vitamin C Serum', description: '20% Vitamin C serum with hyaluronic acid and vitamin E. Brightens skin, reduces dark spots, and boosts collagen production.', price: 28.99, imageUrl: 'serum.jpg', category: 'beauty', rating: 4.4, reviewCount: 2100, tags: ['skincare', 'bestseller']),
    Product(id: 'p11', name: 'Mechanical Keyboard', description: 'Compact 75% layout mechanical keyboard with hot-swappable switches, RGB backlighting, and PBT keycaps. USB-C connection.', price: 129.99, imageUrl: 'keyboard.jpg', category: 'electronics', rating: 4.8, reviewCount: 1456, variants: {'switch': ['Red', 'Blue', 'Brown']}, tags: ['mechanical', 'rgb']),
    Product(id: 'p12', name: 'Linen Blend Blazer', description: 'Unstructured linen-cotton blend blazer. Perfect for smart-casual occasions. Breathable and wrinkle-resistant.', price: 149.99, salePrice: 119.99, imageUrl: 'blazer.jpg', category: 'clothing', rating: 4.2, reviewCount: 234, variants: {'size': ['S', 'M', 'L', 'XL'], 'color': ['Navy', 'Tan', 'Light Gray']}, tags: ['linen', 'smart-casual']),
  ];

  static List<Product> filterProducts(ProductFilter filter) {
    var filtered = [...products];

    if (filter.category != null) {
      filtered = filtered.where((p) => p.category == filter.category).toList();
    }
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final q = filter.searchQuery!.toLowerCase();
      filtered = filtered.where((p) => p.name.toLowerCase().contains(q) || p.description.toLowerCase().contains(q) || p.category.toLowerCase().contains(q)).toList();
    }
    if (filter.minPrice != null) {
      filtered = filtered.where((p) => p.effectivePrice >= filter.minPrice!).toList();
    }
    if (filter.maxPrice != null) {
      filtered = filtered.where((p) => p.effectivePrice <= filter.maxPrice!).toList();
    }
    if (filter.minRating != null) {
      filtered = filtered.where((p) => p.rating >= filter.minRating!).toList();
    }
    if (filter.inStockOnly == true) {
      filtered = filtered.where((p) => p.inStock).toList();
    }

    switch (filter.sortBy) {
      case 'price_asc': filtered.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice)); break;
      case 'price_desc': filtered.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice)); break;
      case 'rating': filtered.sort((a, b) => b.rating.compareTo(a.rating)); break;
    }

    return filtered;
  }
}
