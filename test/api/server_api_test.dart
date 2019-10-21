import 'package:flutter_test/flutter_test.dart';
import 'package:unbottled/api/api.dart';

void main() {
  test('Authentication works', () async {
    final api = ServerApi();

    try {
      final user = await api.authenticate('Albert221', 'tak123');
      expect(user.username, equals('Albert221'));
    } catch (e) {
      print(e.toString());
    }
  });
}
