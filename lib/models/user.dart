import '../utilities/http_airtable.dart';
import '../utilities/keys.dart';

class User {
  Future<Map<String, dynamic>> checkUser({
    required String email,
    required String code,
  }) async {
    String myBase = "app9yul6FMnVUm7L4";
    String myTable = "Parishes";
    //String view = 'To MEL App';
    String filter = 'AND({PMC Email}="$email", {Branch-code}="$code")';
    HttpAirtable airtable = HttpAirtable(
        apiKey: airtableAccessToken, baseId: myBase, tableName: myTable);
    Map data = await airtable.fetchDataWithFilter(filter: filter);
    Map<String, dynamic>? userData;
    List parishes = [];
    if (data['records'].isEmpty) {
      return {"msg": "Not Found"};
    } else {
      for (var record in data['records']) {
        //print("Record Fields: ${record['fields']['ID']}");
        parishes.add(record['fields']['ID']);
        userData = {
          'branch': record['fields']['Branch'],
          'coordinator': record['fields']['PMC'],
          'parishes': parishes,
        };
      }
      return {"msg": "Found", "data": userData ?? {}};
    }
  }
}
