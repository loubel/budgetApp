import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/new_item.dart';
import 'package:flutter_budget_ui/services/item_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'item_list.dart';

class ItemCategory extends StatefulWidget {
  String category_id;
  List<Item> _itemCategory = <Item>[];
  final double maxAmount;
  ItemCategory(this.category_id, this.maxAmount);

  @override
  _ItemCategoryState createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<ItemCategory> {
  var newTitleController = TextEditingController();
  var newAmountController = TextEditingController();
  var item;
  var _itemService = ItemService();
  List<Item> _itemList = List<Item>();
  var _item = Item();

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readItem(widget.category_id);
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

  _editItem(BuildContext context, itemId) async {
    item = await _itemService.readItemById(itemId);
    setState(() {
      newTitleController.text = item[0]['item_name'] ?? 'No Name';
      newAmountController.text =
          item[0]['item_amount'].toString() ?? 'No Budget';
    });
  }

  //try
  sumOfAllCount() {
    double totalAmount = 0.0;
    int length = widget._itemCategory.length;
    int i = 0;

    for (i = 0; i < length; i++) {
      totalAmount = totalAmount + widget._itemCategory[i].item_amount;
    }

    return totalAmount;
  }

  percentageBar() {
    double percent = (sumOfAllCount() / widget.maxAmount);
    return percent;
  }

  percentage() {
    double percent = (sumOfAllCount() / widget.maxAmount) * 100;
    return percent;
  }

  void _deleteItem(String id) {
    setState(() {
      widget._itemCategory.removeWhere((tx) {
        return tx.item_id == id;
      });
    });
  }

  void _addNewItem(String txTitle, double txAmount) {
    final Item it = Item(
      item_name: txTitle,
      item_amount: txAmount,
      category_id: _itemList.length,
    );
    setState(() {
      _itemList.add(it);
    });
  }

  void _startAddNewItem(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Container(child: NewItem(_addNewItem));
        });
  }

  // void _addNewItem(String txTitle, double txAmount, DateTime chosenDate) {
  //   final Item tx = Item(
  //     item_name: txTitle,
  //     item_amount: txAmount,
  //     item_date: chosenDate,
  //     item_id: widget._itemCategory,
  //   );
  //   setState(() {
  //     widget._itemCategory.add(tx);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.category_id.toString(), // test if mo gana ang id sa categories
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _startAddNewItem(context);
                getAllItems();
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 6,
              margin: EdgeInsets.all(10),
              child: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    new CircularPercentIndicator(
                      radius: 200.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: percentageBar(),
                      center: Text(
                        percentage().toStringAsFixed(1) + '%',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.purple,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₱ ' + sumOfAllCount().toString(),
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "  /  ",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '\₱ ${widget.maxAmount}',
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ItemList(_itemList, _deleteItem),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          print(percentage());
          //_startAddNewItem(context);
        },
      ),
    );
  }
}
