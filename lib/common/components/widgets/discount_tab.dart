import 'package:flutter/material.dart';

class DiscountTab extends StatefulWidget {
  final String desc;
  final String detail;
  final VoidCallback callback;
  const DiscountTab({super.key, required this.desc, required this.detail, required this.callback});

  @override
  State<DiscountTab> createState() => _DiscountTabState();
}

class _DiscountTabState extends State<DiscountTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.only(left: 16.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.desc.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  RawMaterialButton(
                    child: Text(
                      widget.detail.length > 0 ? widget.detail : 'Add >'.toUpperCase(),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: widget.callback,
                  )
                ],
              ),
            );
  }
}