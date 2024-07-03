import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // 用于格式化日期
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';  // 用于MD5签名
import 'package:flutter/services.dart';  // 用于剪贴板操作

class CustomsDeclarationPage extends StatefulWidget {
  @override
  _CustomsDeclarationPageState createState() => _CustomsDeclarationPageState();
}

class _CustomsDeclarationPageState extends State<CustomsDeclarationPage> {
  final _formKey = GlobalKey<FormState>();
  final _ebcNameController = TextEditingController();
  final _platformNameController = TextEditingController();
  final _contractNoController = TextEditingController();
  DateTime _settleDate = DateTime.now();
  String _dealCurr = '美元';
  String _priceTerm = 'FOB';

  Future<void> _submitDeclaration() async {
    if (_formKey.currentState!.validate()) {
      // 获取当前时间
      String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      Map<String, dynamic> requestBody = {
        "app_key": "mh_9dd10e1f1f140170",
        "timestamp": timestamp,
        "v": 1.0,
        "sign_method": "MD5",
        "sign": "123456",
        "data": {
          "service_info": {
            "o_business_no": "",
            "type": 1,
            "o_business_type": "9610",
            "o_business_name": "2024052802批次零售出口",
            "o_ebc_name": "广州市韩星电子商务有限公司",
            "o_trading_mall_link": "https://cbec-mall.gzport.net/",
            "o_ebp_name": "CHEEHON CO.,LTD",
            "o_platform_buyer": "CHEEHON CO.,LTD",
            "o_supply_name": "东莞伟星服装厂",
            "o_declare_name": "广州伟星电子商务有限公司",
            "o_logistics_name": "广州伟星运输有限公司",
            "o_transport_name": "深圳市货拉拉运输有限公司",
            "o_transport_abroad_name": "深伟星国际货运代理有限公司",
            "o_pay_name": "招商银行股份有限公司"
          },
          "service_base_info": {
            "o_export_contract": "ECK202405280002",
            "o_deal_curr": "美元",
            "o_price_term": "FOB",
            "o_freight_fee": "0",
            "o_insurance_fee": "0",
            "o_settle_date": "2024-05-31",
            "o_ebc_name": "广州市韩星电子商务有限公司",
            "o_ebc_ename": "HANXING",
            "o_ebc_contact": "Haixian Zou",
            "o_ebc_contact_tell": "+86-15521994918",
            "o_ebc_address": "广州市海珠区仑头路21号",
            "o_ebc_eaddress": "21 Luntou Road, Haizhu District, Guangzhou City",
            "o_plat_name": "CHEEHON CO.,LTD",
            "o_plat_ename": "CHEEHON CO.,LTD",
            "o_plat_contact": "SUSAN",
            "o_plat_contact_tell": "001-202-495-2266",
            "o_plat_address": "",
            "o_plat_eaddress": "3505 International Place,N.W. Washington,D.C.20008 U.S.A.",
            "o_special": "0",
            "o_ship_date": "2024-05-27",
            "o_pack_way": "4",
            "o_ship_way": "4",
            "o_ship_port": "广州",
            "o_country": "美国",
            "o_country_port": "华盛顿",
            "o_export_note": ""
          },
          "order_info": [
            {
              "o_order_no": "20240528000002",
              "o_pay_no": "P20240528000002",
              "o_waybill_no": "SF20240528000002",
              "o_charge": "100",
              "o_goods_value": "100",
              "o_currency": "502",
              "o_accounting_date": "20240528121312",
              "o_traf_mode": 5,
              "o_country": "502",
              "o_order_note": "",
              "order_goods_info": [
                {
                  "o_classification": "衣服",
                  "o_goods_ename": "dress",
                  "o_goods_cname": "连衣裙",
                  "o_goods_sku": "SP00001",
                  "o_goods_num": "1",
                  "o_goods_price": "100",
                  "o_goods_total": 100,
                  "o_goods_link": "http:// xxxx.com/....",
                  "o_goods_enterprice": "广州市XXX服装有限公司",
                  "o_goods_ingrediant": "棉100%",
                  "o_goods_note": ""
                }
              ]
            }
          ]
        }
      };

      // 发送请求
      final response = await http.post(
          Uri.parse('https://cbec-studapi.gzport.net/api/access_service/apply_service'),
          headers: {
            "Content-Type": "application/json"
          },
          body: json.encode(requestBody)
      );

      // 处理响应
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          var businessNo = responseData['data'] != null ? responseData['data']['business_no'] ?? '未知业务号' : '未知业务号';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("申报成功"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("业务号: $businessNo"),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: businessNo));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("业务号已复制到剪贴板"))
                        );
                      },
                      child: Text("复制业务号"),
                    ),
                  ],
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("申报失败: ${responseData['message']}")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("请求失败")));
      }
    }
  }

  String generateMd5Sign(Map<String, dynamic> params, String secret) {
    // 对参数进行排序
    var sortedKeys = params.keys.toList()..sort();
    var sortedParams = Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => params[k]);

    // 拼接参数
    StringBuffer buffer = StringBuffer(secret);
    sortedParams.forEach((key, value) {
      buffer.write('$key$value');
    });
    buffer.write(secret);

    // 计算MD5签名
    var bytes = utf8.encode(buffer.toString());
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("申报海关"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _ebcNameController,
                  decoration: InputDecoration(labelText: "出口企业名称"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入出口企业名称";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _platformNameController,
                  decoration: InputDecoration(labelText: "平台企业名称"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入平台企业名称";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contractNoController,
                  decoration: InputDecoration(labelText: "出口合同编号"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "请输入出口合同编号";
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text("最迟结算日期"),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(_settleDate)),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _settleDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != _settleDate) {
                      setState(() {
                        _settleDate = pickedDate;
                      });
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _dealCurr,
                  items: ['美元', '人民币', '欧元'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _dealCurr = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: "成交币种"),
                ),
                DropdownButtonFormField<String>(
                  value: _priceTerm,
                  items: ['FOB', 'CIF', 'C&F'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _priceTerm = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: "价格条款"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitDeclaration,
                  child: Text("提交申报"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
