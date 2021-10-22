class Auth {
  bool isAuth;

  Auth({this.isAuth = false});
}

class User {
  String username;
  String? token;

  User({required this.username, this.token});
}


// Map<String, String> choiceStatus = {
//   'accept waiting': 'Ожидает принятия',
//   'accepted': 'В работе',
//   'paused': 'На паузе',
//   'done': 'Выполнена',
// };

