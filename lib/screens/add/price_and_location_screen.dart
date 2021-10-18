import 'package:shopchat_app/screens/bottom_navigation.dart';
import 'package:shopchat_app/widgets/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_geocoder/geocoder.dart';

import 'package:shopchat_app/provider/ad_provider.dart';
import 'package:shopchat_app/models/ad_location.dart';
import 'package:shopchat_app/screens/add/maps_screen.dart';

class PriceAndLocationScreen extends StatefulWidget {

  static const routeName = './price_and_location_screen';

  @override
  _PriceAndLocationScreenState createState() => _PriceAndLocationScreenState();
}

class _PriceAndLocationScreenState extends State<PriceAndLocationScreen> {

  var isDonate     = false;
  var currLocation = '';
  double? latitude;
  double? longitude;
  var containerHeight   = 80.0;
  var textController    = TextEditingController();
  var addressController = TextEditingController();
  var isLoading = false;
  String mapUrl = '';
  late BuildContext ctx;

  Future<void> _openMapsScreen() async {

    final location = Location();

    final locData = await location.getLocation();
    latitude = locData.latitude;
    longitude = locData.longitude;

    final locationPreview = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return GoogleMapScreen(
            placeLocation: AdLocation(
              latitude: latitude,
              longitude: longitude,
              address: '',
            ),
            isEditable: true,
          );
        },
      ),
    );

    if (locationPreview == null) {
      return;
    } else {
      print('currentLocation is $locationPreview');

      final loc = locationPreview as LatLng;
      latitude  = loc.latitude;
      longitude = loc.longitude;
      //TODO: Cambiar API KEY
      final API_KEY = 'AIzaSyC9oIhVx-R9orUyVXorJSqn_AAfVn0tI9o';
      //var addressUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$API_KEY';

 

      //Endpoint para realizar el Login
      final uri = Uri.parse('https://maps.googleapis.com/maps/api/flutter_geocoder/json?latlng=$latitude,$longitude&key=$API_KEY');

      //Mapear la respuesta al modelo de tipo Usuario
      //Petición POST, en la cual enviamos el path del URL por argumento, obtenemos el apiURL desde el Enviroment
      final response = await http.post( uri );

      setState(() {
        mapUrl = Provider.of<AdProvider>(context, listen: false)
          .getLocationFromLatLang(
            latitude: loc.latitude,
            longitude: loc.longitude,
          );
        print('mapUrl is $mapUrl');

        addressController.text = json.decode(response.body)['results'][0]['formatted_address'];
      });
    }
  }

  void checkInputs(BuildContext ctx) {
    if ((textController.text.trim() == '0') ||
        (!isDonate && textController.text.isEmpty)) {
      showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          title: Text('Invalid Price'),
          content: Text('Please enter a valid price'),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else if (mapUrl.isEmpty) {
      showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          title: Text('Invalid input'),
          content: Text('Please provide your location to proceed further'),
          actions: [
            ElevatedButton(
              child: Text('Provide Location'),
              onPressed: () {
                getUserLocation();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else {
      submitLocation();
    }
  }

  Future<void> getUserLocation() async {

    final location = Location();

    final locData = await location.getLocation();
    latitude = locData.latitude;
    longitude = locData.longitude;

    //TODO: Cambiar API KEY
    final API_KEY = 'AIzaSyC9oIhVx-R9orUyVXorJSqn_AAfVn0tI9o';
   // var addressUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$API_KEY';

        //Endpoint para realizar el Login
    final uri = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$API_KEY');

    //Mapear la respuesta al modelo de tipo Usuario
    //Petición POST, en la cual enviamos el path del URL por argumento, obtenemos el apiURL desde el Enviroment
    final response = await http.post( uri );

    setState(() {
      currLocation = '$latitude,$longitude';
      mapUrl = Provider.of<AdProvider>(context, listen: false)
          .getLocationFromLatLang(
        latitude: latitude,
        longitude: longitude,
      );
      
      print('mapUrl is $mapUrl');

      print(json.decode(response.body));

      addressController.text = json.decode(response.body)['results'][0]['formatted_address'];

      

    });
  }

  Future<void> submitLocation() async {

    if (isDonate) {
      textController.text = '0.0';
    }
    
    Provider.of<AdProvider>(
      context,
      listen: false,
    ).addLocation(
      double.parse(textController.text),
      AdLocation(
        latitude: latitude,
        longitude: longitude,
        address: addressController.text != null ? addressController.text : '',
      ),
    );
    setState(() {
      isLoading = true;
    });
    await Provider.of<AdProvider>(
      context,
      listen: false,
    ).pushToFirebase();
    setState(() {
      isLoading = false;
    });
    Navigator.of(context)
        .pushReplacementNamed( BottomNavigationScreen.routeName );
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Enter the price'),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Sit back and relax, while we post your ad!',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: containerHeight,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: textController,
                            decoration: InputDecoration(
                              prefix: Text(
                                '₹',
                                style: TextStyle(fontSize: 20),
                              ),
                              labelText: 'Price',
                              labelStyle: TextStyle(
                                  fontSize: 20, fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                        mapUrl.isEmpty
                            ? Container()
                            : TextField(
                                maxLines: 2,
                                keyboardType: TextInputType.multiline,
                                controller: addressController,
                                decoration: InputDecoration(
                                  labelText: 'Address (optional)',
                                  labelStyle: TextStyle(
                                      fontSize: 20, fontFamily: 'Poppins'),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'I want to donate this book',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        IconButton(
                          icon: isDonate
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 40,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                  size: 40,
                                ),
                          onPressed: () {
                            textController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {
                              if (isDonate) {
                                containerHeight = 80;
                              } else {
                                containerHeight = 0;
                              }
                              isDonate = !isDonate;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: mapUrl.isEmpty
                                ? Text('No location selected')
                                : Image.network(
                                    mapUrl,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              label: Text( 'Current Location', ),
                              onPressed: getUserLocation,
                              icon:  Icon(
                                Icons.location_on_outlined,
                              ),
                              style: TextButton.styleFrom(
                                primary: Theme.of( context ).primaryColor,
                              ),       
                            ),


                            TextButton.icon(
                              label: Text( 'Choose Location' ),
                              onPressed: _openMapsScreen,
                              icon:  Icon(
                                Icons.map,
                              ),
                              style: TextButton.styleFrom(
                                primary: Theme.of( context ).primaryColor,
                              ),
        
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                   
      ),
      bottomNavigationBar: BottomButton(
        'Post',
        () => checkInputs(ctx),
        Icons.post_add_outlined,
      ),
    );
  }
}
