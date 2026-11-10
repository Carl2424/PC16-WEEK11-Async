import 'dart:async';

// 1. ABSTRACT CLASS / INTERFACE
abstract class PrintableReceipt {
  void printReceipt(double total);
}

// 2. MIXIN
mixin AudioPrompts {
  void playAudioCue(String message) {
    print('🔊 [AUDIO SYSTEM]: "$message"');
  }
}

// 3. BASE CLASS WITH ASYNCHRONOUS METHOD
class OrderingKiosk implements PrintableReceipt {
  String kioskId, branchLocation;
  bool isActive;
  double _dailyRevenue = 0;
  final List<String> _cart = [];

  final Map<String, double> menu = {
    'Burger': 78.0,
    'Fries': 49.0,
    'Iced Tea': 38.0,
    'Sundae': 40.0,
    'Iced Coffee': 70.0,
    'Combo 1 (Burger + Fries + Iced Tea)': 149.0,
    'Combo 2 (Burger + Sundae)': 108.0,
  };

  OrderingKiosk({
    required this.kioskId,
    required this.branchLocation,
    this.isActive = true,
  });

  double get dailyRevenue => _dailyRevenue;
  List<String> get currentCart => List.unmodifiable(_cart);

  void addItemToCart(String item) {
    if (!isActive) {
      print('[$kioskId] Kiosk offline.');
      return;
    }
    if (!menu.containsKey(item)) {
      print('[$kioskId] "$item" not on menu.');
      return;
    }
    _cart.add(item);
    print('[$kioskId] Added "$item" (₱${menu[item]!.toStringAsFixed(2)}).');
  }

  double calculateCartTotal() =>
      _cart.fold(0, (sum, i) => sum + (menu[i] ?? 0));

  // Week 11 Async Method: Simulates network gateway payment processing
  Future<bool> processNetworkPayment(double total) async {
    print(
      '[$kioskId] 📡 Contacting payment server for ₱${total.toStringAsFixed(2)}...',
    );

    // Simulates a 2-second cloud payment delay without freezing the UI/app
    await Future.delayed(const Duration(seconds: 2));

    print('[$kioskId] ✅ Payment approved by bank server!');
    return true;
  }

  // Asynchronous Checkout Method
  Future<void> processCheckout() async {
    if (_cart.isEmpty) {
      print('[$kioskId] Cart empty.');
      return;
    }
    final total = calculateCartTotal();

    // Await the asynchronous network call
    bool isApproved = await processNetworkPayment(total);

    if (isApproved) {
      _dailyRevenue += total;
      print('[$kioskId] Paid: ₱${total.toStringAsFixed(2)}');
      printReceipt(total);
      _cart.clear();
    }
  }

  @override
  void printReceipt(double total) {
    print('[$kioskId] 📄 Standard paper receipt printed.');
  }

  void displayKioskInfo() => print('''
----------------------------------------
Kiosk ID: $kioskId 
Location: $branchLocation 
Status: ${isActive ? "ONLINE" : "OFFLINE"}
Items in Cart: ${_cart.length} 
Revenue Today: ₱${_dailyRevenue.toStringAsFixed(2)}
----------------------------------------''');
}

// 4.INHERITANCE & POLYMORPHISM
class SelfServiceKiosk extends OrderingKiosk {
  int screenNumber;

  SelfServiceKiosk({
    required super.kioskId,
    required super.branchLocation,
    required this.screenNumber,
  });

  @override
  void printReceipt(double total) {
    print('[$kioskId] 📲 Digital receipt sent to lobby Screen #$screenNumber.');
  }
}

// 5.INHERITANCE, POLYMORPHISM & MIXIN
class DriveThruKiosk extends OrderingKiosk with AudioPrompts {
  int laneNumber;

  DriveThruKiosk({
    required super.kioskId,
    required super.branchLocation,
    required this.laneNumber,
  });

  @override
  Future<void> processCheckout() async {
    playAudioCue('Vehicle detected at Lane $laneNumber. Processing payment...');
    await super.processCheckout();
  }

  @override
  void printReceipt(double total) {
    print('[$kioskId] 🚗 Printed Drive-Thru slip for Window #$laneNumber.');
  }
}

// MAIN FUNCTION
void main() async {
  final kiosks = [
    SelfServiceKiosk(kioskId: 'K-101', branchLocation: '1', screenNumber: 1),
    DriveThruKiosk(kioskId: 'K-102', branchLocation: '2', laneNumber: 2),
  ];

  print('===== TESTING KIOSK 1 (ASYNC DEMO) ====');
  kiosks[0]
    ..displayKioskInfo()
    ..addItemToCart('Combo 1 (Burger + Fries + Iced Tea)')
    ..addItemToCart('Sundae');

  print('Subtotal: ₱${kiosks[0].calculateCartTotal().toStringAsFixed(2)}');

  //Sequence Order: Message printed BEFORE await
  print('▶ [MAIN ENGINE]: Sending checkout request to background server...');

  // Await the asynchronous processCheckout method
  await kiosks[0].processCheckout();

  print('▶ [MAIN ENGINE]: Kiosk 1 transaction completely finished.');
  kiosks[0].displayKioskInfo();

  print('\n==== TESTING KIOSK 2 (ASYNC DRIVE-THRU) ====');
  kiosks[1]
    ..addItemToCart('Combo 2 (Burger + Sundae)')
    ..addItemToCart('Pizza')
    ..addItemToCart('Iced Coffee')
    ..addItemToCart('Burger');

  print('▶ [MAIN ENGINE]: Sending Drive-Thru checkout request...');
  await kiosks[1].processCheckout();

  print('▶ [MAIN ENGINE]: Kiosk 2 transaction completely finished.');
  kiosks[1].displayKioskInfo();

  print('\n====== BRANCH KIOSK REPORT ======');
  for (var k in kiosks) {
    print(
      'Kiosk ${k.kioskId} (${k.branchLocation}): Revenue = ₱${k.dailyRevenue.toStringAsFixed(2)}',
    );
  }
}
