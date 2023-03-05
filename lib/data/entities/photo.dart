// {
//     "albumId": 2,
//     "id": 81,
//     "title": "error magni fugiat dolorem impedit molestiae illo ullam debitis",
//     "url": "https://via.placeholder.com/600/31a74c",
//     "thumbnailUrl": "https://via.placeholder.com/150/31a74c"
// },

import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;
  bool? isBookmark;

  Photo({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
    this.isBookmark,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
