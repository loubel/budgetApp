import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/services/category_service.dart';

class NewCategory extends StatefulWidget {
  final Function categoryHandler;

  NewCategory(this.categoryHandler);

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  List<Category> _categoryList = List<Category>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  void submitData() async {
    // if (titleController.text.isEmpty || amountController.text.isEmpty) {
    //   return;
    // } else {
    //   //
    //   // _category.category_name = titleController.text;
    //   // _category.maxAmount = double.parse(amountController.text);
    //   // _category.currentAmount = double.parse(amountController.text);
    //   // var result = await _categoryService.saveCategory(_category);
    //   // print(result);

    //   // getAllCategories();

    //   final enteredTitle = titleController.text;
    //   final enteredAmount = double.parse(amountController.text);

    //   widget.categoryHandler(enteredTitle, enteredAmount);
    if (amountController.text.isEmpty) {
      return;
    } else {
      _category.category_name = titleController.text;
      _category.currentAmount = 1;
      _category.maxAmount = double.parse(amountController.text);
      print(_category.category_name);
      var result = await _categoryService.saveCategory(_category);
      print(result);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0))),
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Center(
                child: Text(
              'New Category',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            )),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount Per Week'),
            controller: amountController,
            keyboardType: TextInputType.number,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Container(
                width: 150,
                height: 40,
                child: RaisedButton(
                  child: Text(
                    'Add Category',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    setState(() {
                      submitData();
                    });
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
