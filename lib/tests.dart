import 'package:flutter/material.dart';
import 'package:flutter_test_one/util/toast_util.dart';

class DynamicPaginationDemo extends StatefulWidget {
  @override
  _DynamicPaginationDemoState createState() => _DynamicPaginationDemoState();
}

class _DynamicPaginationDemoState extends State<DynamicPaginationDemo> {
  final List<int> _data = [];
  final int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMoreData) return;
    setState(() {
      _isLoading = true;
    });

    // 模拟网络延迟
    await Future.delayed(Duration(seconds: 2));

    // 模拟 API 返回的数据
    final List<int> fetchedData = List.generate(
        _itemsPerPage, (index) => (_currentPage - 1) * _itemsPerPage + index);
    print("<<123456>>");
    setState(() {
      if (fetchedData.isEmpty) {
        _hasMoreData = false;
      } else {
        _data.addAll(fetchedData);
        _currentPage++;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('动态分页示例')),
        body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoading &&
                  _hasMoreData &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _fetchData();
              }
              return true;
            },
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text("Scroll Offset: toStringAsFixed(1)}"),
                      background: Image.network(
                        "https://via.placeholder.com/350",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ];
              },
              body: Builder(builder: (BuildContext context) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList.builder(
                      itemCount: _data.length + (_hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _data.length) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListTile(title: Text('Item ${_data[index]}'));
                      },
                    ),
                  ],
                );
              }),
            )));
  }
}
