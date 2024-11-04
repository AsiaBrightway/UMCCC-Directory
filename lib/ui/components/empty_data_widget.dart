import 'package:flutter/cupertino.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/icons/no_data_empty.png',width: 200,height: 200,fit: BoxFit.cover,),
          const Text('Empty')
        ],
      ),
    );
  }
}
