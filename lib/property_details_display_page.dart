import 'package:flutter/material.dart';
import 'package:landandplot/utils/call_utils.dart';
import 'package:landandplot/utils/message_utils.dart';
import 'image_carousel.dart';
import 'models/property_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/property_details_image.dart';
import 'models/user_details.dart';  // Import the UserDetails class

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
  PropertyDetailsImage? selectedPropertyImage;
  PropertyDetails? selectedProperty;
  UserDetails? selectedAgent;
  late List<PropertyDetails> propertyDetailslist;
  late String? imageUrl;
  late String? company;
  late List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    selectedPropertyImage = null;
    selectedProperty = null;
    selectedAgent = null;
    propertyDetailslist = [];
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final imageDetailsMap = await PropertyDetailsImage.fetchImageDetailsMap();
    final propertyDetailsMap = await PropertyDetails.fetchPropertyDetailsMap();
    final agentDetailsMap = await UserDetails.fetchUserDetailsMap();

    setState(() {
      if (imageDetailsMap.containsKey(widget.propertyId)) {
        selectedPropertyImage = imageDetailsMap[widget.propertyId];
        imageUrls = selectedPropertyImage!.imageUrls.values.toList();
      } else {
        imageUrls = [];
      }

      if (propertyDetailsMap.containsKey(widget.propertyId)) {
        selectedProperty = propertyDetailsMap[widget.propertyId];
      }

      if (agentDetailsMap.containsKey(widget.propertyId)) {
        selectedAgent = agentDetailsMap[widget.propertyId];
      }

      propertyDetailslist = propertyDetailsMap.values.toList();
    });
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
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
                              selectedProperty?.rent.toStringAsFixed(0) ?? '',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'Rent pm',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 120),
                            Text(
                              selectedProperty?.propertyType ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          selectedProperty?.address ?? '',
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          maxLines: 3,
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
                                    selectedProperty?.bedrooms ?? '',
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
                                    selectedProperty?.bathrooms ?? '',
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
                                    'Area Sft',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    selectedProperty?.totalArea.toString() ?? '',
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
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                    ),
                                    onPressed: () =>
                                        CallUtils.makeCall('+919959788005'),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.message),
                                    label: const Text(
                                      'Text',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                    ),
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
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                    ),
                                    onPressed: () => launchUrl(Uri.parse(
                                        'mailto:tirupathim@gmail.com')),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final Uri whatsappUri = Uri.parse(
                                          'https://wa.me/+919959788005');
                                      if (await canLaunchUrl(whatsappUri)) {
                                        await launchUrl(whatsappUri);
                                      } else {
                                        print('Could not launch $whatsappUri');
                                      }
                                    },
                                    child: const Text(
                                      'WhatsApp',
                                      style: TextStyle(fontSize: 20),
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
