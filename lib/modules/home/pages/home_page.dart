import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playtorium_assignment/common/components/widgets/checkout_part.dart';
import 'package:playtorium_assignment/common/components/widgets/item_list.dart';
import 'package:playtorium_assignment/common/utils/global_variable.dart';
import 'package:playtorium_assignment/core/models/Items.dart';

const List<String> list = <String>['Clothing', 'Accessories', 'Electronics'];

enum CouponCategory { fixed, percent }
enum OnTopCategory { byitem, bypoints }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Item> _items = [];
  
  String dropdownValue = list.first, ontopDropdown = list.first;

  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();
  final TextEditingController _couponFieldController = TextEditingController();
  final TextEditingController _ontopFieldController = TextEditingController();
  final TextEditingController _seasonEveryFieldController = TextEditingController();
  final TextEditingController _seasonSubFieldController = TextEditingController();

  String couponTxt = "", ontopTxt = "", seasonTxt = "";
  
  num totalPrice = 0.0;
  bool isFixedAmount = false;
  num couponNumber = 0;
  num ontopNumber = 0;
  bool isByItem = false;
  num everyPrice = 2, subPrice = 1;
  bool useCoupon = false, useOntop = false, useSeasonal = false;

  double roundDouble(double value, int places){ 
    num mod = pow(10.0, places); 
    return ((value * mod).round().toDouble() / mod); 
  }

  CouponCategory? _coupon = CouponCategory.fixed;
  OnTopCategory? _ontop = OnTopCategory.byitem;
  CouponCategory? _couponSum = CouponCategory.fixed;
  OnTopCategory? _ontopSum = OnTopCategory.byitem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addItem(){
    setState(() {
      
      _items.add(Item(name: _nameFieldController.text, price: roundDouble(double.parse(_priceFieldController.text), 2), category: dropdownValue, amount: 1));
         
      
      sum();
    });

  }

  void increaseAmount(int index) {
    setState(() {
    _items[index].amount += 1;
      sum();
    });
  }

  void decreaseAmount(int index) {
    setState(() {
      
    if(_items[index].amount > 1) _items[index].amount -= 1;
    sum();
    });
  }

  void deleteItem(int index) {
    setState(() {
      
    _items.removeAt(index);
    sum();
    });
  }

  void sum(){
    totalPrice = 0.0;
    for (int i = 0; i < _items.length; i++) {
      totalPrice += _items[i].price * _items[i].amount;
    }
    if (useCoupon) totalPrice = couponDiscount(totalPrice);
    if (useOntop) totalPrice = ontopDiscount(totalPrice);
    if (useSeasonal) totalPrice = seasonalDiscount(totalPrice);

    print("Total Price is ${totalPrice}");
    setState(() {
      totalPrice;
    });
  }

  num couponDiscount(num sum) {
    if (_couponSum == CouponCategory.fixed) {
      return sum - couponNumber;
    }

    return sum - sum * couponNumber / 100.0;
  }

  num ontopDiscount(num sum) {
    if (_ontopSum == OnTopCategory.byitem) {
      num temp = 0.0;
      for (int i = 0; i<_items.length; i++) {
        if (ontopDropdown.toUpperCase() == _items[i].category.toUpperCase()){
          temp += _items[i].price;
        }
      }
      return sum - temp * (ontopNumber/100.0);
    }

    return sum - ontopNumber;
  }

  num seasonalDiscount(num sum) {
    
    return sum - ((sum/everyPrice).toInt() * subPrice);
  }

  num totalPriceDiscount(bool isCoupon){
    num temp = 0;
    for (int i=0; i < _items.length; i++){
      temp += _items[i].price;
    }
    if (isCoupon || !useCoupon) return temp;


    return couponDiscount(temp);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ListView.builder(
            padding: width > webScreenSize
                ? EdgeInsets.only(left: width * 0.3, right: width * 0.3)
                : const EdgeInsets.only(top: 8.0),
            itemCount: _items.length + 1,
            itemBuilder: (context, index) {
              if (index < _items.length){
                return ItemList(item: _items[index], plusClick: () => increaseAmount(index), minusClick: () => decreaseAmount(index), delClick: () => deleteItem(index),);
              }
              return Column(
                children: [       
                  CheckOutPart(
                    detail1: couponTxt,
                    detail2: ontopTxt,
                    detail3: seasonTxt,
                    totalPrice: totalPrice,
                    callback1: () {
                      _coupon = _couponSum;
                      _dialogCouponBuilder(context);
                    },
                    callback2: () {
                      _ontop = _ontopSum;
                      _dialogOnTopBuilder(context);
                    },
                    callback3: () => _dialogSeasonBuilder(context),
                  ),
                  SizedBox(
                    child: RawMaterialButton(
                      child: Text("ADD Item", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 105, 240, 139)),),
                      onPressed: (){
                        _nameFieldController.clear();
                        _priceFieldController.clear();
                        dropdownValue = list.first;
                        _dialogAddItemBuilder(context);
                      }
                      ),
                  ),
                ],
              );
            }
    );
    
  }

  Future<void> _dialogCouponBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
                builder: ((context, setState) {
                  return AlertDialog(
                    title: const Text('Basic dialog title'),
                    content: Column(
                      children: [
                        Text("Add Coupon", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                        ListTile(
                          title: const Text('Fixed amount'),
                          leading: Radio<CouponCategory>(
                            value: CouponCategory.fixed,
                            groupValue: _coupon,
                            onChanged: (CouponCategory? value) {
                              setState(() {
                                _coupon = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Percentage discount'),
                          leading: Radio<CouponCategory>(
                            value: CouponCategory.percent,
                            groupValue: _coupon,
                            onChanged: (CouponCategory? value) {
                              setState(() {
                                _coupon = value;
                              });
                            },
                          ),
                        ),
                        _coupon == CouponCategory.fixed ? 
                        Column(
                          children: [
                            TextField(
                              decoration: new InputDecoration.collapsed(
                                hintText: 'Amount'
                              ),
                              controller: _couponFieldController,
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              onChanged: (String? value) {
                                setState(() {
                                });
                              },
                            ),
                            (totalPrice > 0.0 && isNumeric(_couponFieldController.text) && num.parse(_couponFieldController.text) > 0 && num.parse(_couponFieldController.text) < totalPriceDiscount(true)) ? Text("the amount must more than 0 and less than total price", style: TextStyle(color: Colors.red),) : Text(""),
                          ],
                        ): Column(
                          children: [
                            TextField(
                              decoration: new InputDecoration.collapsed(
                                hintText: 'Percentage'
                              ),
                              controller: _couponFieldController,
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              onChanged: (String? value) {
                                setState(() {
                                });
                              },
                            ),
                            (totalPrice > 0 && isNumeric(_couponFieldController.text) && num.parse(_couponFieldController.text) > 0 && num.parse(_couponFieldController.text) < 100) ? Text("the precentage must more than 0 and less than 100", style: TextStyle(color: Colors.red),) : Text(""),
                          ],
                        ),
                        RawMaterialButton(
                          child: Text("Clear"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              useCoupon = false;
                              sum();
                              _couponFieldController.clear();
                              couponTxt = "";
                            });
                        })
                          

                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Apply'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            couponNumber = num.parse(_couponFieldController.text);
                            
                            useCoupon = true;
                            _couponSum = _coupon;
                            couponTxt = _couponSum == CouponCategory.fixed ? "Fixed Amount ${couponNumber} > ": "${couponNumber} % > ";
                            sum();
                          });
                          
                        },
                      ),
                      
                    ],
                  );
                }
              )
            );
      }
     );
    }

    Future<void> _dialogOnTopBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
                builder: ((context, setState) {
                  return AlertDialog(
                    title: const Text('Basic dialog title'),
                    content: Column(
                      children: [
                        Text("Add OnTop Discount"),
                        ListTile(
                          title: const Text('Percentage discount by item category'),
                          leading: Radio<OnTopCategory>(
                            value: OnTopCategory.byitem,
                            groupValue: _ontop,
                            onChanged: (OnTopCategory? value) {
                              setState(() {
                                _ontop = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Discount by points'),
                          leading: Radio<OnTopCategory>(
                            value: OnTopCategory.bypoints,
                            groupValue: _ontop,
                            onChanged: (OnTopCategory? value) {
                              setState(() {
                                _ontop = value;
                              });
                            },
                          ),
                        ),
                        _ontop == OnTopCategory.bypoints ? 
                        Column(children: [
                          TextField(
                              decoration: new InputDecoration.collapsed(
                                hintText: 'Points'
                              ),
                              controller: _ontopFieldController,
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              onChanged: (String? value) {
                                setState(() {
                                });
                              },
                            ),
                        ],) :
                        Column(
                          children: [
                            TextField(
                              decoration: new InputDecoration.collapsed(
                                hintText: 'Percentage'
                              ),
                              controller: _ontopFieldController,
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              onChanged: (String? value) {
                                setState(() {
                                });
                              },
                            ),
                            DropdownButton<String>(
                              value: ontopDropdown,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? value) {
                              
                              
                                setState(() {
                                  ontopDropdown = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                        RawMaterialButton(
                          child: Text("Clear"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              useOntop = false;
                              _ontopFieldController.clear();
                              ontopTxt = "";
                              sum();
                            });
                        })
                          

                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Apply'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            useOntop = true;
                            _ontopSum = _ontop;
                            if (_ontopSum == OnTopCategory.bypoints) {
                              ontopNumber = num.parse(_ontopFieldController.text).clamp(0, totalPriceDiscount(false)/5.0);
                              print("${ontopNumber} pop ${totalPriceDiscount(false)}");
                              _ontopFieldController.text = ontopNumber.toString();
                              ontopTxt = "Ontop ${ontopNumber} by Point > ";
                            }else {
                              ontopNumber = num.parse(_ontopFieldController.text);
                              ontopTxt = "Ontop ${ontopNumber} by Percent > ";
                            }
                            
                            sum();
                          });
                        },
                      ),
                      
                    ],
                  );
                }
              )
            );
      }
     );
    }

    Future<void> _dialogSeasonBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
                builder: ((context, setState) {
                  return AlertDialog(
                    title: const Text('Basic dialog title'),
                    content: Column(
                      children: [
                        Text("Add Season Discount"),
                        TextField(
                              decoration: new InputDecoration.collapsed(
                                hintText: 'Every'
                              ),
                              controller: _seasonEveryFieldController,
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              onChanged: (String? value) {
                                setState(() {
                                });
                              },
                            ),
                        TextField(
                          decoration: new InputDecoration.collapsed(
                            hintText: 'Decrease'
                          ),
                          controller: _seasonSubFieldController,
                          keyboardType: const TextInputType.numberWithOptions(signed: true),
                          onChanged: (String? value) {
                            setState(() {
                            });
                          },
                        ),
                        
                        RawMaterialButton(
                          child: Text("Clear"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              useSeasonal = false;
                              _seasonEveryFieldController.clear();
                              _seasonSubFieldController.clear();
                              seasonTxt = "";
                              sum();
                            });
                        })
                          

                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Apply'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            useSeasonal = true;
                            
                            everyPrice = num.parse(_seasonEveryFieldController.text);
                            subPrice = num.parse(_seasonSubFieldController.text);
                            seasonTxt = "Season ${everyPrice} decrease ${subPrice} > ";
                           
                            sum();
                          });
                        },
                      ),
                      
                    ],
                  );
                }
              )
            );
      }
     );
    }

    void _dialogAddItemBuilder(BuildContext context) {
      
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
                builder: ((context, setState) {
                  return AlertDialog(
                    title: const Text('Add Item'),
                    content: Column(
                      children: [
                        TextField(
                          decoration: new InputDecoration.collapsed(
                          hintText: 'Item Name',
                        ),
                          controller: _nameFieldController,
                          onChanged: (String? value) {
                            setState(() {
                            });
                          },
                        ),
                        _nameFieldController.text.isEmpty ? Text("required item's name", style: TextStyle(color: Colors.red),) : Text(""),
                        const SizedBox(height: 20,),
                        TextField(
                          decoration: new InputDecoration.collapsed(
                          hintText: 'Price'
                        ),
                          controller: _priceFieldController,
                          keyboardType: const TextInputType.numberWithOptions(signed: true),
                          onChanged: (String? value) {
                            setState(() {
                            });
                          },
                        ),
                        !isNumeric(_priceFieldController.text) ? Text("the price must be a number", style: TextStyle(color: Colors.red),) : (isNumeric(_priceFieldController.text) && num.parse(_priceFieldController.text) < 0) ? Text("the price must more than 0", style: TextStyle(color: Colors.red),): Text(""),
                        const SizedBox(height: 20,),
                        DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? value) {
                              
                              
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ]
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Add'),
                          onPressed: () {
                            if (isNumeric(_priceFieldController.text) && _nameFieldController.text.isNotEmpty && double.parse(_priceFieldController.text) > 0) {
                              Navigator.of(context).pop();
                              addItem();
                              setState(() {
                                sum();
                              },);
                            }   
                          },
                        ),
                        
                      ],
                      
                    );
          }),
          
        );
      }
     );
    }
    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }
}