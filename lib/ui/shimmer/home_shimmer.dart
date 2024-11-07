import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    /// Set to any specific height that fits your layout
    return SizedBox(
      height: 110,
      child: Skeletonizer(
        enabled: true,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: ListTile(
                  leading: Container(
                    height: 80,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  title: Text('Item number $index as title'),
                  subtitle: const Text('Subtitle here'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
