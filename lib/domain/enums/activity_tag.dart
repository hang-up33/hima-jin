import 'package:flutter/widgets.dart';

import '../../presentation/widgets/icons/app_icon_type.dart';

enum ActivityTag {
  nap('昼寝', 'Nap', AppIconType.nap),
  walk('散歩', 'Walk', AppIconType.walk),
  tv('動画/TV', 'Video/TV', AppIconType.tv),
  read('読書', 'Reading', AppIconType.books),
  food('食事/料理', 'Food/Cooking', AppIconType.cooking),
  nothing('何もしない', 'Do Nothing', AppIconType.cloud),
  music('音楽', 'Music', AppIconType.musicNote),
  game('ゲーム', 'Game', AppIconType.gameController),
  bath('お風呂', 'Bath', AppIconType.bathtub),
  cafe('カフェ', 'Café', AppIconType.coffee),
  exercise('運動', 'Exercise', AppIconType.muscle),
  creative('創作', 'Creative', AppIconType.pencil),
  social('おしゃべり', 'Chat', AppIconType.chatBubble),
  shopping('買い物', 'Shopping', AppIconType.shoppingBags),
  other('その他', 'Other', AppIconType.pin);

  const ActivityTag(this.labelJa, this.labelEn, this.icon);

  final String labelJa;
  final String labelEn;
  final AppIconType icon;

  /// Localized display label for the given [locale].
  String labelFor(Locale locale) =>
      locale.languageCode == 'ja' ? labelJa : labelEn;
}
