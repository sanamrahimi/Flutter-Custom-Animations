import 'package:custom_animations/models/Trip.dart';
import 'package:custom_animations/screens/details.dart';
import 'package:flutter/material.dart';

class TripList extends StatefulWidget {
  const TripList({Key? key}) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Widget> _tripTiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _addTrips();
    });
  }

  void _addTrips() {
    // get data from db
    List<TripModel> _trips = [
      TripModel(
          title: 'Beach Paradise', price: '350', nights: '3', img: 'beach.png'),
      TripModel(title: 'City Break', price: '400', nights: '5', img: 'city.png'),
      TripModel(title: 'Ski Adventure', price: '750', nights: '2', img: 'ski.png'),
      TripModel(title: 'Space Blast', price: '600', nights: '4', img: 'space.png'),
    ];

    Future ft = Future(() {});
    _trips.forEach((TripModel trip) {
      ft = ft.then((data) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          _tripTiles.add(_buildTile(trip));
          _listKey.currentState!.insertItem(_tripTiles.length - 1);
        });
      });
    });
  }

  Widget _buildTile(TripModel trip) {
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Details(trip: trip)));
      },
      contentPadding: const EdgeInsets.all(25),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${trip.nights} nights',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300])),
          Text(trip.title,
              style: TextStyle(fontSize: 20, color: Colors.grey[600])),
        ],
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Hero(
          tag: 'location-img-${trip.img}',
          child: Image.asset(
            'images/${trip.img}',
            height: 50.0,
          ),
        ),
      ),
      trailing: Text('\$${trip.price}'),
    );
  }

  final Tween<Offset> _offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _tripTiles.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(_offset),
            child: _tripTiles[index],
          );
        });
  }
}
