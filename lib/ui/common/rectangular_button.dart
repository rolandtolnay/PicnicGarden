import 'package:flutter/material.dart';

enum _RectangularButtonType { outlined, flat }

class RectangularButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final TextStyle textStyle;

  final _RectangularButtonType _type;

  RectangularButton.outlined({
    Key key,
    @required this.title,
    this.icon,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.textStyle,
  })  : _type = _RectangularButtonType.outlined,
        color = null,
        super(key: key);

  RectangularButton.flat({
    Key key,
    @required this.title,
    this.icon,
    this.onPressed,
    this.color,
    this.textColor,
    this.textStyle,
  })  : _type = _RectangularButtonType.flat,
        borderColor = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _RectangularButtonType.outlined:
        return _buildOutlineButton(context);
      case _RectangularButtonType.flat:
        return _buildFlatButton(context);
      default:
        throw Exception;
    }
  }

  Container _buildOutlineButton(BuildContext context) {
    return Container(
      height: 50.0,
      child: OutlineButton(
        textColor: textColor ?? Theme.of(context).colorScheme.primaryVariant,
        borderSide: BorderSide(
          color: borderColor ??
              Theme.of(context)
                  .colorScheme
                  .primaryVariant, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 2, //width of the border
        ),
        child: _buildButtonChild(),
        onPressed: onPressed,
      ),
    );
  }

  Container _buildFlatButton(BuildContext context) {
    return Container(
      height: 50.0,
      child: FlatButton(
        color: color ?? Theme.of(context).colorScheme.primaryVariant,
        textColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
        child: _buildButtonChild(),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildButtonChild() {
    final textStyle = this.textStyle ??
        const TextStyle(
          letterSpacing: 1.25,
          fontWeight: FontWeight.w500,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...[Icon(icon), SizedBox(width: 8.0)],
        Text(title.toUpperCase(), style: textStyle),
      ],
    );
  }
}
