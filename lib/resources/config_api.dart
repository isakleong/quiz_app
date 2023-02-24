


class ConfigAPI {
  
  static Future checkVersion() async {
    

    return get('/api/public/androidVersion');
  }
}