// lib/screens/agent_profile.dart

import 'package:flutter/material.dart';

import '../widgets/user_profile_image.dart';

class AgentProfile extends StatelessWidget {
  final String agentImageUrl;

  AgentProfile({required this.agentImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent Profile'),
      ),
      body: Center(
        child: UserProfileImage(imageUrl: agentImageUrl),
      ),
    );
  }
}