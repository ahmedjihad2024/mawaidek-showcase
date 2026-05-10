// 1. Observer Interface
abstract class FavoritesObserver {
  void onFavoritesChanged(Map<int, bool> items);
}

// 2. Observable - FavoritesManager (Singleton)
class FavoritesManager {
  static final FavoritesManager instance = FavoritesManager._internal();
  FavoritesManager._internal();

  // Separate maps for providers (salons, clinics, etc.) and products
  final Map<int, bool> _items = {};
  final List<FavoritesObserver> _observers = [];

  // Get current favorites
  Map<int, bool> get items => Map.unmodifiable(_items);

  // Register observer
  void addObserver(FavoritesObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  // Unregister observer
  void removeObserver(FavoritesObserver observer) {
    _observers.remove(observer);
  }

  // ========== Product Methods ==========

  // Toggle product favorite
  void toggleProductFavorite(int itemId) {
    if (_items.containsKey(itemId)) {
      _items[itemId] = !_items[itemId]!;
    } else {
      _items[itemId] = true;
    }
    _notifyObservers();
  }

  // Add product to favorites
  void add(int itemId) {
    _items[itemId] = true;
    _notifyObservers();
  }

  // Remove product from favorites
  void remove(int itemId) {
    _items[itemId] = false;
    _notifyObservers();
  }

  void delete(int itemId) {
    _items.remove(itemId);
  }

  // Check if product is favorite
  bool isProductFavorite(int itemId) {
    return _items[itemId] ?? false;
  }

  // Clear all product favorites
  void clearProductFavorites() {
    _items.clear();
    _notifyObservers();
  }

  // ========== General Methods ==========

  // Clear all favorites (both providers and products)
  void clearAllFavorites() {
    _items.clear();
    _notifyObservers();
  }

  // Notify all observers
  void _notifyObservers() {
    Map<int, bool> copiedItems = Map.from(_items);
    for (var observer in _observers) {
      observer.onFavoritesChanged(copiedItems);
    }
  }

  // Get all favorite product IDs (only true values)
  List<int> getFavoriteProductIds() {
    return _items.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }
}