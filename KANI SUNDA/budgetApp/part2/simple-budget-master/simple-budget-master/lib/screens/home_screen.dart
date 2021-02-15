import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/new_category.dart';
import 'package:flutter_budget_ui/services/category_service.dart';
import 'package:flutter_budget_ui/services/item_service.dart';
import '../data/data.dart';
import '../widgets/bar_chart.dart';
import '../models/category_model.dart';
import 'category_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Category> _userCategory = [];

  List<Category> _categoryList = List<Category>();
  List<Item> _itemList = List<Item>();

  var _categoryService = CategoryService();
  var _itemService = ItemService();

  @override
  void initState() {
    super.initState();
    getAllCategories();
    getAllItems();
  }

//###################################################
  void _startAddNewCategory(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0),
                  )),
              child: NewCategory(_addNewCategory));
        });
  }

  // ignore: non_constant_identifier_names
  void _deleteCategory(String category_id) {
    setState(() {
      _userCategory.removeWhere((tx) {
        return tx.category_id == category_id;
      });
      //##########################
      _categoryService.deleteCategory(category_id);
    });
  }

  void _addNewCategory(String txTitle, double txAmount) {
    final Category cat = Category(
      category_name: txTitle,
      maxAmount: txAmount,
      category_id: _userCategory.length,
    );
    setState(() {
      _userCategory.add(cat);
    });
  }

//#####################################################
//#####################################################
//#####################################################

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.category_name = category['category_name'];
        categoryModel.category_id = category['category_id'];
        categoryModel.maxAmount = category['maxAmount'];
        categoryModel.currentAmount = category['currentAmount'] == null
            ? category['maxAmount']
            : category['currentAmount'];
        _categoryList.add(categoryModel);
      });
    });
  }

  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readAllItem();
    items.forEach((item) {
      setState(() {
        var itemModel = Item();
        itemModel.item_name = item['item_name'];
        itemModel.item_id = item['item_id'];
        itemModel.item_amount = item['item_amount'];
        itemModel.item_date = item['item_date'];
        itemModel.category_id = item['category_id'];
        _itemList.add(itemModel);
      });
    });
  }

//#####################################################
//#####################################################
//#####################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personal Expenses",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _startAddNewCategory(context);
                getAllCategories();
              }),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                )
              ],
            ),
            child: BarChart(weeklySpending),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: double.infinity,
              ),
              CategoryList(_categoryList, _deleteCategory),
            ],
          ),
        ],
      ),
    );
  }
}
