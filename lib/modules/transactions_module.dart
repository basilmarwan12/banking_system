class Transactions {
  int? transactionId;
  int senderId;
  int receiverId;
  String senderName;
  String receiverName;
  String transactionDate;
  double amount;
  Transactions(
      {this.transactionId,
      required this.senderId,
      required this.receiverId,
      required this.senderName,
      required this.receiverName,
      required this.transactionDate,
      required this.amount});
  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
      senderId: json['senderId'] as int,
      receiverId: json['receiverId'] as int,
      amount: json['balance'] as double,
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      transactionDate: json['transactionTime'],
      transactionId: json['transactionId'] as int);

  static List<Transactions> fromJsonList(List<dynamic> jsonList) {
    try {
      return jsonList.map((json) => Transactions.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
