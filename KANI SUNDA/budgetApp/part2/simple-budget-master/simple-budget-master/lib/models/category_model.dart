class Category {
  int category_id;
  String category_name;
  double maxAmount;
  double currentAmount;

  Category({
    this.category_id,
    this.category_name,
    this.maxAmount,
    this.currentAmount,
  });

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['category_id'] = category_id;
    mapping['category_name'] = category_name;
    mapping['maxAmount'] = maxAmount;
    mapping['currentAmount'] = currentAmount;

    return mapping;
  }
}
