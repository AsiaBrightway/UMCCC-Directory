import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PersonalInformationShimmer extends StatelessWidget {
  const PersonalInformationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color : Colors.white70,width: 1),
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color : Colors.white70,width: 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color : Colors.white70,width: 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color : Colors.white70,width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 26),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color : Colors.white70,width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 26),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color : Colors.white70,width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 26),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color : Colors.white70,width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 26),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color : Colors.white70,width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}