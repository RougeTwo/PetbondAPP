class ChatMessageModel {
  int id;
  String message;
  bool isRead;
  int senderId;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.isRead,
    required this.senderId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      message: json['message'],
      isRead: json['is_read'] == 1 ? true : false,
      senderId: json['sender_id'],
    );
  }
}
