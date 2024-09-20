import 'package:flutter/material.dart';

class ErrorEmployeeWidget extends StatelessWidget {
  const ErrorEmployeeWidget(
      {super.key, required this.errorEmployee, required this.tryAgain});

  final String errorEmployee;
  final Function() tryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cloud_off,
          size: 26,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          errorEmployee,
          style: const TextStyle(fontFamily: 'Ubuntu', fontSize: 18),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: tryAgain,
          child: const Text('Try Again'),
        )
      ],
    );
  }
}
