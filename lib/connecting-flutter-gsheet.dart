import 'package:gsheets/gsheets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NameSheet {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "qr-project-426521",
  "private_key_id": "a91ae534b138a5abde91bb87676ad6bacbe6c298",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDBmV+8YjyyG+UG\nahlwG/q5HjTK3H25iU/Gl+Jsz817BlVLHHSPm7d2L0QMBr+6zCVkG1O5XECs+ZMz\nsO8Ct1jzCgyHeSBERQn34DXqnLRK0eCo723rPqJoyG4nOEKLWXYbig+qydkh66u1\ncs4SneuvW22z1cpS/uE4UK686Jk85YgzAhhC+baAXKih51tUx1/A6cP2Q1I0FAan\n+fXtUwUqIDswOg4PvFANAK1o53qu48GUPWcRZef4lipCVRcewi8ME9X8iw9zVTIL\nLk+x2mhILAW98fFVjuYzeBitq3jCi6FocMqh07tyQ2rvKxTbzc4PZuXXJfJMfOx0\nZSsT71IHAgMBAAECggEADkwtbdQzd1PoDhk317e5RIKek3zFLDaf1aLR7gdKvZMy\nKWHomdJ+MhQ7ikfVUQ5SlJoQDNhrTlsALAkdHa48u3Y6hqbDY0dV/SBp2vHHvt7R\nIKjODVmK1QI4YF0fTPtGZbJEhfByQLcO70+TOHzBMyolZ+qaDpcUOvx6aykiaATK\nrueqGPnouFKvN7Hw3bTkG6snaxobAWtCACwzZ5R+BQDQieLdeCSds2ARvcMU5KMA\ndhNAPkS+CgU/XoOvcYqMaY4TPbceOu3uEKKfqcB0ETnyruz3sTxfKKZTaV1qe6Fb\nEzyLMOD5/ONbHD+eUCa9innLsEHUZ8T3h6IicprIQQKBgQDiqA30HHJkXDsmKn0G\n82JXoofeDaquCD33VWekm02RznXd1Ygm+LGpz9+6SGiFjECm7moR3VsA1pvS9aIe\ng+LOkNnKcta2kqm/xHPx+18y40aXuxOl7LBMRWtI0lhlLjugUAmv3D/Ui2wrv9lx\n+S+2hr7OW9yhDq8Oa8ls8kHEewKBgQDaqbgAkqQBNAe47Py04AhEmSHXMN9n5hwe\nzBumK/GwomRA3GtFtuDfXPtxVmcfCoYPltG6rThfyw9srkhynbqsAadigR3scgKP\njIJ+6NQu9UrG0xJp+IW4jbUBzb2BHg2jwvLS+WdSEbfvO3IVJTTaHTbJg+FmvKx5\n7dzL2DKw5QKBgDY+7GABMuuMG2fuAVBZja7Vqljdwny2YkZAvXZq6Oy9kf4OrfBN\n0w+GPdBypflYcNzC8MXnyXDw7AhYW32cKPsxNb67L2IwxcmsteczNzyRooKL9o7e\nj+8hKiUamqdUolai8T6SowA2giQSXXNmpSG1LBNtbudpAUKdT27wqAbjAoGBAMNP\nmUUZtlhEyykItWgyO/BZ/3og80vwo+l2UrQIyGcHhhjRSRgKE64vdYB0tsNpOPmv\ns0HU+2fFDs/6lEecT2LYT1STE9FgvJzP2rfU68HN467YVbhF/dss6CLmTICKAZDm\nztJXZ0xM+0g6htoQU7cHJSq2G50SpdR6/B8vy4dpAoGAF78yHAin+Gv2OH9fIiIK\nga9ENNrvvX/MWlNczemFxvgCxHCzMC1vYWJxEDcxvckQz+qdtIxjO4LOMGtwPr3K\nSq+HoRrPoz+DRbk/NVlxTxRta6CIalmIdYZrhfFbENkg4tbvjtntgVtKaLA1XhsJ\nk51WJwGiCP9ci3bNlz5WhUQ=\n-----END PRIVATE KEY-----\n",
  "client_email": "qr-677@qr-project-426521.iam.gserviceaccount.com",
  "client_id": "112846887207407152587",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/qr-677%40qr-project-426521.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  '''; // add the creditentials here
  static const _spreadsheetId = '1COpIK5dt-p_Emrumuj1NfJy1QFTrqnoGMR6M07HlOMk';
  static final _gsheet = GSheets(_credentials);
  static Worksheet? userSheet;

  static Future<void> init() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheetId);
    userSheet = await _getWorksheet(spreadsheet, title: "Sheet1");
  }

  static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}
