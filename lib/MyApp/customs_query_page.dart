import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';  // 用于MD5签名

class CustomsQueryPage extends StatefulWidget {
  @override
  _CustomsQueryPageState createState() => _CustomsQueryPageState();
}

class _CustomsQueryPageState extends State<CustomsQueryPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNoController = TextEditingController();

  Future<void> _submitQuery() async {
    if (_formKey.currentState!.validate()) {
      // 获取当前时间
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> data = {
        "o_business_no": _businessNoController.text,
      };

      // 创建签名
      String sign = generateMd5Sign(data);

      Map<String, dynamic> requestBody = {
        "app_key": "mh_9dd10e1f1f140170",
        "timestamp": timestamp,
        "v": "1.0",
        "sign_method": "MD5",
        "sign": "123456",  // 根据示例中的固定值
        "data": data
      };

      // 发送请求
      final response = await http.post(
          Uri.parse('https://cbec-studapi.gzport.net/api/access_service/get_apply_service'),
          headers: {
            "Content-Type": "application/json"
          },
          body: json.encode(requestBody)
      );

      // 处理响应
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("查询成功"),
                content: SingleChildScrollView(
                  child: Text("业务信息: ${json.encode(responseData['data'])}"),
                ),
                actions: [
                  TextButton(
                    child: Text("确定"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("查询海关申报"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _businessNoController,
                  decoration: InputDecoration(labelText: "业务流水号"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入业务流水号";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitQuery,
                  child: Text("提交查询"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
