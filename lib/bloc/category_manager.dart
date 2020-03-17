import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/category_wrapper.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:flutter/cupertino.dart';

class CategoryManager {
  BuildContext context;
  CategoryService _categorieService = new CategoryService();
  List<Category> _childCatgories = new List();
  List<Category> _parentCategories = new List();
  List<Category> _categoryList = new List();
  CategoryWrapper _categoryWrapper = new CategoryWrapper();

  CategoryManager(this.context);

  Stream<CategoryWrapper> get categoryWrapper async* {
    _categoryList = await _categorieService.fetchCategories();

    _categoryWrapper = buildParentCategories(_categoryList);

    yield _categoryWrapper;
  }

  CategoryWrapper buildParentCategories(List<Category> categories) {
    if (_parentCategories == null || _parentCategories.isEmpty) {
      List<Category> translatedcategories =
          _categorieService.translateCategories(categories, context);
      for (var _categorie in translatedcategories) {
        if (_categorie.parentid == null) {
          _parentCategories.add(_categorie);
        } else {
          _childCatgories.add(_categorie);
        }
      }

      _parentCategories.sort((a, b) => a.title.compareTo(b.title));
      Category categorieTemp = _parentCategories.firstWhere((categorie) =>
          categorie.title == 'Other categories' ||
          categorie.title == 'Autre categories');
      _parentCategories.removeWhere((categorie) =>
          categorie.title == 'Other categories' ||
          categorie.title == 'Autre categories');
      _parentCategories.add(categorieTemp);
    }

    CategoryWrapper categoryWrapper = new CategoryWrapper();

    categoryWrapper.parentCategories = _parentCategories;
    categoryWrapper.childCategories = _childCatgories;

    return categoryWrapper;
  }
}
