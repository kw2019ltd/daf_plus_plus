
import 'package:daf_plus_plus/models/Response.dart';

class ResponsesConst {


  static const ResponseModel GENERAL_SUCCESS = const ResponseModel(
    status: 200,
    code: "GENERAL_SUCCESS",
    message: "operation was successful",
  );

  static const ResponseModel NOT_AUTHED = const ResponseModel(
    status: 400,
    code: "NOT_AUTHED",
    message: "user not authed",
  );

  static const ResponseModel MISSING_PARAMATERS = const ResponseModel(
    status: 300,
    code: "MISSING_PARAMATERS",
    message: "missing paramaters",
  );

  static const ResponseModel UNKNOWN_CLIENT_ERROR = const ResponseModel(
    status: 400,
    code: "UNKNOWN_CLIENT_ERROR",
    message: "unknown error",
  );

  static const ResponseModel DOCUMENT_NOT_FOUND = const ResponseModel(
    status: 400,
    code: "DOCUMENT_NOT_FOUND",
    message: "document not found",
  );

}

