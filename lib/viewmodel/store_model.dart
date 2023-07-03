import 'package:flutter/foundation.dart';
import 'package:flutter_mask/repository/store_repository.dart';
import 'package:geolocator/geolocator.dart';

import '../model/store.dart';
import '../repository/location_repository.dart';

// 가볍게는 상속했다 생각해도 무방함
// 중간 다리 역할
class StoreModel with ChangeNotifier {
  var isLoading = false;

  // 데이터를 받아주는 리스트 변수
  List<Store> stores = [];

  final _storeRepository = StoreRepository();
  final _locationRepository = LocationRepository();

  // 기본 생성자에서 호출해야 데이터 나옴
  StoreModel() {
    fetch();
  }

  Future fetch() async {
    isLoading = true;
    // 트루 알리고 통지
    notifyListeners();

    Position position = await _locationRepository.getCurrentLocation();

    stores = await _storeRepository.fetch(position.latitude, position.longitude);
    // 폴스 알리고 통지
    isLoading = false;
    notifyListeners();
  }
}
