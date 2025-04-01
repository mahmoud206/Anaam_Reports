import 'package:mockito/annotations.dart';
import 'package:vet_reports_app/core/services/mongo_service.dart';
import 'package:vet_reports_app/core/services/pdf_service.dart';

@GenerateNiceMocks([MockSpec<MongoService>(), MockSpec<PdfService>()])
void main() {}
