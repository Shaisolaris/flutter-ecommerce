// ─── Product ────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final Map<String, List<String>> variants; // e.g., {'size': ['S','M','L'], 'color': ['Red','Blue']}
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.imageUrl,
    this.images = const [],
    required this.category,
    this.rating = 0,
    this.reviewCount = 0,
    this.inStock = true,
    this.variants = const {},
    this.tags = const [],
  });

  bool get isOnSale => salePrice != null && salePrice! < price;
  double get effectivePrice => salePrice ?? price;
  double get discountPercent => isOnSale ? ((price - salePrice!) / price * 100) : 0;
}

// ─── Cart ────────────────────────────────────────────────

class CartItem {
  final Product product;
  final int quantity;
  final Map<String, String> selectedVariants;

  const CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedVariants = const {},
  });

  double get totalPrice => product.effectivePrice * quantity;

  CartItem copyWith({int? quantity, Map<String, String>? selectedVariants}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedVariants: selectedVariants ?? this.selectedVariants,
    );
  }
}

// ─── Order ──────────────────────────────────────────────

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String status; // placed, confirmed, shipped, delivered
  final String shippingAddress;
  final DateTime createdAt;
  final String? trackingNumber;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
    this.trackingNumber,
  });
}

// ─── Category ───────────────────────────────────────────

class Category {
  final String id;
  final String name;
  final String icon;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.productCount = 0,
  });
}

// ─── Filter ─────────────────────────────────────────────

class ProductFilter {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? inStockOnly;
  final String? sortBy; // price_asc, price_desc, rating, newest
  final String? searchQuery;

  const ProductFilter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly,
    this.sortBy,
    this.searchQuery,
  });

  ProductFilter copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    String? sortBy,
    String? searchQuery,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ─── Address ────────────────────────────────────────────

class ShippingAddress {
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final bool isDefault;

  const ShippingAddress({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.country = 'US',
    this.isDefault = false,
  });

  String get formatted => '$street, $city, $state $zip';
}
