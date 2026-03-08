import 'package:flutter/material.dart';
import '../../../../core/utils/snackbar_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import 'package:quick_menu/core/providers/order_type_provider.dart';
import 'package:quick_menu/core/providers/table_provider.dart';
import 'package:quick_menu/features/payment/data/repositories/order_repository_impl.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final OrderItem order;

  const PaymentPage({super.key, required this.order});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String selectedPaymentMethod = 'card';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...widget.order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.name} x${item.quantity}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            'Rs. ${item.price}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        'Rs. ${widget.order.totalAmount * 0.95}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tax',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        'Rs. ${(widget.order.totalAmount * 0.05).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade300, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs. ${widget.order.totalAmount}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE05757),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment Methods
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                    'esewa',
                    '💰',
                    'eSewa',
                    'Digital wallet payment',
                  ),
                  _buildPaymentOption(
                    'khalti',
                    '📱',
                    'Khalti',
                    'Quick digital payment',
                  ),
                  _buildPaymentOption(
                    'card',
                    '💳',
                    'Credit/Debit Card',
                    'Visa, Mastercard',
                  ),
                  _buildPaymentOption(
                    'cash',
                    '💵',
                    'Cash Payment',
                    'Pay at counter',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pay Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE05757),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isProcessing ? null : _processPayment,
                child: isProcessing
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Pay Rs. ${widget.order.totalAmount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String icon,
    String title,
    String subtitle,
  ) {
    final isSelected = selectedPaymentMethod == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFE05757).withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFE05757) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => selectedPaymentMethod = value),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFE05757)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Container(
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE05757),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    // Special handling for cash payment
    if (selectedPaymentMethod == 'cash') {
      _showCashPaymentDialog();
      return;
    }

    setState(() => isProcessing = true);

    try {
      // Convert OrderItem to the format expected by repository
      final orderItems = widget.order.items.map((item) {
        return {
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
        };
      }).toList();

      // Submit order using offline-first repository
      final orderRepository = ref.read(orderRepositoryProvider);
      final tableId = ref.read(tableIdProvider);
      final orderType = ref.read(orderTypeProvider);
      final result = await orderRepository.submitOrder(
        orderItems,
        widget.order.totalAmount,
        tableId: tableId,
        orderType: orderType?.displayName,
      );

      await result.fold(
        (failure) {
          // Handle failure
          SnackBarUtils.showSnackBar(
            context,
            'Order saved locally. Will sync when online.',
          );
        },
        (order) {
          // Handle success
          final paymentMethodName = selectedPaymentMethod == 'esewa'
              ? 'eSewa'
              : selectedPaymentMethod == 'khalti'
              ? 'Khalti'
              : 'Card';
          SnackBarUtils.showSnackBar(
            context,
            'Payment via $paymentMethodName successful! Order ${order.isSynced ? 'submitted' : 'saved locally'}.',
          );
        },
      );

      // Clear cart after successful order
      _clearCart();

      // Check if table is not set and ask for order type
      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () async {
          if (mounted) {
            final tableId = ref.read(tableIdProvider);
            if (tableId == null) {
              // Show order type dialog
              await _showOrderTypeDialog();
            }
            if (mounted) {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/thank-you',
                arguments: widget.order,
              );
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showSnackBar(
          context,
          'Payment failed. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  void _showCashPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(children: [const Text('💵 '), const Text('Cash Payment')]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please proceed to the counter to complete your cash payment.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${widget.order.totalAmount}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE05757),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Your order will be confirmed at the counter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05757),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                // Submit order and clear cart
                await _submitCashOrder();
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitCashOrder() async {
    setState(() => isProcessing = true);

    try {
      final orderItems = widget.order.items.map((item) {
        return {
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
        };
      }).toList();

      final orderRepository = ref.read(orderRepositoryProvider);
      final tableId = ref.read(tableIdProvider);
      final orderType = ref.read(orderTypeProvider);
      final result = await orderRepository.submitOrder(
        orderItems,
        widget.order.totalAmount,
        tableId: tableId,
        orderType: orderType?.displayName,
      );

      await result.fold(
        (failure) {
          SnackBarUtils.showSnackBar(
            context,
            'Order saved. Please pay at counter.',
          );
        },
        (order) {
          SnackBarUtils.showSnackBar(
            context,
            'Order confirmed! Please pay Rs. ${widget.order.totalAmount} at counter.',
          );
        },
      );

      // Clear cart after successful order
      _clearCart();

      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () async {
          if (mounted) {
            final tableId = ref.read(tableIdProvider);
            if (tableId == null) {
              // Show order type dialog
              await _showOrderTypeDialog();
            }
            if (mounted) {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/thank-you',
                arguments: widget.order,
              );
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showSnackBar(
          context,
          'Order submission failed. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  Future<void> _showOrderTypeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must select an option
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Order Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'How would you like to receive your order?',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Dine-In Option
              _buildOrderTypeButton(
                context: context,
                orderType: OrderType.dineIn,
                title: 'Dine-In',
                subtitle: 'Eat at restaurant',
                icon: Icons.restaurant,
                color: const Color(0xFFE05757),
              ),
              const SizedBox(height: 12),
              // Takeaway Option
              _buildOrderTypeButton(
                context: context,
                orderType: OrderType.takeaway,
                title: 'Takeaway',
                subtitle: 'Pick up yourself',
                icon: Icons.shopping_bag,
                color: const Color(0xFFF7971E),
              ),
              const SizedBox(height: 12),
              // Delivery Option
              _buildOrderTypeButton(
                context: context,
                orderType: OrderType.delivery,
                title: 'Delivery',
                subtitle: 'Deliver to address',
                icon: Icons.delivery_dining,
                color: Colors.blue,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderTypeButton({
    required BuildContext context,
    required OrderType orderType,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        ref.read(orderTypeProvider.notifier).state = orderType;

        // If dine-in is selected, ask for table number
        if (orderType == OrderType.dineIn) {
          Navigator.pop(context);
          _showTableNumberDialog();
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  void _showTableNumberDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.table_restaurant, color: Color(0xFFE05757)),
              SizedBox(width: 8),
              Text('Enter Table Number'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter your table number:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Table Number',
                  hintText: 'e.g., 5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05757),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final tableNumber = controller.text.trim();
                if (tableNumber.isNotEmpty) {
                  ref.read(tableIdProvider.notifier).state = tableNumber;
                  Navigator.pop(context);
                } else {
                  SnackBarUtils.showSnackBar(
                    context,
                    'Please enter a valid table number',
                  );
                }
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearCart() {
    // Clear the cart using the cart provider
    ref.read(cartProvider.notifier).clearCart();
  }
}

class OrderItem {
  final String id;
  final List<OrderItemDetail> items;
  final double totalAmount;
  final String status;
  final DateTime orderDate;

  OrderItem({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
  });
}

class OrderItemDetail {
  final String name;
  final int quantity;
  final double price;

  OrderItemDetail({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
