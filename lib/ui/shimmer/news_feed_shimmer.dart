
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsFeedShimmer extends StatelessWidget {
  const NewsFeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 300,
              child: ListTile(
                leading: Icon(Icons.add_a_photo),
                title: Text('Item number'),
                subtitle: Text('Subtitle here'),
                trailing: Text("trailing"),
              ),
            ),
          );
        },
      ),
    );
  }
}
