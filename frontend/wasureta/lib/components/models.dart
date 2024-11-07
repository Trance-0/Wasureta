import 'testCard.dart';

class Jisho {
  // TODO: insert more attributes as needed in backend
  int id = 0;
  String title = "" ;
  String? description;
  String? sharing_id;
  
  static Jisho fromJson(Map<String, dynamic> json) {
    Jisho jisho = Jisho();
    jisho.id = json['id'];
    jisho.title = json['title'];
    jisho.description = json['description'];
    jisho.sharing_id = json['sharing_id'];
    return jisho;
  }
}
