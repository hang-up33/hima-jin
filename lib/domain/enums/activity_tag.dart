import '../../presentation/widgets/icons/app_icon_type.dart';

enum ActivityTag {
  nap('昼寝', AppIconType.nap),
  walk('散歩', AppIconType.walk),
  tv('動画/TV', AppIconType.tv),
  read('読書', AppIconType.books),
  food('食事/料理', AppIconType.cooking),
  nothing('何もしない', AppIconType.cloud),
  music('音楽', AppIconType.musicNote),
  game('ゲーム', AppIconType.gameController),
  bath('お風呂', AppIconType.bathtub),
  cafe('カフェ', AppIconType.coffee),
  exercise('運動', AppIconType.muscle),
  creative('創作', AppIconType.pencil),
  social('おしゃべり', AppIconType.chatBubble),
  shopping('買い物', AppIconType.shoppingBags),
  other('その他', AppIconType.pin);

  const ActivityTag(this.label, this.icon);

  final String label;
  final AppIconType icon;
}
