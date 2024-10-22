import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class Networklayer extends StatefulWidget {
  const Networklayer({super.key});

  @override
  State<Networklayer> createState() => _NetworklayerState();
}

class _NetworklayerState extends State<Networklayer> {
  List<Launch>? details;
  List<bool>? isOpenList;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var res =
          await http.get(Uri.parse('https://api.spacexdata.com/v3/missions'));
      if (res.statusCode == 200) {
        List listJson = jsonDecode(res.body);
        setState(() {
          details = listJson.map((item) => Launch.fromJson(item)).toList();
          isOpenList = List.generate(details!.length, (_) => false);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: details!.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(0.8),
                  child: ExpansionPanelList(
                    expansionCallback: (pIndex, isExpanded) {
                      setState(() {
                        isOpenList![index] = !isOpenList![index];
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(details![index].missionName ??
                                "error fetching"),
                          );
                        },
                        body: ListTile(
                          title: Text(details![index].description ??
                              'No description available'),
                        ),
                        isExpanded: isOpenList![index],
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: details![index]
                      .payloadIds!
                      .map((payloadId) => Chip(
                          label: Text(payloadId),
                          backgroundColor: Color.fromARGB(
                              Random().nextInt(255),
                              Random().nextInt(255),
                              Random().nextInt(255),
                              Random().nextInt(255))))
                      .toList(),
                ),
              ]);
            },
          );
  }
}

class Launch {
  String? missionName;
  String? missionId;
  List<String>? manufacturers;
  List<String>? payloadIds;
  String? wikipedia;
  String? website;
  String? twitter;
  String? description;

  Launch(
      {this.missionName,
      this.missionId,
      this.manufacturers,
      this.payloadIds,
      this.wikipedia,
      this.website,
      this.twitter,
      this.description});

  Launch.fromJson(Map<String, dynamic> json) {
    missionName = json['mission_name'];
    missionId = json['mission_id'];
    manufacturers = json['manufacturers']?.cast<String>();
    payloadIds = json['payload_ids']?.cast<String>();
    wikipedia = json['wikipedia'];
    website = json['website'];
    twitter = json['twitter'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mission_name'] = missionName;
    data['mission_id'] = missionId;
    data['manufacturers'] = manufacturers;
    data['payload_ids'] = payloadIds;
    data['wikipedia'] = wikipedia;
    data['website'] = website;
    data['twitter'] = twitter;
    data['description'] = description;
    return data;
  }
}
