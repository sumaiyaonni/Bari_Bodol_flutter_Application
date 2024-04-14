class House {
  String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/bari-bodol-47f1f.appspot.com/o/user_house_images%2F1710161784753_0.jpg?alt=media&token=19b33ce7-880d-4a46-bc9c-bd578da69c74';
  String address;
  String description;
  String price;
  String bedRooms;
  String bathRooms;
  String number;
  String garages;
  List<String> moreImagesUrl;
  bool isFav;
  String docId;

  House({
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.price,
    required this.bathRooms,
    required this.bedRooms,
    required this.number,
    required this.garages,
    required this.moreImagesUrl,
    required this.isFav,
    required this.docId,
  });
}
