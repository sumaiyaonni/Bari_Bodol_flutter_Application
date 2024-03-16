import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bari_bodol/model/house.dart';
import 'package:bari_bodol/screens/details/details_screen.dart';

class Houses extends StatefulWidget {
  const Houses({Key? key}) : super(key: key);

  @override
  _HousesState createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  late Stream<List<House>> _housesStream;

  @override
  void initState() {
    super.initState();
    _housesStream = _fetchHousesFromFirebase();
  }

  Stream<List<House>> _fetchHousesFromFirebase() {
    return FirebaseFirestore.instance.collection('RentPost').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return House(
          imageUrl: doc['imageUrl'],
          address: doc['address'],
          description: doc['description'],
          price: doc['price'],
          bedRooms: doc['bedRooms'],
          bathRooms: doc['bathRooms'],
          garages: doc['garages'],
          number: doc['number'],
          isFav: doc['isFav'],
          moreImagesUrl: List<String>.from(doc['moreImagesUrl']),
        );
      }).toList();
    });
  }

  Widget _buildHouse(BuildContext context, House house) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(house: house),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      house.imageUrl, // Use imageUrl from the House object
                      height: 180,
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: house.isFav
                            ? Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                            : Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Implement favorite functionality if needed
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${house.price}Tk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      house.address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${house.bedRooms} Bedrooms / ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${house.bathRooms} Bathrooms / ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${house.garages} Parking',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<House>>(
        stream: _housesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<House>? houses = snapshot.data;
            if (houses != null && houses.isNotEmpty) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: houses.length,
                itemBuilder: (context, index) {
                  return _buildHouse(context, houses[index]);
                },
              );
            } else {
              return Center(
                child: Text('No houses available.'),
              );
            }
          }
        },
      ),
    );
  }
}
