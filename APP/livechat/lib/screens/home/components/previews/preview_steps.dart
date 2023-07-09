import 'package:flutter/material.dart';
import 'package:livechat/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
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
  late StepsProvider _stepsProvider;

  @override
  void initState() {
    super.initState();
    _stepsProvider = Provider.of<StepsProvider>(context, listen: false);
  }

  void onPedometerError() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
        future: _stepsProvider.initPedometer(onPedometerError),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if ((snapshot.hasError && snapshot.error is String)) {
            return _buildNoPermissionPage(snapshot.error as String);
          }
          return const CircularSteps();
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
            onPressed: () async {
              await PermissionService.checkSinglePermission(
                Permission.activityRecognition,
                _stepsProvider.setPermission,
              );
              setState(() {});
            },
            child: const Text("Reload"),
          ),
        ],
      ),
    );
  }
}
