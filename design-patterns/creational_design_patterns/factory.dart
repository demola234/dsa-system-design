abstract class PaymentMethod {
  void processPayment(double amount);
}

class CardPayment implements PaymentMethod {
  @override
  void processPayment(double amount) {
    print("Processing card payment of $amount");
  }
}

class BankTransfer implements PaymentMethod {
  @override
  void processPayment(double amount) {
    print("Processing bank transfer payment of $amount");
  }
}

class WalletPayment implements PaymentMethod {
  @override
  void processPayment(double amount) {
    print("Processing wallet payment of $amount");
  }
}

enum PaymentType {
  Card,
  BankTransfer,
  Wallet,
}

class PaymentFactory {
  static PaymentMethod createPaymentMethod(PaymentType type) {
    switch (type) {
      case PaymentType.Card:
        return CardPayment();
      case PaymentType.BankTransfer:
        return BankTransfer();
      case PaymentType.Wallet:
        return WalletPayment();
    }
  }
}


class PaymentService {
  PaymentService._();

  static final instance = PaymentService._();

  factory PaymentService() {
    return instance;
  }

  void processPayment(double amount, PaymentType type) {
    final paymentMethod = PaymentFactory.createPaymentMethod(type);
    paymentMethod.processPayment(amount);
  }
}

/// ==========================================================================
///
///

abstract class NotificationService {
  Notification createNotification();


  void send(String message) {
    final notification = createNotification();
    notification.deliver(message);
  }
}

abstract class Notification {
  void deliver(String message);
}

class EmailNotification implements Notification {
  @override
  void deliver(String message) {
    print("Sending email notification: $message");
  }
}

class SMSNotification implements Notification {
  @override
  void deliver(String message) {
    print("Sending SMS notification: $message");
  }
}

class PushNotification implements Notification {
  @override
  void deliver(String message) {
    print("Sending push notification: $message");
  }
}

class EmailNotificationService extends NotificationService {
  @override
  Notification createNotification() {
    return EmailNotification();
  }
}

class SMSNotificationService extends NotificationService {
  @override
  Notification createNotification() {
    return SMSNotification();
  }
}

class PushNotificationService extends NotificationService {
  @override
  Notification createNotification() {
    return PushNotification();
  }
}


abstract class ApiClient {
  Future<Map<String, dynamic>> get(String url);
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body);
  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> body);
  Future<Map<String, dynamic>> delete(String url);
}

class ProductionApiClient implements ApiClient {
  final String baseUrl = "https://api.example.com";
  Map<String, dynamic> _cache = {};

  @override
  Future<Map<String, dynamic>> delete(String url) {
    _cache.clear();
    return Future.value(_cache);
  }

  @override
  Future<Map<String, dynamic>> get(String url) {
    if (_cache.containsKey(url)) {
      return Future.value(_cache[url]);
    }

    // Simulate an API call
    return Future.delayed(Duration(seconds: 1), () {
      final data = {"key": "value"};
      _cache[url] = data;
      return data;
    });
  }

  @override
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) {
    if (_cache.containsKey(url)) {
      return Future.value(_cache[url]);
    }

    // Simulate an API call
    return Future.delayed(Duration(seconds: 1), () {
      final data = {"key": "value"};
      _cache[url] = data;
      return data;
      }
    );
  }

  @override
  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> body) {
    if (_cache.containsKey(url)) {
      return Future.value(_cache[url]);
    }

    // Simulate an API call
    return Future.delayed(Duration(seconds: 1), () {
      final data = {"key": "value"};
      _cache[url] = data;
      return data;
    });
    }
}

class MockApiClient implements ApiClient {
  @override
  Future<Map<String, dynamic>> delete(String url) {
   print("Deleting data from $url");
    return Future.value({});
  }

  @override
  Future<Map<String, dynamic>> get(String url) async {
    print("Getting data from $url");
    return {'status': 'success'};
  }

  @override
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
    print("Posting data to $url with body: $body");
    return {'status': 'success'};
  }

  @override
  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> body) async{
    print("Putting data to $url with body: $body");
    return {'status': 'success'};
  }
}

class ApiClientFactory {
  static ApiClient createApiClient({bool isProduction = true}) {
    if (isProduction) {
      return ProductionApiClient();
    } else {
      return MockApiClient();
    }
  }
}

abstract class Logger {
  void log(String message);

  void logError(String message);
}

class ConsoleLogger implements Logger {
  @override
  void log(String message) {
    print("INFO: $message");
  }

  @override
  void logError(String message) {
    print("ERROR: $message");
  }
}

class FileLogger implements Logger {
  @override
  void log(String message) {
    print("INFO: $message");
  }

  @override
  void logError(String message) {
    print("ERROR: $message");
  }
}

class NetworkLogger implements Logger {
  @override
  void log(String message) {
    print("INFO: $message");
  }

  @override
  void logError(String message) {
    print("ERROR: $message");
  }
}

class LoggerFactory {
  static Logger createLogger(String type) {
    switch (type) {
      case "console":
        return ConsoleLogger();
      case "file":
        return FileLogger();
      case "network":
        return NetworkLogger();
      default:
        throw ArgumentError("Invalid logger type: $type");
    }
  }
}

  void main() async{
    final paymentService = PaymentService.instance;
    paymentService.processPayment(100.0, PaymentType.Card);
    paymentService.processPayment(50.0, PaymentType.BankTransfer);


    print("\n========== PaymentFactory ==========\n");

    final cardPayment = PaymentFactory.createPaymentMethod(PaymentType.Card);
    cardPayment.processPayment(75.0);


    print("\n========== NotificationService ==========\n");

    final emailService = EmailNotificationService();
    emailService.send("New order received!");

    final smsService = SMSNotificationService();
    smsService.send("Reminder: Meeting tomorrow.");

    final pushService = PushNotificationService();
    pushService.send("New message from your friend.");

    print("\n========== ApiClient ==========\n");

    final apiClient = ApiClientFactory.createApiClient(isProduction: true);
    final requests = await Future.wait([
      apiClient.get("https://api.example.com/data"),
      apiClient.post("https://api.example.com/data", {"key": "value"}),
      apiClient.put("https://api.example.com/data", {"key": "value"}),
      apiClient.delete("https://api.example.com/data")
    ]);
    print(requests[0]);
    print(requests[1]);
    print(requests[2]);
    print(requests[3]);

    print("\n========== LoggerFactory ==========\n");
    final logger = LoggerFactory.createLogger("network");
    logger.log("This is a log message.");
    logger.logError("This is an error message");
  }