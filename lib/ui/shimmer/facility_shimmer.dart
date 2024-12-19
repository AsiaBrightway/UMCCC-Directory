import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FacilityShimmer extends StatelessWidget {
  const FacilityShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Skeletonizer(
        enabled: true,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
              child: SizedBox(
                height: 60,
                child: ListTile(
                  title: Text('Item number $index as title'),
                  trailing: const Text('abc'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
