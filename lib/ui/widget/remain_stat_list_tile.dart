import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/store.dart';

class RemainStatListTile extends StatelessWidget {
  // store를 받음.
  final Store store;

  RemainStatListTile(this.store, {super.key});

  // const RemainStatListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(store.name ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(store.addr ?? ''),
          Text('${store.km}km'),
        ],
      ),
      trailing: _buildRemainStatWidget(store),
      onTap: () {
        _launchUrl(store.lat!, store.lng!);
      },
    );
  }

  Widget _buildRemainStatWidget(Store store) {
    var reaminStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;
    if (store.remainStat == 'plenty') {
      reaminStat = '충분';
      description = '100개 이상';
      color = Colors.green;
    }
    switch (store.remainStat) {
      case 'plenty':
        reaminStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        reaminStat = '보통';
        description = '30개 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        reaminStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        reaminStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      // 아무것도 안써도 기본값 들어감
      default:
    }

    return Column(
      children: <Widget>[
        Text(
          reaminStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Future<void> _launchUrl(double lat, double lng) async {
    final Uri _url =
        Uri.parse('https://google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
