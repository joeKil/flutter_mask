// 모델과 뷰모델을 적용 후 더이상 stful이 아니어도 된다.
import 'package:flutter/material.dart';
import 'package:flutter_mask/ui/widget/remain_stat_list_tile.dart';
import 'package:provider/provider.dart';

import '../../model/store.dart';
import '../../viewmodel/store_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // var stores = <Store>[]; -> 뷰모델로 이동
  @override
  Widget build(BuildContext context) {
    final storeModel = Provider.of<StoreModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${storeModel.stores.length}곳'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                // storeRepository.fetch().then((stores) {
                //   setState(() {
                //     stores = stores;
                //   });
                // });
                storeModel.fetch();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: _buildBody(storeModel),
    );
  }

  Widget _buildBody(StoreModel storeModel) {
    if (storeModel.isLoading == true) {
      return loadingWidget();
    }

    if (storeModel.stores.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('반경 5km 이내에 재고가 있는 매장이 없습니다'),
            Text('또는 인터넷이 연결되어 있는지 확인해 주세요'),
          ],
        ),
      );
    }

    return  ListView(
      // children: stores.map((e) => Text(e.name ?? '')).toList(),

      // where는 내가 필요한 것만 걸러낼 수 있게 해준다.
      // 함수 형태로 정리
      children: storeModel.stores.map((e) {
        return RemainStatListTile(e);
      }).toList(),
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
