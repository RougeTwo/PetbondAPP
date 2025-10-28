class ChatModel {
  final int chatId;
  final int advertId;
  final int buyerId;
  final String fullName;
  int unreadMessageCount;
  int messagesCount;

  ChatModel({
    required this.chatId,
    required this.advertId,
    required this.buyerId,
    required this.fullName,
    required this.unreadMessageCount,
    required this.messagesCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chats'][0]['id'],
      advertId: json['chats'][0]['advert_id'],
      buyerId: json['chats'][0]['buyer_id'],
      fullName: json['first_name'] + ' ' + json['last_name'],
      unreadMessageCount: json['chats'][0]['unread_messages_count'],
      messagesCount: json['chats'][0]['messages_count'],
    );
  }
}
