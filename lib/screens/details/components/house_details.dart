import 'package:bari_bodol/constants/colors..dart';
import 'package:bari_bodol/constants/styles.dart';
import 'package:bari_bodol/model/house.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

import '../../../constants.dart';

class HouseDetails extends StatefulWidget {
  final House house;
  const HouseDetails(this.house, {super.key});

  @override
  _HouseDetailsState createState() => _HouseDetailsState();
}

class _HouseDetailsState extends State<HouseDetails> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: appPadding,
              left: appPadding,
              right: appPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Rent",style: TextStyle(fontSize: 16),),
                Text(
                  '${widget.house.price}Tk',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: appPadding),
                  child: Flexible(
                    child: Text(
                      'Address: ${widget.house.address}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: black.withOpacity(0.4),
                        height: 2.0,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: appPadding, bottom: appPadding),
            child: Text(
              'House information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: appPadding,
              right: appPadding,
              bottom: appPadding * 4,
            ),
            child: Text(
              widget.house.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: black.withOpacity(0.4),
                height: 2.0,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Call the Owner",
                middleText: widget.house.number,
                backgroundColor: kPrimaryColor,
                titleStyle: TextStyle(color: Colors.white,fontSize: 16),
                middleTextStyle: TextStyle(color: Colors.white,fontSize: 20),

              );
            },
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Call Now",
                  style: TextStyle(
                      fontSize: 18,
                      color: kTextWhiteColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
