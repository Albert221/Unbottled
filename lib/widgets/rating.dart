import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double rating;
  final bool trailing;

  const Rating({Key key, @required this.rating, this.trailing = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: [
        ...List.generate(rating.floor(), (_) => Icon(Icons.star)),
        if (rating.ceil() - rating.floor() >= 0.5) Icon(Icons.star_half),
        if (trailing)
          ...List.generate(5 - rating.ceil(), (_) => Icon(Icons.star_border)),
      ],
    );
  }
}
