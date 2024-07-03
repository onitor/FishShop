import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // 用于格式化日期
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';  // 用于MD5签名

class CustomsWaybillInfoPage extends StatefulWidget {
  @override
  _CustomsWaybillInfoPageState createState() => _CustomsWaybillInfoPageState();
}

class _CustomsWaybillInfoPageState extends State<CustomsWaybillInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _waybillNoController = TextEditingController();
  dynamic _waybillInfo;

  Future<void> _submitQuery() async {
    if (_formKey.currentState!.validate()) {
      // 获取当前时间戳
      String timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      Map<String, dynamic> data = {
        "keyword": _waybillNoController.text,
      };

      // 创建签名
      String sign = generateMd5Sign(data);

      Map<String, dynamic> requestBody = {
        "app_key": "mh_9dd10e1f1f140170",
        "timestamp": timestamp,
        "v": "1.0",
        "sign_method": "MD5",
        "sign": sign,
        "data": data
      };

      // 打印请求体以进行调试
      print('Request Body: ${json.encode(requestBody)}');

      // 发送请求
      final response = await http.post(
          Uri.parse('https://cbec-studapi.gzport.net/api/access_service/get_waybill_info'),
          headers: {
            "Content-Type": "application/json"
          },
          body: json.encode(requestBody)
      );

      // 打印响应以进行调试
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // 处理响应
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          setState(() {
            _waybillInfo = responseData['data'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("查询失败: ${responseData['message']}")));
          // 打印详细的错误信息
          print('查询失败: ${responseData['message']}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("请求失败")));
        // 打印详细的错误信息
        print('请求失败: ${response.body}');
      }
    }
  }


  String generateMd5Sign(Map<String, dynamic> params) {
    // 对参数进行排序
    var sortedKeys = params.keys.toList()..sort();
    var sortedParams = Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => params[k]);

    // 拼接参数
    StringBuffer buffer = StringBuffer();
    sortedParams.forEach((key, value) {
      if (value is Map) {
        buffer.write('$key${json.encode(value)}');
      } else {
        buffer.write('$key$value');
      }
    });

    // 计算MD5签名
    var bytes = utf8.encode(buffer.toString());
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  Widget _buildWaybillInfo() {
    if (_waybillInfo == null) {
      return Container();
    }

    if (_waybillInfo is List && _waybillInfo.isEmpty) {
      return Text("未找到物流信息");
    }

    if (_waybillInfo is Map) {
      List<Widget> waybillWidgets = [];
      if (_waybillInfo.containsKey('international')) {
        waybillWidgets.add(Text("国际物流信息:"));
        for (var item in _waybillInfo['international']) {
          waybillWidgets.add(Card(
            child: ListTile(
              title: Text('物流信息: ${item['waybill_info']}'),
              subtitle: Text('物流时间: ${item['waybill_time']}'),
            ),
          ));
        }
      }

      if (_waybillInfo.containsKey('domestic')) {
        waybillWidgets.add(Text("国内物流信息:"));
        for (var item in _waybillInfo['domestic']) {
          waybillWidgets.add(Card(
            child: ListTile(
              title: Text('物流信息: ${item['waybill_info']}'),
              subtitle: Text('物流时间: ${item['waybill_time']}'),
            ),
          ));
        }
      }

      // Add other sections like order_info, exchange_info, tax_info similarly

      return Column(children: waybillWidgets);
    }

    return Text("未知的数据格式");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("物流单号查询"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _waybillNoController,
                  decoration: InputDecoration(labelText: "物流单号"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入物流单号";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitQuery,
                  child: Text("查询"),
                ),
                SizedBox(height: 20),
                _buildWaybillInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
