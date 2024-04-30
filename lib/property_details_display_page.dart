//property_details_display_page.dart

import 'package:flutter/material.dart';
import 'package:landandplot/models/property_address.dart';
import 'package:landandplot/utils/call_utils.dart';
import 'package:landandplot/utils/message_utils.dart';
import 'image_carousel.dart';
import 'models/agent.dart';
import 'models/property_details.dart';
import 'models/property_details_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsDisplayPage extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsDisplayPage({Key? key, required this.propertyId})
      : super(key: key);

  @override
  _PropertyDetailsDisplayPageState createState() =>
      _PropertyDetailsDisplayPageState();
}

class _PropertyDetailsDisplayPageState
    extends State<PropertyDetailsDisplayPage> {
  PropertyDetails_image? selectedPropertyImage;
  PropertyDetails? selectedProperty;
  // AmenitiesDetails? selectedAmenities;
  AgentDetails?
      selectedAgent; // Declare the variable  late List<PropertyDetails> propertyDetailslist;
  late String? imageUrl; // Declare imageUrl and company as late variables
  late String? company;
  late List<PropertyDetails> propertyDetailslist;
  late PropertyDetails_image propertyImages;
  late List<String> imageUrls;
  late List<PropertyAddress> propertyAddresslist; // Declare the variable here

  @override
  void initState() {
    super.initState();
    selectedPropertyImage = null;
    selectedProperty = null;
    // selectedAmenities = null;
    selectedAgent = null;
    propertyDetailslist = [];
    propertyAddresslist = [];

    propertyImages =
        PropertyDetails_image.fetchImageDetailsMap()[widget.propertyId]!;

    imageUrls = propertyImages.imageUrls.values.toList();

    final imageDetailsMap = PropertyDetails_image.fetchImageDetailsMap();
    final propertyDetailsMap = PropertyDetails.fetchPropertyDetailsMap();
    // final amenitiesDetailsMap = AmenitiesDetails.fetchAmenitiesDetailsMap();
    final agentDetailsMap = AgentDetails.fetchAgentDetailsMap();
    //final propertyAddressList = createPropertyAddressList(context);

    if (imageDetailsMap.containsKey(widget.propertyId)) {
      selectedPropertyImage = imageDetailsMap[widget.propertyId];
      print('Selected property image: $selectedPropertyImage');
    }

    if (propertyDetailsMap.containsKey(widget.propertyId)) {
      selectedProperty = propertyDetailsMap[widget.propertyId];
    }

    // if (amenitiesDetailsMap.containsKey(widget.propertyId)) {
    //   selectedAmenities = amenitiesDetailsMap[widget.propertyId];
    // }

    if (agentDetailsMap.containsKey(widget.propertyId)) {
      selectedAgent = agentDetailsMap[widget.propertyId];
    }

    //propertyAddresslist = propertyAddressList;
    propertyDetailslist = propertyDetailsMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    // Declare imageUrl and company variables here
    String? imageUrl;
    String? company;

    // Check if selectedAgent is not null
    if (selectedAgent != null) {
      imageUrl = selectedAgent!.imageUrl;
      company = selectedAgent!.company;
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0.0),
          // child: Column(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.zero, // Remove margin
                    child: ImageCarousel(imageUrls: imageUrls),
                  ),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              selectedProperty!.rent.toStringAsFixed(
                                  0), // Display rent without decimal places
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    15), // Add some spacing between the Text widgets

                            const Text(
                              'Rent pm',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    120), // Add some spacing between the Text widgets
                            Text(
                              selectedProperty!.propertyType,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          selectedProperty!.address,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          maxLines:
                              3, // Set maxLines to 2 to display address on two lines
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Bed',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    selectedProperty!.bedrooms,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Bath',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    selectedProperty!.bathrooms,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(),
                            const VerticalDivider(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Area Sft',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    selectedProperty!.totalArea as String,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        const Text(
                          'Listing Agent',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: imageUrl != null
                                    ? NetworkImage(imageUrl) as ImageProvider
                                    : const AssetImage("agent_image"),
                              ),
                              const SizedBox(height: 8.0),
                              const Text('R'),
                              const Text('Agent'),
                              Text('$company - Hyderabad'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.call),
                                    label: const Text(
                                      'Call',
                                      style: TextStyle(
                                          fontSize:
                                              20), // Adjust font size as needed
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical:
                                              20), // Adjust padding as needed
                                    ),
                                    // onPressed: () => launchUrl(Uri.parse('tel:$agentPhoneNumber')),
                                    onPressed: () =>
                                        CallUtils.makeCall('+919959788005'),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.message),
                                    label: const Text(
                                      'Text',
                                      style: TextStyle(
                                          fontSize:
                                              20), // Adjust font size as needed
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical:
                                              20), // Adjust padding as needed
                                    ),
                                    // onPressed: () => launchUrl(Uri.parse('sms:$agentPhoneNumber')),
                                    onPressed: () =>
                                        MessageUtils.sendSMS('+919959788005'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.email),
                                    label: const Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize:
                                              20), // Adjust font size as needed
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical:
                                              20), // Adjust padding as needed
                                    ),
                                    //onPressed: () => launchUrl(Uri.parse('mailto:$agentEmail')),
                                    onPressed: () => launchUrl(Uri.parse(
                                        'mailto:tirupathim@gmail.com')),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Replace '+919959788005' with the full international phone number without the '+' sign
                                      final Uri whatsappUri = Uri.parse(
                                          'https://wa.me/+919959788005');
                                      if (await canLaunchUrl(whatsappUri)) {
                                        await launchUrl(whatsappUri);
                                      } else {
                                        // Show a message or handle the failure to launch the URL
                                        print('Could not launch $whatsappUri');
                                      }
                                    },
                                    child: const Text(
                                      'WhatsApp',
                                      style: TextStyle(
                                          fontSize: 20), // Larger font size
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
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
}
