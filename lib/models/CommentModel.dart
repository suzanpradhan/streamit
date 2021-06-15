class CommentModel {
  int? author;
  String? author_name;
  String? author_url;
  Content? content;
  String? date;
  String? date_gmt;
  int? id;
  String? link;
  int? parent;
  int? post;
  String? commentData;

  //local
  bool isAddReply;

  CommentModel({
    this.author,
    this.author_name,
    this.author_url,
    this.content,
    this.date,
    this.date_gmt,
    this.id,
    this.link,
    this.parent,
    this.post,
    this.isAddReply = false,
    this.commentData,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      author: json['author'],
      author_name: json['author_name'],
      author_url: json['author_url'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      date: json['date'],
      date_gmt: json['date_gmt'],
      id: json['id'],
      link: json['link'],
      parent: json['parent'],
      post: json['post'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['author_name'] = this.author_name;
    data['author_url'] = this.author_url;
    data['date'] = this.date;
    data['date_gmt'] = this.date_gmt;
    data['id'] = this.id;
    data['link'] = this.link;
    data['parent'] = this.parent;
    data['post'] = this.post;
    if (this.commentData != null) {
      data['content'] = this.commentData;
    }
    return data;
  }
}

class Content {
  String? rendered;

  Content({this.rendered});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    return data;
  }
}
