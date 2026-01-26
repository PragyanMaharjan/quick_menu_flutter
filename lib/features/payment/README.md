# Payment Feature

This folder contains all payment-related functionality for the restaurant QR code ordering app.

## Structure

```
payment/
├── presentation/
│   ├── pages/
│   │   ├── payment_page.dart       # Payment method selection and processing
│   │   └── thank_you_screen.dart   # Order confirmation screen
│   ├── widgets/
│   │   └── payment_method_widget.dart  # Reusable payment method selector
│   └── index.dart                  # Export file for clean imports
```

## Features

- **Payment Page**: Display order summary and multiple payment method options
- **Thank You Screen**: Order confirmation with order details and navigation options
- **Payment Methods**: Credit/Debit Card, UPI, Digital Wallet

## Usage

Import the payment feature:

```dart
import 'package:quick_menu/features/payment/presentation/index.dart';
```

Navigate to payment:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PaymentPage(order: order),
  ),
);
```

Navigate to thank you screen:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ThankYouScreen(order: order),
  ),
);
```

## Note

This is a restaurant QR code scanning app, NOT a delivery service. Users scan QR codes to order directly from the restaurant and pick up orders on-site.
