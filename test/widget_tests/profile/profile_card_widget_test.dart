import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Profile Card Widget Tests', () {
    final testProfile = UserProfile(
      name: 'John Doe',
      email: 'john@test.com',
      phone: '1234567890',
      avatarUrl: 'avatar.jpg',
    );

    testWidgets('should display user profile information', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProfileCard(profile: testProfile)),
        ),
      );

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@test.com'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('should show edit button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProfileCard(profile: testProfile)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should call onEdit when edit button is tapped', (
      tester,
    ) async {
      // Arrange
      bool wasEditCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileCard(
              profile: testProfile,
              onEdit: () => wasEditCalled = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      // Assert
      expect(wasEditCalled, true);
    });

    testWidgets('should display avatar when available', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProfileCard(profile: testProfile)),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}

// Mock classes
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });
}

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEdit;

  const ProfileCard({Key? key, required this.profile, this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 40, child: Text(profile.name[0])),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(profile.email),
            Text(profile.phone),
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          ],
        ),
      ),
    );
  }
}
