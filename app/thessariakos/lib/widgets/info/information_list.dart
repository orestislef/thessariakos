import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thessariakos/API/api.dart';
import 'package:thessariakos/models/responses/info_response.dart';

class InformationForm extends StatelessWidget {
  const InformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InfoResponse>(
      future: Api.getInfo(),
      builder: (context, infoResponse) {
        if (infoResponse.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (infoResponse.hasError) {
          return Center(
            child: Text('Error: ${infoResponse.error}'),
          );
        } else {
          final infoList = infoResponse.data!.infos;
          if (infoList.isEmpty) {
            return const Center(
              child: Text(
                'No information available.',
                style: TextStyle(fontSize: 18.0),
              ),
            );
          }

          // Calculate days and years passed
          DateTime startDate = DateTime(2023, 11, 10);
          DateTime currentDate = DateTime.now();
          int daysPassed = currentDate.difference(startDate).inDays;

          return Scrollbar(
            child: ListView.builder(
              itemCount: infoList.length + 1, // Add 1 for the additional ListTile
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text('info_time_passed_fly_over'.tr()),
                    subtitle: Text('$daysPassed ${'days'.tr()}'),
                  );
                } else {
                  final info = infoList[index - 1];
                  return ListTile(
                    title: Text(info.name),
                    subtitle: Text(info.details),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
