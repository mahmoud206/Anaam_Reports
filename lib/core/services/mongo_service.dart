import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer' as developer;
import 'dart:async';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  factory MongoService() => _instance;
  MongoService._internal();

  late Db _db;
  bool _isConnected = false;
  String? _currentDatabase;
  DateTime? _lastConnectionAttempt;

  // خرائط أسماء قواعد البيانات (عرض -> حقيقي)
  final Map<String, String> _databaseMapping = {
    'عيادة الأنعام - بيش': 'Elanam-Baish',
    'عيادة الأنعام - خميس مشيط': 'Elanam-KhamisMushit',
    'عيادة الأنعام - الظبية': 'Elanam-Zapia'
  };

  bool get isConnected => _isConnected;
  String? get currentDatabase => _currentDatabase;
  DateTime? get lastConnectionAttempt => _lastConnectionAttempt;

  Future<void> connect(String displayDatabaseName) async {
    try {
      if (!_databaseMapping.containsKey(displayDatabaseName)) {
        throw Exception('Invalid database name');
      }

      await _safeDisconnect();

      _lastConnectionAttempt = DateTime.now();
      final actualDatabaseName = _databaseMapping[displayDatabaseName]!;

      final connectionString =
          'mongodb://vetinternational1968:mahmoud123456@ivc-cluster-shard-00-00.mongodb.net:27017,ivc-cluster-shard-00-01.mongodb.net:27017,ivc-cluster-shard-00-02.mongodb.net:27017/$actualDatabaseName?replicaSet=atlas-abcde-shard-0&ssl=true&authSource=admin';
      _db = Db(connectionString);

      _db = Db(connectionString);

      await _db.open().timeout(
        const Duration(seconds: 30), // Extended timeout
        onTimeout: () => throw TimeoutException('Connection timed out'),
      );

      // Verify the connection with a ping
      final pingResult = await _db.runCommand({'ping': 1});
      if (pingResult['ok'] != 1.0) {
        throw Exception('Connection verification failed');
      }

      _isConnected = true;
      _currentDatabase = displayDatabaseName;

      developer.log('Successfully connected to: $displayDatabaseName', name: 'MongoService');
    } catch (e) {
      await _safeDisconnect();
      developer.log('Connection error: $e', name: 'MongoService');
      throw _translateError(e);
    }
  }


  Future<void> _safeDisconnect() async {
    try {
      if (_isConnected) {
        await _db.close();
      }
    } catch (e) {
      developer.log('خطأ في قطع الاتصال: $e', name: 'MongoService');
    } finally {
      _isConnected = false;
      _currentDatabase = null;
    }
  }

  Exception _translateError(dynamic error) {
    if (error is TimeoutException) {
      return Exception('انتهت مهلة الاتصال. الرجاء التحقق من اتصال الإنترنت');
    } else if (error.toString().contains('Authentication failed')) {
      return Exception('فشل المصادقة. الرجاء التحقق من بيانات الدخول');
    } else if (error.toString().contains('network error')) {
      return Exception('خطأ في الشبكة. الرجاء التحقق من الاتصال');
    }
    return Exception('خطأ غير متوقع: ${error.toString()}');
  }

  List<String> getAvailableDatabases() {
    return _databaseMapping.keys.toList();
  }

  // ============== دوال التقارير الكاملة ==============

  Future<List<Map<String, dynamic>>> getPaymentsReport(
      DateTime startDate,
      DateTime endDate) async {
    _verifyConnection();
    final collection = _db.collection('payments');

    final pipeline = [
      {
        '\$match': {
          'date': {'\$gte': startDate.toUtc(), '\$lte': endDate.toUtc()},
          'isDeleted': false,
        }
      },
      {
        '\$group': {
          '_id': '\$method',
          'totalAmount': {'\$sum': '\$amount'},
          'count': {'\$sum': 1}
        }
      },
      {
        '\$sort': {'totalAmount': -1}
      }
    ];

    return await _executeQuery(collection, pipeline);
  }

  Future<List<Map<String, dynamic>>> getClinicReport(
      DateTime startDate,
      DateTime endDate) async {
    _verifyConnection();
    final collection = _db.collection('clinic_visits');

    final pipeline = [
      {
        '\$match': {
          'visitDate': {'\$gte': startDate.toUtc(), '\$lte': endDate.toUtc()},
          'status': 'completed',
        }
      },
      {
        '\$group': {
          '_id': '\$serviceType',
          'totalVisits': {'\$sum': 1},
          'totalRevenue': {'\$sum': '\$fee'}
        }
      },
      {
        '\$sort': {'totalRevenue': -1}
      }
    ];

    return await _executeQuery(collection, pipeline);
  }

  Future<List<Map<String, dynamic>>> getSalesReport(
      DateTime startDate,
      DateTime endDate) async {
    _verifyConnection();
    final collection = _db.collection('sales');

    final pipeline = [
      {
        '\$match': {
          'saleDate': {'\$gte': startDate.toUtc(), '\$lte': endDate.toUtc()},
          'isCanceled': false,
        }
      },
      {
        '\$group': {
          '_id': '\$productCategory',
          'totalSales': {'\$sum': '\$amount'},
          'totalProfit': {'\$sum': '\$profit'},
          'itemCount': {'\$sum': '\$quantity'}
        }
      },
      {
        '\$sort': {'totalProfit': -1}
      }
    ];

    return await _executeQuery(collection, pipeline);
  }

  Future<List<Map<String, dynamic>>> getExpensesReport(
      DateTime startDate,
      DateTime endDate) async {
    _verifyConnection();
    final collection = _db.collection('expenses');

    final pipeline = [
      {
        '\$match': {
          'expenseDate': {'\$gte': startDate.toUtc(), '\$lte': endDate.toUtc()},
          'isApproved': true,
        }
      },
      {
        '\$group': {
          '_id': '\$expenseType',
          'totalAmount': {'\$sum': '\$amount'},
          'transactionCount': {'\$sum': 1}
        }
      },
      {
        '\$sort': {'totalAmount': -1}
      }
    ];

    return await _executeQuery(collection, pipeline);
  }

  Future<List<Map<String, dynamic>>> getInventoryReport() async {
    _verifyConnection();
    final collection = _db.collection('inventory');

    final pipeline = [
      {
        '\$match': {
          'quantity': {'\$gt': 0},
        }
      },
      {
        '\$group': {
          '_id': '\$category',
          'totalItems': {'\$sum': '\$quantity'},
          'totalValue': {'\$sum': {'\$multiply': ['\$quantity', '\$unitPrice']}},
          'lowStockItems': {
            '\$sum': {
              '\$cond': [
                {'\$lt': ['\$quantity', '\$minStock']},
                1,
                0
              ]
            }
          }
        }
      },
      {
        '\$sort': {'totalValue': -1}
      }
    ];

    return await _executeQuery(collection, pipeline);
  }

  Future<List<Map<String, dynamic>>> _executeQuery(
      DbCollection collection, List<Map<String, Object>> pipeline) async {
    try {
      return await collection.aggregateToStream(pipeline).toList();
    } catch (e) {
      await _safeDisconnect();
      throw Exception('فشل تنفيذ الاستعلام: ${e.toString()}');
    }
  }

  void _verifyConnection() {
    if (!_isConnected) {
      throw Exception('غير متصل بقاعدة البيانات. الرجاء الاتصال أولاً');
    }
  }
  Future<List<Map<String, dynamic>>> getSalesProfitReport(
      DateTime startDate, DateTime endDate) async {
    _verifyConnection();
    final collection = _db.collection('sales');

    final pipeline = [
      {
        '\$match': {
          'saleDate': {'\$gte': startDate.toUtc(), '\$lte': endDate.toUtc()},
          'isCanceled': false,
        }
      },
      {
        '\$group': {
          '_id': '\$productCategory', // Group by product category (or any other desired field)
          'totalSales': {'\$sum': '\$amount'}, // Sum of sales amounts
          'totalProfit': {'\$sum': '\$profit'}, // Sum of profit amounts
          'itemCount': {'\$sum': '\$quantity'} // Sum of item quantities sold
        }
      },
      {
        '\$sort': {'totalProfit': -1} // Sort by total profit in descending order
      }
    ];

    return await _executeQuery(collection, pipeline);
  }
  Future<void> disconnect() async {
    try {
      if (_isConnected) {
        await _db.close(); // Close the connection to the database
        _isConnected = false; // Update the connection status
        _currentDatabase = null; // Reset the current database
        developer.log('تم قطع الاتصال بنجاح', name: 'MongoService');
      }
    } catch (e) {
      developer.log('خطأ أثناء قطع الاتصال: $e', name: 'MongoService');
      throw Exception('فشل قطع الاتصال: ${e.toString()}'); // Propagate the error
    }
  }

}
