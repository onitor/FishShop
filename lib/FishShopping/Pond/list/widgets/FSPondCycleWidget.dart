
import 'package:codes/FishShopping/Pond/list/model/FSPondCycleModel.dart';
import 'package:flutter/material.dart';

class FSPondCycleWidget extends StatelessWidget {
  
  FSPondCycleWidget(this.model);
  
  final FSPondCycleModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.url != null)
            Image.network(model.url!),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ID: ${model.id ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Type: ${model.type ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}