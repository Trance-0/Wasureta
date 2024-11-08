import 'testCard.dart';

class Jisho {
  // TODO: insert more attributes as needed in backend
  int id = 0;
  String title = "";
  String? description;
  String? sharing_id;
  DateTime date_created = DateTime.now();

  Jisho(
      {required this.id,
      required this.title,
      this.description,
      this.sharing_id});

  static Jisho fromJson(Map<String, dynamic> json) {
    Jisho jisho = Jisho(id: json['id'], title: json['title']);
    jisho.description = json['description'];
    jisho.sharing_id = json['sharing_id'];
    jisho.date_created = DateTime.parse(json['date_created']);
    return jisho;
  }
}

class MemRecord {
  int id = 0;
  int jisho_id = 0;
  DateTime start_time = DateTime.now();
  DateTime end_time = DateTime.now();
  String mode = "";
  int? random_seed;
  int score = 0;
  int total_words = 0;
  int progress = 0;
  String? sharing_id;

  MemRecord(
      {required this.id,
      required this.jisho_id,
      required this.start_time,
      required this.end_time,
      required this.mode,
      this.random_seed,
      required this.score,
      required this.total_words,
      required this.progress,
      this.sharing_id});

  static MemRecord fromJson(Map<String, dynamic> json) {
    MemRecord memRecord = MemRecord(
        id: json['id'],
        jisho_id: json['jisho_id'],
        start_time: DateTime.parse(json['start_time']),
        end_time: DateTime.parse(json['end_time']),
        mode: json['mode'],
        random_seed: json['random_seed'],
        score: json['score'],
        total_words: json['total_words'],
        progress: json['progress'],
        sharing_id: json['sharing_id']);
    return memRecord;
  }
}

// primary word pair
class WordPair {
  int id = 0;
  int jisho_id = 0;
  String key = "";
  String value = "";
  String? attributes;

  WordPair(
      {required this.id,
      required this.jisho_id,
      required this.key,
      required this.value,
      this.attributes});

  static WordPair fromJson(Map<String, dynamic> json) {
    WordPair wordPair = WordPair(
        id: json['id'],
        jisho_id: json['jisho_id'],
        key: json['key'],
        value: json['value'],
        attributes: json['attributes']);
    return wordPair;
  }
}

// secondary word pair
class WordVariant {
  int id = 0;
  int word_id = 0;
  String value = "";
  String? attributes;

  WordVariant(
      {required this.id,
      required this.word_id,
      required this.value,
      this.attributes});

  static WordVariant fromJson(Map<String, dynamic> json) {
    WordVariant wordVariant = WordVariant(
        id: json['id'],
        word_id: json['word_id'],
        value: json['value'],
        attributes: json['attributes']);
    return wordVariant;
  }
}
