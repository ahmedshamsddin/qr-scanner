// import 'package:gsheets/gsheets.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class NameSheet {
//   static const _credentials = r'''
//   {
  
// }

//   '''; // add the creditentials here
//   static const _spreadsheetId = '11yel6I90hVj8L7sLQY6xwAO9NsoDuNQ8Oy1ucqkUevU';
//   static final _gsheet = GSheets(_credentials);
//   static Worksheet? userSheet;

//   static Future<void> init() async {
//     final spreadsheet = await _gsheet.spreadsheet(_spreadsheetId);
//     userSheet = await _getWorksheet(spreadsheet, title: "1");
//   }

//   static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet,
//       {required String title}) async {
//     try {
//       return await spreadsheet.addWorksheet(title);
//     } catch (e) {
//       return spreadsheet.worksheetByTitle(title)!;
//     }
//   }

//   static Future<List<List<String>>> getPoints() async {
//     return [
//       [
//         await NameSheet.userSheet!.values.value(column: 1, row: 86),
//         await NameSheet.userSheet!.values.value(column: 2, row: 86)
//       ],
//       [
//         await NameSheet.userSheet!.values.value(column: 1, row: 87),
//         await NameSheet.userSheet!.values.value(column: 2, row: 87)
//       ],
//       [
//         await NameSheet.userSheet!.values.value(column: 1, row: 88),
//         await NameSheet.userSheet!.values.value(column: 2, row: 88)
//       ],
//     ];
//   }
// }
