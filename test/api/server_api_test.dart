import 'package:flutter_test/flutter_test.dart';
import 'package:unbottled/api/api.dart';

void main() {
  test('Authentication works', () async {
    final api = ServerApi();

    final future = api.authenticate('Albert221', 'tak123').then((user) {
      expect(user.username, equals('Albert221'));
    });

    expect(future, completes);
  });
}
