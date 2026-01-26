import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import 'package:quick_menu/core/theme/app_colors.dart';
import 'package:quick_menu/features/payment/presentation/pages/payment_page.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/home.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// 🛒 Order Screen - Shopping Cart Management
class OrderScreen extends ConsumerWidget {
  final VoidCallback? onBrowseMenu;

  const OrderScreen({super.key, this.onBrowseMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Modern Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            decoration: BoxDecoration(
              gradient: AppGradients.headerGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🛒 Your Cart",
                          style:
                              Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ) ??
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${cartItems.length} item${cartItems.length != 1 ? 's' : ''}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: cartItems.isEmpty
                ? _buildEmptyCartState(context, ref)
                : _buildCartList(context, ref, cartItems),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE05757).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 50,
              color: Color(0xFFE05757),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Your Cart is Empty",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Add items from the menu\nto get started",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE05757),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.menu_book),
            label: const Text(
              'Browse Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              if (onBrowseMenu != null) {
                onBrowseMenu!();
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(
    BuildContext context,
    WidgetRef ref,
    List<CartItem> cartItems,
  ) {
    final total = ref.read(cartProvider.notifier).getTotalPrice();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartItemCard(context, ref, item);
            },
          ),
        ),
        // Summary and Checkout
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Rs. ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE05757),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE05757)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        ref.read(cartProvider.notifier).clearCart();
                        SnackBarUtils.showSnackBar(context, 'Cart cleared');
                      },
                      child: const Text(
                        'Clear Cart',
                        style: TextStyle(
                          color: Color(0xFFE05757),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE05757),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text(
                        'Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (cartItems.isEmpty) {
                          SnackBarUtils.showSnackBar(
                            context,
                            'Add items to cart before checkout',
                          );
                          return;
                        }

                        // Create OrderItemDetails from cart items
                        final orderDetails = cartItems.map((item) {
                          final price =
                              double.tryParse(
                                item.price.replaceAll('Rs. ', ''),
                              ) ??
                              0.0;
                          return OrderItemDetail(
                            name: item.name,
                            quantity: item.quantity,
                            price: price,
                          );
                        }).toList();

                        // Create order
                        final order = OrderItem(
                          id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
                          items: orderDetails,
                          totalAmount: total,
                          status: 'Pending',
                          orderDate: DateTime.now(),
                        );

                        // Navigate to payment page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(order: order),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    WidgetRef ref,
    CartItem item,
  ) {
    final price = double.tryParse(item.price.replaceAll('Rs. ', '')) ?? 0.0;
    final itemTotal = price * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Item Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE05757).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(item.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. $price each',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(cartProvider.notifier)
                        .updateQuantity(item.id, item.quantity - 1);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove, size: 14),
                  ),
                ),
                Container(
                  width: 30,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(cartProvider.notifier)
                        .updateQuantity(item.id, item.quantity + 1);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Total and Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${itemTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFFE05757),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).removeItem(item.id);
                  SnackBarUtils.showSnackBar(context, '${item.name} removed');
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
