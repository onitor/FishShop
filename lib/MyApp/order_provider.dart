import 'package:flutter/material.dart';

class OrderProvider extends InheritedWidget {
  final OrderState data;

  OrderProvider({required Widget child})
      : data = OrderState(),
        super(child: child);

  static OrderState of(BuildContext context) {
    final OrderProvider? result = context.dependOnInheritedWidgetOfExactType<OrderProvider>();
    assert(result != null, 'No OrderProvider found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(OrderProvider oldWidget) {
    return true;
  }
}

class OrderState extends ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  void addOrder(Map<String, dynamic> order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(Map<String, dynamic> order) {
    _orders.remove(order);
    notifyListeners();
  }
}
