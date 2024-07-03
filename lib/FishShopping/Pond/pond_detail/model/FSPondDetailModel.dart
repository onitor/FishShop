import 'package:codes/FishShopping/Pond/list/model/FSPondPieceModel.dart';
class FSPondDetailModel {
  // 定义属性
  final String id;
  final String avatar;
  final String name;
  final String hotCount;
  final String topicCount;

  // 构造函数
  FSPondDetailModel({
    required this.id,
    required this.avatar,
    required this.name,
    required this.hotCount,
    required this.topicCount,
  });

  // 工厂构造函数，用于从 JSON 初始化
  factory FSPondDetailModel.fromJSON(Map<String, dynamic> json) {
    return FSPondDetailModel(
      id: json['id'],
      avatar: json['avatar'],
      name: json['name'],
      hotCount: json['hotCount'],
      topicCount: json['topicCount'],
    );
  }

  // 辅助方法，用于从 FSPondPieceModel 转换
  factory FSPondDetailModel.fromPieceModel(FSPondPieceModel pieceModel) {
    return FSPondDetailModel(
      id: '',
      avatar: pieceModel.userAvatar ?? '',
      name: pieceModel.userName ?? '',
      hotCount: pieceModel.likeCount ?? '0',
      topicCount: pieceModel.commentCount ?? '0',
    );
  }
}
