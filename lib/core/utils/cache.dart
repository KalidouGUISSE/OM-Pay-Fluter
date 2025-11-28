/// Cache simple en mémoire pour les données fréquentes.
class SimpleCache {
    static final Map<String, _CacheEntry> _cache = {};

    /// Récupère une valeur du cache si elle n'est pas expirée.
    static T? get<T>(String key) 
    {
        final entry = _cache[key];
        if (entry != null && !entry.isExpired) {
            return entry.value as T;
        }
        _cache.remove(key);
        return null;
    }

    /// Stocke une valeur dans le cache avec une durée de vie.
    static void set(String key, dynamic value, Duration ttl) 
    {
        _cache[key] = _CacheEntry(value, DateTime.now().add(ttl));
    }

    /// Supprime une entrée spécifique du cache.
    static void remove(String key) {
        _cache.remove(key);
    }

    // Vide le cache.
    static void clear()
    {
        _cache.clear();
    }
}

class _CacheEntry {
    final dynamic value;
    final DateTime expiry;

    _CacheEntry(this.value, this.expiry);

    bool get isExpired => DateTime.now().isAfter(expiry);
}