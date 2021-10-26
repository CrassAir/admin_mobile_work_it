class Auth {
  bool isAuth;

  Auth({this.isAuth = false});
}

class Account {
  String username;
  String? token;

  Account({required this.username, this.token});
}

// class User {
//   String username;
//   String? firstName;
//   String? lastName;
//   String? thirdName;
//   String? avatar;
//
// }


// Map<String, String> choiceStatus = {
//   'accept waiting': 'Ожидает принятия',
//   'accepted': 'В работе',
//   'paused': 'На паузе',
//   'done': 'Выполнена',
// };

