import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onWishlist;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onWishlist,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    color: AppTheme.backgroundColor,
                    child: Center(
                      child: Text(
                        product.category == 'electronics' ? '📱' :
                        product.category == 'clothing' ? '👕' :
                        product.category == 'sports' ? '⚽' :
                        product.category == 'books' ? '📚' :
                        product.category == 'beauty' ? '💄' : '🏠',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  if (product.isOnSale)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(6)),
                        child: Text('-${product.discountPercent.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  if (onWishlist != null)
                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: onWishlist,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                          child: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, size: 20, color: isWishlisted ? AppTheme.accentColor : AppTheme.textMuted),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppTheme.starColor),
                      const SizedBox(width: 2),
                      Text('${product.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(' (${product.reviewCount})', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$${product.effectivePrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 6),
                        Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, decoration: TextDecoration.lineThrough)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
