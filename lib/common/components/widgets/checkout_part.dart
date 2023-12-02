import 'package:flutter/material.dart';
import 'package:playtorium_assignment/common/components/widgets/discount_tab.dart';

class CheckOutPart extends StatefulWidget {
  final VoidCallback callback1, callback2, callback3;
  final String detail1, detail2, detail3;
  final num totalPrice;
  const CheckOutPart({super.key, required this.callback1, required this.callback2, required this.callback3, required this.totalPrice, required this.detail1, required this.detail2, required this.detail3});

  @override
  State<CheckOutPart> createState() => _CheckOutPartState();
}

class _CheckOutPartState extends State<CheckOutPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              DiscountTab(desc: "coupon", detail: widget.detail1, callback: widget.callback1),
              DiscountTab(desc: "on top", detail: widget.detail2, callback: widget.callback2),
              DiscountTab(desc: "seasonal", detail: widget.detail3, callback: widget.callback3),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Price: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 30),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "฿ ${widget.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Colors.red),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                      ))
                      
                    ],
                  ))
            ],
          ),
        );
  }
}