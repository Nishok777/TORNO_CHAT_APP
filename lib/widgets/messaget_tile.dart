import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool Sentbyme;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.Sentbyme})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.Sentbyme ? 0 : 24,
          right: widget.Sentbyme ? 24 : 0),
      alignment: widget.Sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.Sentbyme
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.Sentbyme
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
                : const BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
            color: widget.Sentbyme ? Colors.blue[500] : Colors.grey[700]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.sender.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.black,letterSpacing: -0.2),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16,color: Colors.black,),
          )
        ]),
      ),
    );
  }
}
