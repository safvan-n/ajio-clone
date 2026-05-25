import 'package:flutter_test/flutter_test.dart';
import 'package:ajio_clone/main.dart';

void main() {
  testWidgets('AJIO Brand Header Smoke Test', (WidgetTester tester) async {
    // Build our AJIO Clone app and trigger a frame.
    await tester.pumpWidget(const AjioCloneApp());

    // Verify that the brand title 'A J I O' exists in the header.
    expect(find.text('A J I O'), findsOneWidget);
  });
}
