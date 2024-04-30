// custom_drawer.dart
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The Drawer widget is now being returned from the build method.
    return Drawer(
      child: Container(
        // Container with purple background
        color: Colors.white, // Full drawer background color
        child: SingleChildScrollView(
          // Enables scrolling
          child: Column(
            children: <Widget>[
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors
                      .white, // This will fill the entire header with deep purple color
                ),
                accountName:Text(
                  'LANDANDPLOT',
                  style: TextStyle(
                    color: Colors.green, // Set the text color to black
                    fontSize: 30, // Adjust the font size as needed
                    fontWeight: FontWeight.w800, // Make the text bold
                  ),
                ),
                accountEmail: Text(
                    ''), // Empty Text widget if no email is to be displayed
              ),

              Container(
                color: Colors.white, // White color for the rest of the drawer
                child: Column(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/'),
                      child: ListTile(
                        leading: Icon(Icons.home),
                        title: Text(
                          'Home Screen',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/clustermarkercheck'),
                      child: const ListTile(
                        leading: Icon(Icons.map),
                        title: Text('map',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertyreg'),
                      child: const ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Post A Property',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/loginscreen'),
                      child: const ListTile(
                        leading: Icon(Icons.login),
                        title: Text('Login Screen',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),


                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/videolistpage'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Property Videos',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Property Lists',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),                    // TextButton(

                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Property list',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/placessautocomplete'),
                      child: const ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Search A Property',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylistscreen'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Real Estate Agents',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylistscreen'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Mortgage Caluculator',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylistscreen'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Financial Plan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    // I want to add "Other" section
                    ListTile(
                      title: Align(
                        alignment: Alignment.centerLeft, // Align text to the left
                        child: Text(
                          'OTHER',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Makes text bold
                            color: Colors.green, // Sets text color
                            fontSize: 24, // Sets font size
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/addpropertybylap'),
                      child: ListTile(
                        leading: Icon(Icons.home),
                        title: Text(
                          'Add A Property',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('About Us',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Rate This App',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Report A Issue',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Terms of Service',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/propertylist'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Disclaimer',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/privacysettingspage'),
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Privacy Settings Page',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed', // Use the font family declared in pubspec.yaml
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 17, // Increase the font size by 1, assuming the default is 16
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}