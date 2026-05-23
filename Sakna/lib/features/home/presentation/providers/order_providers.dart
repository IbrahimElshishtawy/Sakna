import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';

class ActiveOrderNotifier extends Notifier<OrderEntity?> {
  @override
  OrderEntity? build() {
    // Initial active order matching the screenshot
    return const OrderEntity(
      id: 'ORD-5829',
      serviceType: 'كهرباء / فني صيانة',
      description: 'جاري في الطريق إليك...',
      arrivalTime: '17:30',
      progress: 0.6,
    );
  }

  void dismissOrder() {
    state = null;
  }

  void resetOrder() {
    state = const OrderEntity(
      id: 'ORD-5829',
      serviceType: 'كهرباء / فني صيانة',
      description: 'جاري في الطريق إليك...',
      arrivalTime: '17:30',
      progress: 0.6,
    );
  }
}

final activeOrderProvider = NotifierProvider<ActiveOrderNotifier, OrderEntity?>(ActiveOrderNotifier.new);
