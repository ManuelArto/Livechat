import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/steps_provider.dart';
import 'steps/circular_steps.dart';

class PreviewSteps extends StatefulWidget {
  const PreviewSteps({
    super.key,
  });

  @override
  State<PreviewSteps> createState() => _PreviewStepsState();
}

class _PreviewStepsState extends State<PreviewSteps> {

  void onPedometerError() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    StepsProvider stepsProvider = Provider.of<StepsProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
        future: stepsProvider.initPedometer(onPedometerError),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return (snapshot.hasError || !snapshot.data!)
              ? _buildNoPermissionPage("No pedometer permission given")
              : const CircularSteps();
        },
      ),
    );
  }

  Widget _buildNoPermissionPage(String errorMessage) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
            ),
          ),
          TextButton(
            onPressed: () => setState(() {}),
            child: const Text("Reload"),
          ),
        ],
      ),
    );
  }
}
