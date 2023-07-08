import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String uid;
  final String postUrl;
  final String postId;
  final datePublished;
  final String description;
  final String profImage;
  final likes;

  const Post({
    required this.username,
    required this.uid,
    required this.postUrl,
    required this.postId,
    required this.datePublished,
    required this.description,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "postUrl": postUrl,
        "postId": postId,
        "datePublished": datePublished,
        "description": description,
        "profImage": profImage,
        "likes": likes
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        postUrl: snapshot['postUrl'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        description: snapshot['description'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes']);
  }
}
