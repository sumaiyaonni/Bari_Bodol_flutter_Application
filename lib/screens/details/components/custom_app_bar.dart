import 'package:bari_bodol/constants/colors..dart';
import 'package:bari_bodol/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: appPadding,
      ),
      child: Container(
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: darkBlue,
                  border: Border.all(color: darkBlue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
