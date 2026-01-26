import 'package:flutter/material.dart';
import '../../../../core/utils/snackbar_utils.dart';

class PaymentPage extends StatefulWidget {
  final OrderItem order;

  const PaymentPage({super.key, required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
                    'card',
                    '💳',
                    'Credit/Debit Card',
                    'Visa, Mastercard, RuPay',
                  ),
                  _buildPaymentOption(
                    'upi',
                    '📱',
                    'UPI',
                    'Google Pay, PhonePe, PayTM',
                  ),
                  _buildPaymentOption(
                    'wallet',
                    '👛',
                    'Digital Wallet',
                    'PayTM, MobiKwik',
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selectedPaymentMethod == value
            ? const Color(0xFFE05757).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedPaymentMethod == value
              ? const Color(0xFFE05757)
              : Colors.grey.shade200,
          width: selectedPaymentMethod == value ? 2 : 1,
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
                Radio<String>(
                  value: value,
                  groupValue: selectedPaymentMethod,
                  onChanged: (val) =>
                      setState(() => selectedPaymentMethod = val!),
                  activeColor: const Color(0xFFE05757),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() => isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => isProcessing = false);
      SnackBarUtils.showSnackBar(
        context,
        'Payment successful via ${_getPaymentMethodName(selectedPaymentMethod)}!',
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/thank-you', arguments: widget.order);
      });
    }
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'card':
        return 'Card';
      case 'upi':
        return 'UPI';
      case 'wallet':
        return 'Wallet';
      default:
        return 'Payment';
    }
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
