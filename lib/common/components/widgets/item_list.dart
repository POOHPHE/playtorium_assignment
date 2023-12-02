import 'package:flutter/material.dart';
import 'package:playtorium_assignment/core/models/Items.dart';

class ItemList extends StatefulWidget {
  final Item item;
  final VoidCallback plusClick, minusClick, delClick;
  const ItemList({super.key, required this.item, required this.plusClick, required this.minusClick, required this.delClick});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    

    final descriptionWidget = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Text(
          widget.item.category,
          style: const TextStyle(
            fontSize: 20
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text("฿ ${widget.item.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),
                )
            )),
            
          ],
        ),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 30,),
            SizedBox(
              width: 30,
              height: 30,
              child: Ink(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 212, 212, 212),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove),
                  iconSize: 24,
                  onPressed: widget.minusClick
                ), 
              ),
            ),
            Text("${widget.item.amount}"),
            Center(
              child: Ink(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 212, 212, 212),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
                  iconSize: 24,
                  onPressed: widget.plusClick
                ), 
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0,)
    ]);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Expanded(
              flex: 2, 
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0), 
                child: descriptionWidget,
              )),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 138, 43, 36),),
              onPressed: widget.delClick
            )
         ],
        ),
      ));
  }
}