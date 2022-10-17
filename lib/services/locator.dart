import 'package:flutterbloc/repository/authentication_repository.dart';
import 'package:flutterbloc/services/api_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

Future setupLocator() async {
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
}