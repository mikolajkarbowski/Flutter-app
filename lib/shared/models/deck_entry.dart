import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'deck_entry.g.dart';

@JsonSerializable()
class DeckEntry {
  DeckEntry({required this.deckId, required this.name});
  DeckEntry.create({required String name})
      : this(deckId: Uuid().v8(), name: name);

  factory DeckEntry.fromJson(Map<String, dynamic> json) =>
      _$DeckEntryFromJson(json);

  DeckEntry copyWith({
    String? deckId,
    String? name,
  }) {
    return DeckEntry(deckId: deckId ?? this.deckId, name: name ?? this.name);
  }

  final String deckId;
  final String name;

  Map<String, dynamic> toJson() => _$DeckEntryToJson(this);
}
