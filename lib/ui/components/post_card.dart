import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/vos/post_vo.dart';

class PostCard extends StatelessWidget {
  final PostVo post;

  const PostCard({super.key, required this.post});

  String formatDateOnly(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (_) {
      try {
        final dateTime = DateFormat('dd-MM-yyyy HH:mm').parse(timestamp);
        return DateFormat('yyyy-MM-dd').format(dateTime);
      } catch (_) {
        return 'Invalid date';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar, name, time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/umccc_logo.png") as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "UMCCC",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.modifiedDate.toString(), // Format like "2h ago"
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Post message
            if (post.postContent != null && post.postContent!.isNotEmpty)
              Text(
                post.postContent!,
                style: const TextStyle(fontSize: 15),
              ),

            // Post image (optional)
            if (post.featureImageUrl != null && post.featureImageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.getImageWithBaseUrl(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => const Text("Failed to load image"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}