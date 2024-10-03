import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalInformationShimmer extends StatelessWidget {
  const PersonalInformationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text('Item number $index as title'),
                subtitle: const Text('Subtitle here'),
              ),
            ),
          );
        },
      ),
    );



    // return SizedBox(
    //   width: MediaQuery
    //       .of(context)
    //       .size
    //       .width,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const SizedBox(height: 20),
    //           Row(
    //             children: [
    //               Expanded(
    //                 child: Skeleton(height:)
    //               ),
    //               const SizedBox(width: 20),
    //               Expanded(
    //                 child: Container(
    //                   height: 60,
    //                   decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       border: Border.all(color : Colors.white70,width: 1),
    //                       borderRadius: BorderRadius.circular(10)
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 20,),
    //           Container(
    //             height: 60,
    //             width: MediaQuery.of(context).size.width * 0.65,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 border: Border.all(color : Colors.white70,width: 1),
    //                 borderRadius: BorderRadius.circular(10)
    //             ),
    //           ),
    //           const SizedBox(height: 26),
    //           Container(
    //             height: 60,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 border: Border.all(color : Colors.white70,width: 1),
    //                 borderRadius: BorderRadius.circular(10)
    //             ),
    //           ),
    //           const SizedBox(height: 26),
    //           Container(
    //             height: 60,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 border: Border.all(color : Colors.white70,width: 1),
    //                 borderRadius: BorderRadius.circular(10)
    //             ),
    //           ),
    //           const SizedBox(height: 26),
    //           Container(
    //             height: 60,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 border: Border.all(color : Colors.white70,width: 1),
    //                 borderRadius: BorderRadius.circular(10)
    //             ),
    //           ),
    //           const SizedBox(height: 26),
    //           Container(
    //             height: 60,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 border: Border.all(color : Colors.white70,width: 1),
    //                 borderRadius: BorderRadius.circular(10)
    //             ),
    //           ),
    //         ],
    //       ),
    //   ),
    // );
  }
}