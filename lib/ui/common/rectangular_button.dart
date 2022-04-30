import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

enum _RectangularButtonType { outlined, flat }

class RectangularButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final int badgeCount;
  final bool isMarked;

  final _RectangularButtonType _type;

  const RectangularButton.outlined({
    Key? key,
    required this.title,
    this.icon,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.textStyle,
    this.isMarked = false,
    badgeCount,
  })  : _type = _RectangularButtonType.outlined,
        badgeCount = badgeCount ?? 0,
        color = null,
        super(key: key);

  const RectangularButton.flat({
    Key? key,
    required this.title,
    this.icon,
    this.onPressed,
    this.color,
    this.textColor,
    this.textStyle,
    this.isMarked = false,
    badgeCount,
  })  : _type = _RectangularButtonType.flat,
        badgeCount = badgeCount ?? 0,
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

  Widget _buildOutlineButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 50.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? colorScheme.primaryContainer,
            style: BorderStyle.solid,
            width: 2,
          ),
          primary: textColor ?? colorScheme.primaryContainer,
        ),
        onPressed: onPressed,
        child: _buildButtonChild(context),
      ),
    );
  }

  Widget _buildFlatButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color ?? colorScheme.primary,
          onPrimary: textColor ?? colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        child: _buildButtonChild(context),
      ),
    );
  }

  Widget _buildButtonChild(BuildContext context) {
    final textStyle = this.textStyle ??
        const TextStyle(
          letterSpacing: 1.25,
          fontWeight: FontWeight.w500,
        );

    return Badge(
      showBadge: badgeCount != 0,
      position: BadgePosition.topStart(top: -32, start: -8),
      padding: const EdgeInsets.all(8.0),
      toAnimate: false,
      badgeContent: Text(
        '$badgeCount',
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
      child: Badge(
        showBadge: isMarked,
        position: BadgePosition.topEnd(top: -16, end: 0),
        toAnimate: false,
        badgeColor: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...[Icon(icon), SizedBox(width: 8.0)],
            Text(title.toUpperCase(), style: textStyle),
          ],
        ),
      ),
    );
  }
}
