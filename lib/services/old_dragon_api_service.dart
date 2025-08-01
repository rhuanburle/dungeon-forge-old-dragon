// services/old_dragon_api_service.dart

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class OldDragonApiService {
  OldDragonApiService._internal();
  static final OldDragonApiService _instance = OldDragonApiService._internal();
  factory OldDragonApiService() => _instance;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://olddragon.com.br',
      headers: {
        'User-Agent': 'DungeonForge (dungeonforge@example.com)',
        'Accept': 'application/json',
      },
    ),
  );

  late Box _cache;

  Future<void> init() async {
    _cache = await Hive.openBox('od_cache');
  }

  /// Busca lista de monstros em /monstros.json e cacheia por 24h.
  Future<List<dynamic>> fetchMonsters() async {
    const cacheKey = 'monstros';
    final cached = _getCached(cacheKey);
    if (cached != null) return cached as List<dynamic>;

    final res = await _dio.get('/monstros.json');
    _setCache(cacheKey, res.data, const Duration(hours: 24));
    return res.data;
  }

  /// Busca lista de equipamentos em /equipamentos.json (endpoint fictício)
  Future<List<dynamic>> fetchEquipments() async {
    const cacheKey = 'equipamentos';
    final cached = _getCached(cacheKey);
    if (cached != null) return cached as List<dynamic>;

    final res = await _dio.get('/equipamentos.json');
    _setCache(cacheKey, res.data, const Duration(hours: 24));
    return res.data;
  }

  /// Busca JSON individual de um monstro pelo slug, ex.: /monstros/ogro.json
  Future<Map<String, dynamic>> fetchMonsterBySlug(String slug) async {
    final cacheKey = 'monster_$slug';
    final cached = _getCached(cacheKey);
    if (cached != null) return cached as Map<String, dynamic>;

    final res = await _dio.get('/monstros/$slug.json');
    _setCache(cacheKey, res.data, const Duration(hours: 24));
    return Map<String, dynamic>.from(res.data);
  }

  /// -------------- helpers -------------
  dynamic _getCached(String key) {
    if (!_cache.containsKey(key)) return null;
    final obj = _cache.get(key);
    final expiry = _cache.get('$key:exp');
    if (expiry != null && DateTime.now().isAfter(expiry)) {
      _cache.delete(key);
      _cache.delete('$key:exp');
      return null;
    }
    return obj;
  }

  void _setCache(String key, dynamic value, Duration ttl) {
    _cache.put(key, value);
    _cache.put('$key:exp', DateTime.now().add(ttl));
  }
}
