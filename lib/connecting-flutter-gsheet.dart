import 'package:gsheets/gsheets.dart';
class NameSheet{
  static const _credentials  ; // add the creditentials here
  static final _spreadsheetId = '1COpIK5dt-p_Emrumuj1NfJy1QFTrqnoGMR6M07HlOMk';
  static final _gsheet = GSheets(_credentials);
  static Worksheet? userSheet;

  static Future<void> init() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheetId);
    userSheet = await _getWorksheet(spreadsheet, title: "Sheet1");
  }

  static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}