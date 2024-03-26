import 'package:shared_preferences/shared_preferences.dart';

class Helper
{
  static String userLoggedInKey=" LOGGEDINKEY";
  static String userNameKey=" USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey,isUserLoggedIn);
  }
   
  static Future<bool> saveUserEmailSF(String UserEmail) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey,UserEmail);
  }

  static Future<bool> saveUserNameSF(String UserName) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(userNameKey,UserName);
  }


  static Future<bool> getUserLoggedInStatus() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  return sf.getBool(userLoggedInKey) ?? false;
}

  static Future<String?> getUserNameSF() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  return sf.getString(userNameKey);
}

  static Future<String?> getUserEmailSF() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  return sf.getString(userEmailKey);
}

}
