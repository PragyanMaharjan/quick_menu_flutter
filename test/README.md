# Test Folder Organization

This document describes the complete organization of the test folder structure for the Quick Menu Flutter application.

## Folder Structure Overview

```
test/
├── core/                          # Core functionality tests (existing)
│   ├── api/                       # API endpoint tests
│   ├── error/                     # Error handling tests
│   └── utils/                     # Core utility tests
│       ├── date_helper_test.dart
│       ├── string_helper_test.dart
│       └── validators_test.dart
│
├── features/                      # Feature-based tests (existing)
│   ├── auth/                      # Authentication feature tests
│   │   ├── data/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   │       ├── login_usecase_test.dart
│   │   │       ├── register_usecase_test.dart
│   │   │       ├── logout_usecase_test.dart
│   │   │       ├── get_current_usecase_test.dart
│   │   │       └── upload_user_photo_usecase_test.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       └── view_model/
│   ├── dashboard/
│   │   ├── domain/usecases/
│   │   └── presentation/pages/
│   ├── menu/
│   │   ├── domain/usecases/
│   │   └── presentation/
│   └── splash/
│       └── presentation/pages/
│
├── unit_tests/                    # Unit tests for utilities
│   └── utils/
│       ├── string_utils_test.dart    # (10 tests)
│       ├── number_utils_test.dart    # (2 tests)
│       ├── list_utils_test.dart      # (3 tests)
│       ├── date_utils_test.dart      # (3 tests)
│       └── map_utils_test.dart       # (2 tests)
│
├── usecase_tests/                 # Domain use case tests
│   ├── auth/
│   │   └── auth_usecase_test.dart    # Login, Register, Logout, GetCurrentUser, UploadPhoto (10 tests)
│   ├── cart/
│   │   └── cart_usecase_test.dart    # Add, Get, Remove cart operations (3 tests)
│   ├── favorites/
│   │   └── favorites_usecase_test.dart  # Get, Add, Remove, IsFavorite (4 tests)
│   ├── menu/
│   │   └── menu_item_usecase_test.dart  # Get menu items (2 tests)
│   ├── offers/
│   │   └── offers_usecase_test.dart     # Get, Apply offers (4 tests)
│   ├── order/
│   │   └── order_usecase_test.dart      # Create, Get orders (2 tests)
│   ├── payment/
│   │   └── payment_usecase_test.dart    # Process payments (2 tests)
│   └── user/
│       └── user_profile_usecase_test.dart  # Get, Update profile (3 tests)
│
├── viewmodel_tests/               # Presentation layer ViewModel tests
│   ├── auth/
│   │   └── auth_viewmodel_test.dart     # Auth state management (7 tests)
│   ├── cart/
│   │   └── cart_viewmodel_test.dart     # Cart state management (3 tests)
│   ├── favorites/
│   │   └── favorites_viewmodel_test.dart  # Favorites state (5 tests)
│   ├── menu/
│   │   └── menu_viewmodel_test.dart     # Menu state management (3 tests)
│   ├── offers/
│   │   └── offers_viewmodel_test.dart   # Offers state management (5 tests)
│   ├── order/
│   │   └── order_viewmodel_test.dart    # Order state management (3 tests)
│   ├── payment/
│   │   └── payment_viewmodel_test.dart  # Payment state management (3 tests)
│   └── profile/
│       └── profile_viewmodel_test.dart  # Profile state management (3 tests)
│
├── integration_tests/             # Integration & Repository tests
│   └── repository/
│       ├── auth_repository_integration_test.dart         # (3 tests)
│       ├── cart_repository_integration_test.dart         # (5 tests)
│       ├── coupon_repository_integration_test.dart       # (3 tests)
│       ├── menu_repository_integration_test.dart         # (3 tests)
│       ├── notification_repository_integration_test.dart # (3 tests)
│       ├── order_repository_integration_test.dart        # (3 tests)
│       ├── payment_repository_integration_test.dart      # (3 tests)
│       ├── profile_repository_integration_test.dart      # (3 tests)
│       ├── search_repository_integration_test.dart       # (4 tests)
│       └── table_repository_integration_test.dart        # (4 tests)
│
├── widget_tests/                  # Widget & UI tests
│   ├── auth/
│   │   └── login_form_widget_test.dart       # (3 tests)
│   ├── cart/
│   │   └── cart_item_widget_test.dart        # (4 tests)
│   ├── coupon/
│   │   └── coupon_card_widget_test.dart      # (4 tests)
│   ├── menu/
│   │   └── menu_item_card_widget_test.dart   # (3 tests)
│   ├── order/
│   │   ├── order_type_selector_widget_test.dart  # (3 tests)
│   │   └── order_status_widget_test.dart         # (5 tests)
│   ├── payment/
│   │   └── payment_method_selector_widget_test.dart  # (4 tests)
│   ├── profile/
│   │   └── profile_card_widget_test.dart     # (4 tests)
│   ├── search/
│   │   └── search_bar_widget_test.dart       # (4 tests)
│   └── table/
│       └── qr_scanner_button_widget_test.dart  # (4 tests)
│
├── TEST_SUMMARY.md                # Test summary documentation
└── README.md                      # This file
```

## Test Categories

### 1. Core Tests (`test/core/`)

**Purpose**: Test core infrastructure and utilities that are used across the entire app.

**Contains**:

- API endpoint tests
- Error handling (Failure classes)
- Core utilities (validators, date helpers, string helpers)

**When to add tests here**: When creating new core utilities, error types, or API configurations.

---

### 2. Feature Tests (`test/features/`)

**Purpose**: Mirror the `lib/features/` structure for feature-specific tests following Clean Architecture.

**Structure**: Each feature follows the layered architecture:

- `data/` - Data layer tests (repositories, data sources, models)
- `domain/` - Domain layer tests (entities, use cases)
- `presentation/` - Presentation layer tests (pages, view models, widgets)

**When to add tests here**: When adding new features or modifying existing feature implementations.

---

### 3. Unit Tests (`test/unit_tests/`)

**Purpose**: Test isolated utility functions and helper methods.

**Total**: 20 tests

- String utilities: capitalization, validation, formatting
- Number utilities: currency formatting, percentages
- List utilities: uniqueness, chunking
- Date utilities: date comparisons, formatting
- Map utilities: merging, validation

**When to add tests here**: When creating new utility functions that don't depend on external services.

---

### 4. Use Case Tests (`test/usecase_tests/`)

**Purpose**: Test business logic use cases in isolation from data sources and UI.

**Total**: 30 tests organized by feature

- **auth/**: Login, Register, Logout, GetCurrentUser, UploadPhoto
- **cart/**: Add, Get, Remove cart items
- **favorites/**: Get, Add, Remove favorites
- **menu/**: Get menu items, filters
- **offers/**: Get available offers, apply offers
- **order/**: Create orders, get order history
- **payment/**: Process payments, transaction history
- **user/**: Get profile, update profile

**When to add tests here**: When creating new business logic or modifying existing use cases.

---

### 5. ViewModel Tests (`test/viewmodel_tests/`)

**Purpose**: Test presentation logic and state management using Riverpod StateNotifier.

**Total**: 32 tests organized by feature

- **auth/**: Authentication state, login/logout flows
- **cart/**: Cart state, add/remove items
- **favorites/**: Favorites state management
- **menu/**: Menu loading and filtering
- **offers/**: Offers state, apply offer logic
- **order/**: Order state transitions
- **payment/**: Payment processing states
- **profile/**: Profile loading and updates

**When to add tests here**: When creating new view models or modifying state management logic.

---

### 6. Integration Tests (`test/integration_tests/`)

**Purpose**: Test integration between layers, especially repository implementations with data sources.

**Total**: 34 tests for 10 repositories

- Tests both online (remote) and offline (local) scenarios
- Tests data synchronization between remote and local storage
- Tests error handling across layers

**When to add tests here**: When creating repositories or testing data flow between layers.

---

### 7. Widget Tests (`test/widget_tests/`)

**Purpose**: Test UI components, user interactions, and widget behavior.

**Total**: 38 tests organized by feature

- Login forms, authentication flows
- Menu item displays, cart operations
- Order type selection, status displays
- Payment method selection
- Profile displays, QR scanning
- Search functionality, coupon cards

**When to add tests here**: When creating new widgets or modifying UI components.

---

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Categories

```bash
# Unit tests only
flutter test test/unit_tests/

# Use case tests only
flutter test test/usecase_tests/

# ViewModel tests only
flutter test test/viewmodel_tests/

# Integration tests only
flutter test test/integration_tests/

# Widget tests only
flutter test test/widget_tests/

# Existing feature tests
flutter test test/features/
flutter test test/core/
```

### Run Specific Feature Tests

```bash
# Auth related tests
flutter test test/usecase_tests/auth/
flutter test test/viewmodel_tests/auth/
flutter test test/widget_tests/auth/

# Cart related tests
flutter test test/usecase_tests/cart/
flutter test test/viewmodel_tests/cart/
flutter test test/widget_tests/cart/
```

### Run With Coverage

```bash
flutter test --coverage
```

### View Coverage Report

```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser (Windows)
start coverage/html/index.html
```

---

## Test Naming Conventions

### File Names

- Unit tests: `{utility_name}_test.dart`
- Use case tests: `{feature}_usecase_test.dart`
- ViewModel tests: `{feature}_viewmodel_test.dart`
- Widget tests: `{widget_name}_widget_test.dart`
- Integration tests: `{feature}_repository_integration_test.dart`

### Test Names

- Use descriptive names that explain what is being tested
- Format: `should {expected behavior} when {condition}`
- Examples:
  - `'should login user successfully'`
  - `'should return failure when email is invalid'`
  - `'should emit loading state when fetching data'`

---

## Testing Best Practices

### 1. AAA Pattern

All tests follow the Arrange-Act-Assert pattern:

```dart
test('should login successfully', () async {
  // Arrange - Setup test data and mocks
  when(() => mockRepository.login(email, password))
      .thenAnswer((_) async => Right(userData));

  // Act - Execute the code being tested
  final result = await useCase(email, password);

  // Assert - Verify the outcome
  expect(result, Right(userData));
  verify(() => mockRepository.login(email, password)).called(1);
});
```

### 2. Mock Dependencies

- Use `mocktail` for creating mock objects
- Register fallback values with `registerFallbackValue()` when using `any()` matcher
- Verify mock interactions to ensure methods are called correctly

### 3. Test Both Success and Failure

- Always test both the happy path and error cases
- Test edge cases and boundary conditions
- Test validation logic thoroughly

### 4. Isolation

- Each test should be independent
- Use `setUp()` to initialize fresh instances for each test
- Don't rely on test execution order

### 5. Meaningful Assertions

- Use specific matchers (`isA<Type>()`, `equals()`, etc.)
- Test multiple aspects when relevant (state, properties, mock calls)
- Add helpful failure messages when necessary

---

## Total Test Count

| Category            | Test Count |
| ------------------- | ---------- |
| Unit Tests          | 20         |
| Use Case Tests      | 30         |
| ViewModel Tests     | 32         |
| Integration Tests   | 34         |
| Widget Tests        | 38         |
| **Total New Tests** | **154**    |

**Plus existing tests in**:

- `test/features/` (approximately 13 tests)
- `test/core/` (approximately 4 tests)

**Grand Total**: ~171 tests

---

## Adding New Tests

When adding a new feature to the app, follow this checklist:

1. **Create use case tests** in `test/usecase_tests/{feature}/`
   - Test each use case method
   - Test success and failure scenarios

2. **Create view model tests** in `test/viewmodel_tests/{feature}/`
   - Test state transitions
   - Test all user actions
   - Test error handling

3. **Create widget tests** in `test/widget_tests/{feature}/`
   - Test widget rendering
   - Test user interactions
   - Test different states

4. **Create integration tests** if needed in `test/integration_tests/`
   - Test repository implementations
   - Test data synchronization

5. **Add unit tests** for new utilities in `test/unit_tests/`
   - Test helper functions
   - Test formatters and validators

---

## Continuous Integration

All tests should pass before merging code. Configure your CI/CD pipeline to:

1. Run all tests: `flutter test`
2. Generate coverage report: `flutter test --coverage`
3. Check coverage threshold (aim for >80%)
4. Fail build if any tests fail

---

## Maintenance

### Regular Tasks

- Run tests before committing code
- Update tests when modifying features
- Add tests for bug fixes
- Review and refactor duplicate test code
- Keep test coverage high

### When Refactoring

- Update related test files
- Ensure all tests still pass
- Remove obsolete tests
- Add tests for new edge cases discovered

---

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mocktail Package](https://pub.dev/packages/mocktail)
- [Riverpod Testing](https://riverpod.dev/docs/cookbooks/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
