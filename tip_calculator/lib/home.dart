import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'util/hexcolor.dart';

class BillsSplitter extends StatefulWidget {
  @override
  _BillsSplitterState createState() => _BillsSplitterState();
}

class _BillsSplitterState extends State<BillsSplitter> {
  int _tipPercent = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;

  Color _blue = HexColor("#3268a8");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height *
                0.1), //Using MediaQuery allows me to make the distance always the same no matter what device
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: _blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      12.0) //Makes the box kinda of circular
                  ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total Per Person",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                          color: _blue),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "\$ ${calculateTotalPersonPerson(_billAmount, _personCounter, _tipPercent)}",
                        style: TextStyle(
                            fontSize: 34.9,
                            fontWeight: FontWeight.bold,
                            color: _blue),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: Colors.lightBlueAccent.shade100,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true), //This is the number keyboard
                      style: TextStyle(color: _blue),
                      decoration: InputDecoration(
                          prefixText: "Bill Amount :",
                          prefixIcon: Icon(Icons.attach_money)),
                      onChanged: (String value) {
                        try {
                          _billAmount = double.parse(
                              value); //Since onChanged needs to pass in a String it then changes that into a double
                        } catch (exception) {
                          _billAmount =
                              0.0; //If anything happens that's not supposed to happen this gets set to 0 because of the catch
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Split",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              //This Inwell deals with what the minus does then its childs create the box and actual symbol
                              onTap: () {
                                setState(() {
                                  //on tap it sets the state to do something
                                  if (_personCounter > 1) {
                                    _personCounter--;
                                  } else {
                                    //do nothing
                                  }
                                });
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: _blue.withOpacity(0.1)),
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                        color: _blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "$_personCounter",
                              style: TextStyle(
                                  //Text in between minus and add sign
                                  color: _blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0),
                            ),
                            InkWell(
                              //This Inwell deals with what the add does then its childs create the box and actual symbol
                              onTap: () {
                                setState(() {
                                  _personCounter++;
                                });
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: _blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Center(
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                        color: _blue,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //Tip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Tip",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            " \$ ${(calculateTotalTip(_billAmount, _personCounter, _tipPercent)).toStringAsFixed(2)}",
                            style: TextStyle(
                                color: _blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                        )
                      ],
                    ),
                    //Slider
                    Column(
                      children: <Widget>[
                        Text(
                          "$_tipPercent%",
                          style: TextStyle(
                              color: _blue,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Slider(
                            min: 0,
                            max: 100,
                            activeColor: _blue,
                            inactiveColor: Colors.grey,
                            divisions:
                                10, //limits it so for example this is divided by 10 so it goes by 10 until 100
                            value: _tipPercent.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                _tipPercent = value.round(); //self explanatory
                              });
                            })
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  calculateTotalPersonPerson(
      double billAmount, int splitBy, int tipPercentage) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, splitBy, tipPercentage) + billAmount) /
            splitBy;

    return totalPerPerson.toStringAsFixed(2); //2 decimal points, BUG FIX
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPercentage) {
    double totalTip = 0.0;

    if (billAmount < 0 || billAmount.toString().isEmpty || billAmount == null) {
      //Nothing
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }
    return totalTip;
  }
}
