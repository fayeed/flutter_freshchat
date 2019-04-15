import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_freshchat/flutter_freshchat.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_freshchat');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterFreshchat.platformVersion, '42');
  });
}
