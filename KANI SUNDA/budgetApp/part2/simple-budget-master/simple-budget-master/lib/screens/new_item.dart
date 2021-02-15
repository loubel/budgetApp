import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/services/category_service.dart';
import 'package:flutter_budget_ui/services/item_service.dart';
import 'package:intl/intl.dart';

class NewItem extends StatefulWidget {
  Function itemHandler;

  NewItem(this.itemHandler);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  List<Item> _itemList = List<Item>();
  var _item = Item();
  var _itemService = ItemService();

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  DateTime _selectedDate;

  double totalAmountSpent = 0.0;

  void submitData() async {
    if (amountController.text.isEmpty) {
      return;
    } else {
      _item.item_name = titleController.text;
      _item.item_amount = double.parse(amountController.text);
      _item.item_date = _selectedDate;
      print(_item.item_name);
      print(_item.item_amount);
      print(_item.item_date);
      var result = await _itemService.saveItem(_item);
      print(result);
      Navigator.of(context).pop();
    }

    // if (amountController.text.isEmpty) {
    //   return;
    // }
    // final enteredTitle = titleController.text;
    // final enteredAmount = double.parse(amountController.text);

    // if (enteredTitle.length == 0 ||
    //     enteredAmount < 0 ||
    //     _selectedDate == null) {
    //   return;

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Item Name'),
                controller: titleController,
                onSubmitted: (_) => submitData,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cost'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : DateFormat.yMd().format(_selectedDate),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      child: Text('Choose Date'),
                      onPressed: _presentDatePicker,
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 40,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child: Text(
                      'Add Category',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.green,
                    onPressed: () => submitData(),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
