import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/response/trip_get_res.dart';
import 'package:flutter_application_2/pages/Tripcard.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/trip.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  final int cid; // เก็บ customer id ที่ส่งมาจาก login

  const ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(idx: widget.cid), // ✅ ใช้ widget.cid
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem(value: 'logout', child: Text('ออกจากระบบ')),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: Text("ปลายทาง")),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                FilledButton(onPressed: getTrips, child: const Text('ทั้งหมด')),
                const SizedBox(width: 8),
                FilledButton(onPressed: getTrips, child: const Text('เอเชีย')),
                const SizedBox(width: 8),
                FilledButton(onPressed: getTrips, child: const Text('ยุโรป')),
                const SizedBox(width: 8),
                FilledButton(onPressed: getTrips, child: const Text('อาเซียน')),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: getTrips,
                  child: const Text('ประเทศไทย'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: tripGetResponses
                  .map(
                    (trip) => Column(
                      children: [
                        TripCard(
                          name: trip.name,
                          country: trip.country,
                          duration: trip.duration,
                          price: trip.price,
                          imageUrl: trip.coverimage,
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripPage(idx: trip.idx),
                              ),
                            );
                          },
                          child: const Text('รายละเอียดเพิ่มเติม'),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
  }
}
