import 'package:flutter/material.dart';
import '../constants/constants.dart';

class DefaultButton extends StatelessWidget {
  final VoidCallback onPress;
  final String title;

  const DefaultButton({
    super.key,
    required this.onPress,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
        ),
        padding: EdgeInsets.only(right: kDefaultPadding),
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
