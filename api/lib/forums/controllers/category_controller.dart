import 'dart:convert';

import 'package:api/forums/repositories/category_repository.dart';
import 'package:shelf/shelf.dart';

class CategoryController {
  CategoryController({required this.categoryRepository});

  final CategoryRepository categoryRepository;

  Future<Response> getCategories(Request request) async {
    final categories = await categoryRepository.getCategories();
    return Response.ok(jsonEncode(categories));
  }
}
