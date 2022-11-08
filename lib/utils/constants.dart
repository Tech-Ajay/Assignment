import 'package:supertails/utils/environment.dart';

class Constants {
  static const HASURA_HEADER = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST,GET,DELETE,PUT,OPTIONS',
    'Access-Control-Allow-Headers': "Access-Control-Allow-Origin, Accept",
    'content-type': "application/json",
    'x-hasura-admin-secret': Environment.HASURA_SECRET,
  };
}
