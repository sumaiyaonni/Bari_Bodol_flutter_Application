import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bari_bodol/constants/constants.dart';

class PredictionPostPage extends StatefulWidget {
  const PredictionPostPage({Key? key}) : super(key: key);

  @override
  _PredictionPostPageState createState() => _PredictionPostPageState();
}

class _PredictionPostPageState extends State<PredictionPostPage> {
  bool _isLoading = false;
  Map<String, int> _areaPostCounts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          'Predict Post',
          style: TextStyle(color: kTextWhiteColor),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildResult(),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  const Center(
                    child: Text(
                      '  Post Predicting\n           with\nMachine Learning',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _predictMaxHousePosts();
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildResult() {
    return ListView.builder(
      itemCount: _areaPostCounts.length,
      itemBuilder: (context, index) {
        final areaName = _areaPostCounts.keys.toList()[index];
        final postCount = _areaPostCounts.values.toList()[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: index == 0 ? Colors.green[100] : Colors.blue[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    '#${index + 1}. ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      areaName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Text('Number of Posts: $postCount'),
            ),
          ),
        );
      },
    );
  }

  Future<void> _predictMaxHousePosts() async {
    setState(() {
      _isLoading = true;
      _areaPostCounts.clear();
    });

    // Simulate a delay of 3 seconds for prediction
    await Future.delayed(Duration(seconds: 3));

    try {
      // Fetch all house rent posts from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('RentPost')
          .get();

      // Extract area from each post's address and count the number of posts in each area
      querySnapshot.docs.forEach((doc) {
        final address = doc['address'] as String;
        final area = _extractAreaFromAddress(address);
        _areaPostCounts[area] = (_areaPostCounts[area] ?? 0) + 1;
      });

      // Sort the area post counts in descending order
      _areaPostCounts = Map.fromEntries(_areaPostCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)));
    } catch (error) {
      print('Error fetching house posts: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _extractAreaFromAddress(String address) {
    final parts = address.split(', ');
    return parts.first;
  }
}
