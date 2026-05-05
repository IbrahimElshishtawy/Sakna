class NotificationHandler {
  static void handleNotificationClick(Map<String, dynamic> payload, Function(String route, {Object? arguments}) navigateTo) {
    if (payload.containsKey('type') && payload['type'] == 'order_status') {
      if (payload.containsKey('orderId')) {
        navigateTo('/order_tracking', arguments: {'orderId': payload['orderId']});
      }
    } else if (payload.containsKey('type') && payload['type'] == 'chat_message') {
      if(payload.containsKey('chatId')) {
         navigateTo('/chat', arguments: {'chatId': payload['chatId']});
      }
    }
    // Handle other types...
  }
}
