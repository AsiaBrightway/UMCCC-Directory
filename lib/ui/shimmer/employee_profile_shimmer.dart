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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                    ),
                  ),
                  const SizedBox(width: 36,),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('employee name name'),
                      SizedBox(height: 6),
                      ///department text
                      Text('department name'),
                      SizedBox(height: 6),
                      ///job position
                      Text('job position'),
                      SizedBox(height: 6),
                      ///employee number
                      Text('employee number'),
                      SizedBox(height: 6),
                      ///jd code text
                      Text('appointment date'),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Cards()),
                  Expanded(child: Cards())
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Cards()),
                  Expanded(child: Cards())
                ],
              ),
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

