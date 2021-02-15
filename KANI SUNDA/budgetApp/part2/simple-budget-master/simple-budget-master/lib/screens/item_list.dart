import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/services/item_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ItemList extends StatefulWidget {
  final List<Item> expenses;
  final Function deleteTx;
  var item;
  var category;
  var totalSum = 0;
  ItemList(this.expenses, this.deleteTx);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final SlidableController slidableController = SlidableController();
  final newItemController = TextEditingController();
  final newCostController = TextEditingController();
  List<Item> _itemList = List<Item>();
  DateTime _newSelectedDate;
  var _itemService = ItemService();

  var newTitleController = TextEditingController();
  var newAmountController = TextEditingController();

  currentDate(index) {
    DateTime currentselectedDate = widget.expenses[index].item_date;

    return DateFormat.yMd().format(currentselectedDate);
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
        _newSelectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.expenses.length);
    return Container(
      height: 500,
      child: widget.expenses.isEmpty
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Text(
                    widget.expenses.length
                        .toString(), // test rani if naa bay ma add
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Slidable(
                    controller: slidableController,
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      height: 120,
                      child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Text(
                                '${widget.expenses[index].item_name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(DateFormat.yMd()
                                  .format(widget.expenses[index].item_date)
                                  .toString()),
                              trailing: Text(
                                '\₱ ${widget.expenses[index].item_amount}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.black45,
                        icon: Icons.more_horiz,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              //Popup Dialogue
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                content: Container(
                                  height: 300.0,
                                  width: 360.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                    ),
                                    child: ListView(
                                      children: <Widget>[
                                        SizedBox(height: 20),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Edit Details",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 25.0,
                                                ),

                                                //TEXT FIELD ONLY
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          newItemController,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'New Name'),
                                                      onSubmitted: (_) {},
                                                    ),
                                                    TextField(
                                                      controller:
                                                          newCostController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'New Amount',
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onSubmitted: (_) {},
                                                    ),
                                                    Container(
                                                      height: 70,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              _newSelectedDate ==
                                                                      null
                                                                  ? "New Date"
                                                                  : DateFormat
                                                                          .yMd()
                                                                      .format(
                                                                          _newSelectedDate),
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          ),
                                                          // ignore: deprecated_member_use
                                                          FlatButton(
                                                            child: Text(
                                                                'Choose Date'),
                                                            onPressed: () {
                                                              setState(() {
                                                                _presentDatePicker();
                                                              });
                                                            },
                                                            textColor: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        child: Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        color: Colors.green,
                                                        onPressed: () async {
                                                          setState(() {
                                                            widget
                                                                    .expenses[index]
                                                                    .item_name =
                                                                newItemController
                                                                    .text;
                                                            widget
                                                                    .expenses[index]
                                                                    .item_amount =
                                                                double.parse(
                                                                    newCostController
                                                                        .text);
                                                            widget
                                                                    .expenses[index]
                                                                    .item_date =
                                                                _newSelectedDate;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            newItemController
                                                                .text = '';
                                                            newCostController
                                                                .text = '';
                                                          });
                                                        },
                                                        shape:
                                                            new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //EDIT BUTTON
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50.0),
                                                child: Container(
                                                  width: 150,
                                                  height: 40,
                                                  // ignore: deprecated_member_use
                                                  child: RaisedButton(
                                                    child: Text(
                                                      'Save',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      widget.expenses[index]
                                                              .item_name =
                                                          newItemController
                                                              .text;
                                                      widget.expenses[index]
                                                              .item_amount =
                                                          double.parse(
                                                              newCostController
                                                                  .text);
                                                      widget.expenses[index]
                                                              .item_date =
                                                          _newSelectedDate;
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(30.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () =>
                            widget.deleteTx(widget.expenses[index].item_id),
                      ),
                    ],
                  ),
                );
              },
              itemCount: widget.expenses.length,
            ),
    );
  }
}
