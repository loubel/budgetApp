import 'package:flutter_budget_ui/repositories/repositories.dart';
import 'package:flutter_budget_ui/models/category_model.dart';

class CategoryService {
  Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  //INSERT DATA
  saveCategory(Category category) async {
    return await _repository.insertData('category', category.categoryMap());
  }

//READ DATA
  readCategory() async {
    return await _repository.readData('category');
  }

  //READY DATA BY ID
  readCategoryById(categoryId) async {
    return await _repository.readDataById('category', categoryId);
  }

//UPDATE CATEGORY
  updateCategory(Category category) async {
    return await _repository.updateData('category', category.categoryMap());
  }

  //DELETE CATEGORY
  deleteCategory(categoryId) async {
    return await _repository.deleteData('category', categoryId);
  }
}
