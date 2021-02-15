import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/screens/item_category.dart';
import 'package:flutter_budget_ui/services/category_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryList extends StatefulWidget {
  final List<Category> categories;
  final Function deleteTx;
  CategoryList(this.categories, this.deleteTx);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final SlidableController slidableController = SlidableController();
  double dummyData = 450;

  var newTitleController = TextEditingController();
  var newAmountController = TextEditingController();

  var category;
  var _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>();
  var _category = Category();

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

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      newTitleController.text = category[0]['category_name'] ?? 'No Name';
      newAmountController.text =
          category[0]['maxAmount'].toString() ?? 'No Budget';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 386,
      child: widget.categories.isEmpty
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Text(
                    'No Categories Added Yet',
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ItemCategory(
                              widget.categories[index].category_id.toString(),
                              widget.categories[index].maxAmount),
                        ));
                  },
                  child: Slidable(
                    controller: slidableController,
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      height: 130,
                      child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.categories[index].category_name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '$dummyData',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' /  ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\₱${widget.categories[index].maxAmount}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final double maxBarWidth = constraints.maxWidth;
                              final double percent =
                                  (widget.categories[index].maxAmount -
                                          dummyData) /
                                      widget.categories[index].maxAmount;
                              double barWidth = percent * maxBarWidth;
                              if (barWidth < 0) {
                                barWidth = 0;
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[200],
                                      ),
                                    ),
                                    Container(
                                      height: 20.0,
                                      width: barWidth,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: getColor(context, percent),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      //EDIT BUTTON
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.black45,
                        icon: Icons.more_horiz,
                        onTap: () {
//##################################################################
//############################### edit ##############################
//##################################################################
                          //_editCategory(context, index);
                          showDialog(
                            context: context,
                            builder: (context) {
                              //Popup Dialogue
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
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
                                                          newTitleController,
                                                      decoration: InputDecoration(
                                                          hintText: widget
                                                              .categories[index]
                                                              .category_name),
                                                      onSubmitted: (_) {},
                                                    ),
                                                    TextField(
                                                      controller:
                                                          newAmountController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            '\₱${widget.categories[index].maxAmount}',
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onSubmitted: (_) {},
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
                                                      setState(() async {
                                                        widget.categories[index]
                                                                .category_name =
                                                            newTitleController
                                                                .text;
                                                        widget.categories[index]
                                                                .maxAmount =
                                                            double.parse(
                                                                newAmountController
                                                                    .text);
                                                        Navigator.of(context)
                                                            .pop();

                                                        if (newTitleController
                                                                .text.isEmpty ||
                                                            newAmountController
                                                                .text.isEmpty) {
                                                          return;
                                                        } else {
                                                          _category
                                                                  .category_id =
                                                              category[0][
                                                                  'category_id'];
                                                          _category
                                                                  .category_name =
                                                              newTitleController
                                                                  .text;
                                                          _category.maxAmount =
                                                              double.parse(
                                                                  newAmountController
                                                                      .text);
                                                          var result =
                                                              await _categoryService
                                                                  .updateCategory(
                                                                      _category);
                                                          print(result);
                                                          Navigator.of(context)
                                                              .pop();
                                                          getAllCategories();
                                                        }
                                                      });
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

                      //END OF EDIT BUTTON
//##################################################################
//############################### delete ###########################
//##################################################################

                      //DELETE BUTTON

                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => widget.deleteTx(
                          widget.categories[index].category_id,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: widget.categories.length,
            ),
    );
  }
}
