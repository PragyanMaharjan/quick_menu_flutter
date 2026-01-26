import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String value;
  final String icon;
  final String title;
  final String subtitle;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const PaymentMethodWidget({
    super.key,
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: groupValue == value
            ? const Color(0xFFE05757).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: groupValue == value
              ? const Color(0xFFE05757)
              : Colors.grey.shade200,
          width: groupValue == value ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(value),
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
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: const Color(0xFFE05757),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
