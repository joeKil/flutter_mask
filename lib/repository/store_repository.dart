import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../model/store.dart';

class StoreRepository {
  final _distance = Distance();

  Future<List<Store>> fetch(double lat, double lng) async {
    List<Store> stores = [];

    //   setState(() {
    //    isLoading = true;
    // });

    var url = Uri.parse(
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974'
            'deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat=$lat&lng=$lng');

    var response = await http.get(url);
    // print('Response status: ${response.statusCode}');
    // utf8 디코드를 하지 않아도 제대로 body의 내용이 나온다. 이유가 뭘까?
    // print('Response status: ${response.body}');

    // 이렇게만 쓰면 모두 스트링 형태로 들어온다. 제이슨 형태로 변환을 해줘야한다.
    // print('Response status: ${jsonDecode(utf8.decode(response.bodyBytes))}');
    try {
      if (response.statusCode == 200) {
        final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));

        final jsonStores = jsonResult['stores'];

        // 지워주는 이유는 새로고침 할 때 안쌓이게 하려고

        // setState(() {
        // stores.clear();
        jsonStores.forEach((e) {
          final store = Store.fromJson(e);
          final km = _distance.as(LengthUnit.Kilometer,
              LatLng(store.lat!, store.lng!), LatLng(lat, lng));
          store.km = km;
          stores.add(store);
        });
        //  isLoading = false;
        // });
        print('fetch 완료');

        return stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).toList()
          ..sort((a, b) => a.km!.compareTo(b.km!));
        // ..을 쓰고 sort를 쓰면 결과가 리턴됨.
      } else {
        return [];
      }
    } catch(e) {
      return [];
    }
  }
}
