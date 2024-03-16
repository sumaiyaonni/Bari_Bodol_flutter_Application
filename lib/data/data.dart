import 'package:bari_bodol/model/house.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


List<String> categoryList = [
  '< 20,000 Tk',
  'Nearby',
  '3 bed room',
  'Low Cost',
  'Modular kitchen'
  'House with parking'
];

Future<List<House>> fetchHousesFromFirebase() async {
  List<House> houseList = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('RentPost').get();
    for (var doc in snapshot.docs) {
      House house = House(
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
      houseList.add(house);
    }
  } catch (e) {
    print('Error fetching houses: $e');
  }
  return houseList;
}

