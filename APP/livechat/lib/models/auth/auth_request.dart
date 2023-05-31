class AuthRequest {
  String? username;
  String? password;
  String? email;
  String? imageFile;
  bool isLogin = false;

  bool get userNeedImage => !isLogin && imageFile == null;

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
      if (!isLogin) 
      "username": username,
      "imageFile": imageFile,
    };
  }
}
