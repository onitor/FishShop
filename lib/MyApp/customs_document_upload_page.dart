import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';  // 用于MD5签名

class CustomsDocumentUploadPage extends StatefulWidget {
  @override
  _CustomsDocumentUploadPageState createState() => _CustomsDocumentUploadPageState();
}

class _CustomsDocumentUploadPageState extends State<CustomsDocumentUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNoController = TextEditingController();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  String _documentType = 'purchase_contract';

  Future<void> _submitDocument() async {
    if (_formKey.currentState!.validate()) {
      // 获取当前时间戳
      String timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      // 提取文本值
      String businessNo = _businessNoController.text;
      String url = _urlController.text;
      String name = _nameController.text;

      Map<String, dynamic> dataForSign = {
        "type": _documentType,
        "business_no": businessNo,
        "message_list": [
          {
            "url": url,
            "name": name
          }
        ]
      };

      // 创建签名
      String sign = generateMd5Sign(dataForSign);

      Map<String, dynamic> requestBody = {
        "app_key": "mh_9dd10e1f1f140170",
        "timestamp": timestamp,
        "v": "1.0",
        "sign_method": "MD5",
        "sign": sign,
        "data": dataForSign
      };

      // 发送请求
      final response = await http.post(
          Uri.parse('https://cbec-studapi.gzport.net/api/access_service/save_apply_service'),
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
                title: Text("上传成功"),
                content: Text("单证文件上传成功"),
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("上传失败: ${responseData['message']}")));
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
        title: Text("上传单证文件"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _documentType,
                  items: [
                    'purchase_contract',
                    'export_contract',
                    'delivery_note',
                    'declaration_contract',
                    'logistics_contract',
                    'payment_contract',
                    'trade_order_pic',
                    'declaration_info',
                    'release_notice',
                    'declaration_addition',
                    'declaration_draft',
                    'bank_exchange_transaction',
                    'export_detail',
                    'purchase_details',
                    'purchase_invoice',
                    'export_invoice',
                    'logistics_statement',
                    'international_freight_invoice',
                    'international_lading_bill',
                    'other_logistics_details',
                    'tax_refund_notice'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _documentType = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: "文件类型"),
                ),
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
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(labelText: "文件访问地址"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入文件访问地址";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "文件名称"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入文件名称";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitDocument,
                  child: Text("上传文件"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
