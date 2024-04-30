// video_property.dart

class VideoProperty {
  final String propertyId;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String propertyType; // New field
  final String areaName; // New field

  VideoProperty({
    required this.propertyId,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.propertyType, // Initialize new field
    required this.areaName, // Initialize new field
  });
}

List<VideoProperty> mockVideoProperties = [
  VideoProperty(
    propertyId: '1',
    title: 'Luxury Villa in Bali',
    videoUrl: 'https://www.youtube.com/watch?v=DU8MGAbr1VM',
    thumbnailUrl:
        'https://www.google.com/search?q=aggrcultural+land+video+of+1+minute&newwindow=1&sca_esv=594914537&sxsrf=AM9HkKne-Z6aZEpnX2nAc5fz9q0Z8l29Xg%3A1704121795799&ei=w9WSZZeiMK3vseMPoKmQ-A0&ved=0ahUKEwjXj6uyvLyDAxWtd2wGHaAUBN8Q4dUDCBE&uact=5&oq=aggrcultural+land+video+of+1+minute&gs_lp=Egxnd3Mtd2l6LXNlcnAiI2FnZ3JjdWx0dXJhbCBsYW5kIHZpZGVvIG9mIDEgbWludXRlMgoQIRigARjDBBgKSJUQUMQGWNcMcAF4AZABAJgBxAGgAcgGqgEDMC41uAEDyAEA-AEBwgIKEAAYRxjWBBiwA-IDBBgAIEGIBgGQBgg&sclient=gws-wiz-serp#fpstate=ive&vld=cid:2f637249,vid:DU8MGAbr1VM,st:0',
    propertyType: 'Aggriculture',
    areaName: 'Shadnagar',
  ),
  // Add more properties...
  VideoProperty(
    propertyId: '2',
    title: 'Luxury Villa in Bali',
    videoUrl: 'https://www.youtube.com/watch?v=DU8MGAbr1VM',
    thumbnailUrl:
        'https://www.google.com/search?q=aggrcultural+land+video+of+1+minute&newwindow=1&sca_esv=594914537&sxsrf=AM9HkKne-Z6aZEpnX2nAc5fz9q0Z8l29Xg%3A1704121795799&ei=w9WSZZeiMK3vseMPoKmQ-A0&ved=0ahUKEwjXj6uyvLyDAxWtd2wGHaAUBN8Q4dUDCBE&uact=5&oq=aggrcultural+land+video+of+1+minute&gs_lp=Egxnd3Mtd2l6LXNlcnAiI2FnZ3JjdWx0dXJhbCBsYW5kIHZpZGVvIG9mIDEgbWludXRlMgoQIRigARjDBBgKSJUQUMQGWNcMcAF4AZABAJgBxAGgAcgGqgEDMC41uAEDyAEA-AEBwgIKEAAYRxjWBBiwA-IDBBgAIEGIBgGQBgg&sclient=gws-wiz-serp#fpstate=ive&vld=cid:2f637249,vid:DU8MGAbr1VM,st:0',
    propertyType: 'Aggriculture',
    areaName: 'Shadnagar',
  ),
];
