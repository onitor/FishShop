import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import 'database_helper.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final DatabaseHelper db = DatabaseHelper();
  List<Map<String, String>> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _insertInitialProducts();
  }

  Future<void> _loadProducts() async {
    List<Map<String, dynamic>> loadedProducts = await db.fetchOrders();
    setState(() {
      products = loadedProducts.map((item) => item.map((key, value) => MapEntry(key, value.toString()))).toList();
    });
  }

  Future<void> _insertInitialProducts() async {
    // 仅在数据库为空时插入初始数据
    if (products.isEmpty) {
      List<Map<String, String>> initialProducts = List.generate(10, (index) {
        return {
          'orderId': '${index + 1}',
          'productName': '二手数码产品 ${index + 1}',
          'status': '待处理',
          'image': index % 2 == 0 ? 'assets/phone.jpg' : 'assets/computer.jpg',
          'brand': index % 2==0 ?'苹果':'拯救者',
          'price': '${(index + 1) * 100}',
          'original_price': '${(index + 1) * 200}',
        };
      });

      for (var product in initialProducts) {
        await db.insertOrder(product);
      }
      _loadProducts();
    }
  }

  Future<void> _insertProduct() async {
    Map<String, String> newProduct = {
      'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
      'productName': '新商品',
      'status': '待处理',
      'image': 'assets/phone.jpg', // 示例图片路径
      'brand': '品牌A',
      'price': '100',
      'original_price': '200'
    };
    await db.insertOrder(newProduct);
    _loadProducts();
  }

  Future<void> _updateProduct(int id) async {
    Map<String, String> updatedProduct = {
      'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
      'productName': '更新商品',
      'status': '已处理',
      'image': 'assets/computer.jpg', // 示例图片路径
      'brand': '品牌B',
      'price': '150',
      'original_price': '250'
    };
    await db.updateOrder(id, updatedProduct);
    _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    await db.deleteOrder(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '商品陈列',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 一行两个
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // 控制每个网格项的高宽比
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      product: products[index],
                    ),
                  ),
                );
              },
              child: SingleChildScrollView( // 包裹内容以防止溢出
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          products[index]['image']!,
                          width: double.infinity,
                          height: 180, // 增加图片高度
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index]['productName']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // 减小文字字号
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              products[index]['brand']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12, // 减小文字字号
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '¥${products[index]['price']}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // 减小文字字号
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '¥${products[index]['original_price']}',
                              style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12, // 减小文字字号
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _updateProduct(int.parse(products[index]['id']!)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteProduct(int.parse(products[index]['id']!)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertProduct,
        child: Icon(Icons.add),
      ),
    );
  }
}
