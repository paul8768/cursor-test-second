import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: ListView(
        children: [
          _buildActivityItem(
            icon: Icons.favorite,
            color: Colors.red,
            text: 'User1 liked your post',
            time: '2h ago',
          ),
          _buildActivityItem(
            icon: Icons.reply,
            color: Colors.blue,
            text: 'User2 replied to your post',
            time: '4h ago',
          ),
          _buildActivityItem(
            icon: Icons.person_add,
            color: Colors.green,
            text: 'User3 started following you',
            time: '1d ago',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String text,
    required String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(text),
      subtitle: Text(time),
      onTap: () {
        // TODO: Navigate to the relevant content
      },
    );
  }
} 