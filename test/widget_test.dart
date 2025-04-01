// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vet_reports_app/main.dart';
import 'mocks.dart';

void main() {
  late MockMongoService mockMongoService;
  late MockPdfService mockPdfService;

  setUp(() {
    mockMongoService = MockMongoService();
    mockPdfService = MockPdfService();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(VetReportsApp(
      mongoService: mockMongoService,
      pdfService: mockPdfService,
    ));

    // Verify initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap '+' button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify increment
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}





   

