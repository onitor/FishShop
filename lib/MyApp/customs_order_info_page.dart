import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';  // 用于MD5签名

class CustomsOrderInfoPage extends StatefulWidget {
  @override
  _CustomsOrderInfoPageState createState() => _CustomsOrderInfoPageState();
}

class _CustomsOrderInfoPageState extends State<CustomsOrderInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _orderNoController = TextEditingController();
  Map<String, dynamic>? _orderInfo;

  Future<void> _submitQuery() async {
    if (_formKey.currentState!.validate()) {
      // 获取当前时间戳
      String timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      Map<String, dynamic> data = {
        "keyword": _orderNoController.text,
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
          Uri.parse('https://cbec-studapi.gzport.net/api/access_service/get_order_info'),
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
            if (responseData['data'] is Map<String, dynamic>) {
              _orderInfo = responseData['data'];
            } else {
              _orderInfo = null; // 如果 data 不是 Map，则设置为 null
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("查询失败: ${responseData['message']}")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("请求失败")));
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

  Widget _buildOrderInfo() {
    if (_orderInfo == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text("没有找到订单信息"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("订单号: ${_orderInfo!['order_no']}"),
        Text("支付方式: ${_orderInfo!['pay_type']}"),
        Text("物流公司: ${_orderInfo!['waybill_ent']}"),
        Text("快递单号: ${_orderInfo!['waybill_no']}"),
        Text("下单时间: ${_orderInfo!['create_time']}"),
        Text("发货时间: ${_orderInfo!['delivery_time']}"),
        Text("商品信息:"),
        ...(_orderInfo!['goods'] as List).map((item) {
          return ListTile(
            title: Text("商品名称: ${item['good_name']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("规格: ${item['good_attr']}"),
                Text("数量: ${item['num']}"),
                Text("单位: ${item['unit']}"),
                Text("币种: ${item['currency']}"),
                Text("单价: ${item['platform_price']}"),
                Text("总价: ${item['platform_money']}"),
                Text("贷款金额: ${item['payment_goods']}"),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单信息查询"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _orderNoController,
                  decoration: InputDecoration(labelText: "订单号"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入订单号";
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
                _buildOrderInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
