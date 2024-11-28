import 'package:flutter/material.dart';

class TileContainer extends StatefulWidget {
  final String title;
  final String description;
  final Function()? onTap;

  const TileContainer({
    Key? key,
    required this.title,
    required this.description,  this.onTap,
  }) : super(key: key);

  @override
  _TileContainerState createState() => _TileContainerState();
}

class _TileContainerState extends State<TileContainer> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: _toggleExpanded,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: _expanded ? null : 50, // Set height to null when expanded
        decoration: BoxDecoration(
          border: Border.all(
            color: _expanded ? Colors.white : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
          color: _expanded ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.all(10),
                child: Image.network(widget.description)
                // Text(
                //   widget.description,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 15,
                //   ),
                //   maxLines: null, // Allow the text to expand vertically
                //   overflow: TextOverflow.clip, // Clip overflowed text
                // ),
              ),
          ],
        ),
      ),
    );
  }
}
