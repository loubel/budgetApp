import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<double> expenses;

  //Initialize using constructor

  BarChart(this.expenses);

  @override
  Widget build(BuildContext context) {
    double mostExpensive = 0;

    expenses.forEach((price) {
      if (price > mostExpensive) {
        mostExpensive = price;
      }
    });

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(
            'Weekly Spending',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
                Text('Nov 10, 2019 - Nov 16, 2019',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {}),
              ]),
          SizedBox(height: 30.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Bar(
                  label: 'Su',
                  amountSpend: expenses[0],
                  mostExpensive: mostExpensive,
                ),
                Bar(
                  label: 'Mo',
                  amountSpend: expenses[1],
                  mostExpensive: mostExpensive,
                ),
                Bar(
                  label: 'Tu',
                  amountSpend: expenses[2],
                  mostExpensive: mostExpensive,
                ),
                Bar(
                  label: 'We',
                  amountSpend: expenses[3],
                  mostExpensive: mostExpensive,
                ),
                Bar(
                  label: 'Th',
                  amountSpend: expenses[4],
                  mostExpensive: mostExpensive,
                ),
                Bar(
                  label: 'Fr',
                  amountSpend: expenses[5],
                  mostExpensive: mostExpensive,
                ),
                Bar(
                  label: 'Sa',
                  amountSpend: expenses[6],
                  mostExpensive: mostExpensive,
                ),
              ]),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpend;
  final double mostExpensive;

  final double _maxBarHeight = 150.0;

  Bar({this.label, this.amountSpend, this.mostExpensive});

  Widget build(BuildContext context) {
    final double barHeight = amountSpend / mostExpensive * _maxBarHeight;

    return Column(
      children: <Widget>[
        Text('\$${amountSpend.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 6.0),
        Container(
          height: barHeight,
          width: 18.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        SizedBox(height: 8.0),
        Text(label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
