import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeProfileShimmer extends StatelessWidget {
  const EmployeeProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child:  Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: const CircleBorder(),
                    child: ClipOval(
                      child: Image.network(
                        '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          size: 86,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Primary Name'),
              const Text('Primary Secondary Name'),
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Cards()),
                  Expanded(child: Cards())
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      )
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
        height: MediaQuery.sizeOf(context).height * 0.2,
        decoration: const BoxDecoration(
          color: Colors.white54
        ),
        child: const Center(
          child: Text('personal info'),
        ),
      ),
    );
  }
}

