import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/response/trip_idx_get_res.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  // Create late variables
  late TripIdxGetResponse tripIdxGetResponse;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    // Call async function
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายละเอียดทริป')),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // แสดงข้อมูลเมื่อโหลดเสร็จ
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อทริป
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tripIdxGetResponse.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ประเทศ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    tripIdxGetResponse.country,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 8),

                // ภาพ
                Image.network(
                  tripIdxGetResponse.coverimage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),

                const SizedBox(height: 8),

                // ราคา และ ปลายทาง
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ราคา ${tripIdxGetResponse.price} บาท',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        tripIdxGetResponse.destinationZone,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // รายละเอียด
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tripIdxGetResponse.detail,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 16),

                // ปุ่มจอง
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic จองทริป
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('จองเลย!!'),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // Async function for api call
  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
