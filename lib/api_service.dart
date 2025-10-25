import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'article_model.dart'; 
 
class ApiService { 
  static const String _apiKey = '33a718f1f6304f44880eeadd3d60ec8e'; 
 
  // Utama: berita banjir 
  static const String _baseUrlId = 
      'https://newsapi.org/v2/top-headlines?country=us&category=business'; 
 
  // Cadangan: berita  
  static const String _fallbackUrl = 
      'https://newsapi.org/v2/top-headlines?country=us&category=business'; 
 
  Future<List<Article>> fetchArticles() async { 
    try { 
      final urlId = Uri.parse('$_baseUrlId&apiKey=$_apiKey'); 
      final response = await http.get(urlId); 
 
      print('STATUS CODE (ID): ${response.statusCode}'); 
      print('BODY (ID): ${response.body.substring(0, 100)}...'); 
 
      if (response.statusCode == 200) { 
        final data = json.decode(response.body); 
 
        if (data['totalResults'] == 0) { 
          print('⚠️ Tidak ada berita Indonesia, ambil berita global...'); 
          return await _fetchFallback(); 
        } 
 
        final List<dynamic> articlesJson = data['articles']; 
        return articlesJson.map((json) => Article.fromJson(json)).toList(); 
      } else { 
        return await _fetchFallback(); 
      } 
    } catch (e) { 
      print('❌ Error: $e'); 
      return await _fetchFallback(); 
    } 
  } 
 
  Future<List<Article>> _fetchFallback() async { 
    final fallbackUrl = Uri.parse('$_fallbackUrl&apiKey=$_apiKey'); 
    final response = await http.get(fallbackUrl); 
 
    print('STATUS CODE (Fallback): ${response.statusCode}'); 
    print('BODY (Fallback): ${response.body.substring(0, 100)}...'); 
 
    if (response.statusCode == 200) { 
      final data = json.decode(response.body); 
      final List<dynamic> articlesJson = data['articles']; 
      return articlesJson.map((json) => Article.fromJson(json)).toList(); 
    } else { 
      throw Exception('Gagal memuat artikel fallback'); 
    } 
  } 
}