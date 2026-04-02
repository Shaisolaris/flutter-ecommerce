import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data.dart';
import '../widgets/product_card.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  final void Function(Product) onProductTap;
  final WishlistProvider wishlist;
  final String? initialCategory;

  const SearchScreen({super.key, required this.onProductTap, required this.wishlist, this.initialCategory});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  ProductFilter _filter = const ProductFilter();
  List<Product> _results = [];
  String _sortLabel = 'Relevance';

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _filter = _filter.copyWith(category: widget.initialCategory);
    }
    _search();
  }

  void _search() {
    setState(() {
      _filter = _filter.copyWith(searchQuery: _searchController.text);
      _results = MockDataService.filterProducts(_filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(hintText: 'Search products...', border: InputBorder.none, filled: false),
          onChanged: (_) => _search(),
          autofocus: widget.initialCategory == null,
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(label: _sortLabel, icon: Icons.sort, onTap: _showSortSheet),
                ...MockDataService.categories.map((cat) => _FilterChip(
                  label: cat.name,
                  selected: _filter.category == cat.id,
                  onTap: () => setState(() { _filter = _filter.copyWith(category: _filter.category == cat.id ? null : cat.id); _search(); }),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('${_results.length} results', style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          ),
          Expanded(
            child: _results.isEmpty
              ? const Center(child: Text('No products found', style: TextStyle(color: AppTheme.textMuted)))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: _results.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: _results[i],
                    onTap: () => widget.onProductTap(_results[i]),
                    onWishlist: () => setState(() => widget.wishlist.toggle(_results[i].id)),
                    isWishlisted: widget.wishlist.isWishlisted(_results[i].id),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(context: context, builder: (_) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(padding: EdgeInsets.all(16), child: Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        for (final opt in [('Relevance', null), ('Price: Low to High', 'price_asc'), ('Price: High to Low', 'price_desc'), ('Highest Rated', 'rating')])
          ListTile(
            title: Text(opt.$1),
            trailing: _filter.sortBy == opt.$2 ? const Icon(Icons.check, color: AppTheme.accentColor) : null,
            onTap: () { setState(() { _filter = _filter.copyWith(sortBy: opt.$2); _sortLabel = opt.$1; _search(); }); Navigator.pop(context); },
          ),
      ]),
    ));
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  const _FilterChip({required this.label, this.selected = false, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: icon != null ? Icon(icon, size: 16) : null,
        label: Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        backgroundColor: selected ? AppTheme.primaryColor.withOpacity(0.1) : null,
        side: BorderSide(color: selected ? AppTheme.primaryColor : AppTheme.borderColor),
        onPressed: onTap,
      ),
    );
  }
}
