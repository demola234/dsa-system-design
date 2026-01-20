abstract class Button {
  void render();
}

abstract class TextField {
  void render();
}

abstract class Checkbox {
  void render();
}

class LightButton implements Button {
  @override
  void render() {
    print("Rendering a light button");
  }
}

class DarkButton implements Button {
  @override
  void render() {
    print("Rendering a dark button");
  }
}

class LightCheckbox implements Checkbox {
  @override
  void render() {
    print("Rendering a light checkbox");
  }
}

class DarkCheckbox implements Checkbox {
  @override
  void render() {
    print("Rendering a dark checkbox");
  }
}

class LightTextField implements TextField {
  @override
  void render() {
    print("Rendering a light text field");
  }
}

class DarkTextField implements TextField {
  @override
  void render() {
    print("Rendering a dark text field");
  }
}

abstract class UIFactory {
  Button createButton();
  Checkbox createCheckbox();
  TextField createTextField();
}

class LightUIFactory implements UIFactory {
  @override
  Button createButton() => LightButton();

  @override
  Checkbox createCheckbox() => LightCheckbox();

  @override
  TextField createTextField() => LightTextField();
}

class DarkUIFactory implements UIFactory {
  @override
  Button createButton() => DarkButton();

  @override
  Checkbox createCheckbox() => DarkCheckbox();

  @override
  TextField createTextField() => DarkTextField();
}


class App {
  final UIFactory uiFactory;

  App(this.uiFactory);

  void renderUI() {
    final button = uiFactory.createButton();
    final checkbox = uiFactory.createCheckbox();
    final textField = uiFactory.createTextField();

    button.render();
    checkbox.render();
    textField.render();
  }
}

abstract class AnalyticsProvider {
  void trackEvent(String event, Map<String, dynamic> properties);
  void setUserId(String userId);
}

abstract class CrashReporter {
  void logCrash(Exception error, StackTrace stackTrace);
}

abstract class Logger {
  void log(String message);
}


class FirebaseAnalytics implements AnalyticsProvider {
  @override
  void setUserId(String userId) {
      print("Setting user ID in Firebase Analytics: $userId");
  }

  @override
  void trackEvent(String event, Map<String, dynamic> properties) {
   print("Tracking event in Firebase Analytics: $event with properties: $properties");
  }
}

class FirebaseCrashlytics implements CrashReporter {
  @override
  void logCrash(Exception error, StackTrace stackTrace) {
    print("Logging crash in Firebase Crashlytics: $error, $stackTrace");
  }
}

class FirebaseLogger implements Logger {
  @override
  void log(String message) {
    print("Logging in Firebase Logger: $message");
  }
}

class MixpanelAnalytics implements AnalyticsProvider {
  @override
  void setUserId(String userId) {
    print("Setting user ID in Mixpanel Analytics: $userId");
  }

  @override
  void trackEvent(String event, Map<String, dynamic> properties) {
    print("Tracking event in Mixpanel Analytics: $event with properties: $properties");
  }
}

class SentryCrashReporter implements CrashReporter {
  @override
  void logCrash(Exception error, StackTrace stackTrace) {
    print("Logging crash in Sentry Crash Reporter: $error, $stackTrace");
  }
}

class AndroidLogger implements Logger {
  @override
  void log(String message) {
    print("Logging in Android Logger: $message");
  }
}


abstract class PlatformServiceFactory {
  AnalyticsProvider createAnalyticsProvider();
  CrashReporter createCrashReporter();
  Logger createLogger();
}

class IOSServiceFactory implements PlatformServiceFactory {
  @override
  AnalyticsProvider createAnalyticsProvider() => FirebaseAnalytics();

  @override
  CrashReporter createCrashReporter() => FirebaseCrashlytics();

  @override
  Logger createLogger() => FirebaseLogger();
}

class AndroidServiceFactory implements PlatformServiceFactory {
  @override
  AnalyticsProvider createAnalyticsProvider() => MixpanelAnalytics();

  @override
  CrashReporter createCrashReporter() => SentryCrashReporter();

  @override
  Logger createLogger() => AndroidLogger();
}

class MobileApp {
  late final AnalyticsProvider analyticsProvider;
  late final CrashReporter crashReporter;
  late final Logger logger;

  MobileApp(PlatformServiceFactory platformServiceFactory) {
    analyticsProvider = platformServiceFactory.createAnalyticsProvider();
    crashReporter = platformServiceFactory.createCrashReporter();
    logger = platformServiceFactory.createLogger();
  }

  void run() {
    analyticsProvider.trackEvent("App started", {
      'appName': 'Android',
    });
    analyticsProvider.setUserId("12345");
    analyticsProvider.trackEvent("Button_Clicked", {"button_name": "Login"});

    try {
      throw Exception("An error occurred");
    } catch (error, stackTrace) {
      crashReporter.logCrash(error as Exception, stackTrace);
    }
  }
}

abstract class ApiConfig {
  String get baseUrl;
  String get apiKey;
  Map<String, String> get headers;
}

abstract class DatabaseConfig {
  String get connectionString;
  int get maxConnections;
}

abstract class FeatureFlags {
  bool get enableFeatures;
  bool get enableDebugMode;
}


class DevApiConfig implements ApiConfig {
  @override
  String get apiKey => 'dev_api_key';

  @override
  String get baseUrl => 'http://localhost:3000';

  @override
  Map<String, String> get headers => {'X-Environment': 'development'};
}

class DevDatabaseConfig implements DatabaseConfig {
  @override
  String get connectionString => 'dev_connection_string';

  @override
  int get maxConnections => 3;
}

class DevFeatureFlags implements FeatureFlags {
  @override
  bool get enableDebugMode => true;

  bool get enableFeatures => true;
}


class ProdApiConfig implements ApiConfig {
  @override
  String get apiKey => 'dev_api_key';

  @override
  String get baseUrl => 'http://api.test.com';

  @override
  Map<String, String> get headers => {'X-Environment': 'development'};
}

class ProdDatabaseConfig implements DatabaseConfig {
  @override
  String get connectionString => 'postgres://localhost:5432/prod';

  @override
  int get maxConnections => 200;
}

class ProdFeatureFlags implements FeatureFlags {
  @override
  bool get enableDebugMode => false;

  bool get enableFeatures => false;
}

abstract class EnvironmentFactory {
  ApiConfig get apiConfig;
  DatabaseConfig get databaseConfig;
  FeatureFlags get featureFlags;
}


class DevFactory implements EnvironmentFactory {
  @override
  ApiConfig get apiConfig => DevApiConfig();

  @override
  DatabaseConfig get databaseConfig => DevDatabaseConfig();

  @override
  FeatureFlags get featureFlags => DevFeatureFlags();
}

class ProdFactory implements EnvironmentFactory {
  @override
  ApiConfig get apiConfig => ProdApiConfig();

  @override
  DatabaseConfig get databaseConfig => ProdDatabaseConfig();

  @override
  FeatureFlags get featureFlags => ProdFeatureFlags();
}

  class Application {
    final ApiConfig apiConfig;
    final DatabaseConfig databaseConfig;
    final FeatureFlags featureFlags;

    Application(EnvironmentFactory factory)
      : apiConfig = factory.apiConfig,
        databaseConfig = factory.databaseConfig,
        featureFlags = factory.featureFlags;

    void initialize() {
      print('API URL: ${apiConfig.baseUrl}');
      print('Database connection string: ${databaseConfig.connectionString}');
      print('Enable features: ${featureFlags.enableFeatures}');
      print('Enable debug mode: ${featureFlags.enableDebugMode}');
      print('API Key: ${apiConfig.apiKey}');
      print('Headers: ${apiConfig.headers}');
      }
  }

  abstract class PaymentGateway {
  void processPayment(double amount);
  void handleError(Exception error);
  }

  abstract class RefundHandler {
  void processRefund(double amount);
  void handleError(Exception error);
  }

  abstract class WebhookProcessor {
  void processWebhook(Map<String, dynamic> payload);
  void handleError(Exception error);
  }

  class StripePaymentGateway implements PaymentGateway {
  @override
  void handleError(Exception error) {
    print('Stripe payment gateway error: $error');
  }

  @override
  void processPayment(double amount) {
    print('Processing payment of $amount using Stripe');
  }
}

class StripeRefundHandler implements RefundHandler {
  @override
  void handleError(Exception error) {
    print('Stripe refund handler error: $error');
  }

  void processRefund(double amount) {
    print('Processing refund of $amount using Stripe');
  }
}

class StripeWebhookProcessor implements WebhookProcessor {
  @override
  void handleError(Exception error) {
    print('Stripe webhook processor error: $error');
  }

  @override
  void processWebhook(Map<String, dynamic> payload) {
    print('Processing webhook with payload: $payload using Stripe');
  }
}

class PayPalPaymentGateway implements PaymentGateway {
  @override
  void handleError(Exception error) {
    print('PayPal payment gateway error: $error');
  }

  @override
  void processPayment(double amount) {
    print('Processing payment of $amount using PayPal');
  }
}

class PayPalRefundHandler implements RefundHandler {
  @override
  void handleError(Exception error) {
    print('PayPal refund handler error: $error');
  }

  void processRefund(double amount) {
    print('Processing refund of $amount using PayPal');
  }
}

class PayPalWebhookProcessor implements WebhookProcessor {
  @override
  void handleError(Exception error) {
   print('PayPal webhook processor error: $error');
  }

  @override
  void processWebhook(Map<String, dynamic> payload) {
    print('Processing webhook with payload: $payload using PayPal');
  }
}

abstract class PaymentFactory {
  PaymentGateway createPaymentGateway();
  RefundHandler createRefundHandler();
  WebhookProcessor createWebhookProcessor();
}


class StripePaymentFactory implements PaymentFactory {
  @override
  PaymentGateway createPaymentGateway() {
    return StripePaymentGateway();
  }

  @override
  RefundHandler createRefundHandler() {
    return StripeRefundHandler();
  }

  @override
  WebhookProcessor createWebhookProcessor() {
    return StripeWebhookProcessor();
  }
}

class PayPalPaymentFactory implements PaymentFactory {
  @override
  PaymentGateway createPaymentGateway() {
    return PayPalPaymentGateway();
  }

  @override
  RefundHandler createRefundHandler() {
    return PayPalRefundHandler();
  }

  @override
  WebhookProcessor createWebhookProcessor() {
    return PayPalWebhookProcessor();
  }
}

class Payment {
  final PaymentGateway paymentGateway;
  final RefundHandler refundHandler;
  final WebhookProcessor webhookProcessor;


  Payment(PaymentFactory paymentFactory)
    : paymentGateway = paymentFactory.createPaymentGateway(),
      refundHandler = paymentFactory.createRefundHandler(),
      webhookProcessor = paymentFactory.createWebhookProcessor();


 void initialize() {
    print('Payment Gateway: ${paymentGateway.runtimeType}');
    print('Refund Handler: ${refundHandler.runtimeType}');
    print('Webhook Processor: ${webhookProcessor.runtimeType}');
  }

}


void main() {
  // Create a light UI factory
  final lightFactory = LightUIFactory();
  final lightApp = App(lightFactory);
  lightApp.renderUI();

  // Create a dark UI factory
  final darkFactory = DarkUIFactory();
  final darkApp = App(darkFactory);
  darkApp.renderUI();


  print('========= Logger Factory ========');
  var app = MobileApp(AndroidServiceFactory());
  app.run();


  app = MobileApp(IOSServiceFactory());
  app.run();

  print('========= Environment Factory ========');
  const environment = 'dev';
  final factory = environment == 'dev' ? DevFactory() : ProdFactory();


  final appInit = Application(factory);
  appInit.initialize();


  final payment = Payment(PayPalPaymentFactory());
  payment.initialize();
}