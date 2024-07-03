import 'package:flutter/material.dart';
import 'order_provider.dart';
import 'customs_declaration_page.dart';
import 'customs_query_page.dart';
import 'customs_document_upload_page.dart';
import 'customs_waybill_info_page.dart';
import 'customs_order_info_page.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = OrderProvider.of(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('订单'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(order['image'] ?? 'assets/phone.jpg', width: 50, height: 50, fit: BoxFit.cover),
              title: Text(order['name'] ?? '二手手机'),
              subtitle: Text('¥${order['price'] ?? '0'}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  OrderProvider.of(context).removeOrder(order);
                  // 需要调用 setState 来更新 UI
                  (context as Element).markNeedsBuild();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.menu),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('申报海关'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomsDeclarationPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('业务号查询'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomsQueryPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('上传文件'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomsDocumentUploadPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text('物流单号查询'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomsWaybillInfoPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('获取出口订单信息'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomsOrderInfoPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
