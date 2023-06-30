import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/emotions.dart';

final emojiProvider = StateProvider<String>((ref) {
  return emoticons.first.image;
});
