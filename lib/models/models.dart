class Account {
  String? username;
  String? token;

  Account({this.username, this.token});
}

class User {
  String? username;
  String? full_name;
  String? avatar;

  User({this.username, this.full_name, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    full_name = json['full_name'] ?? '';
    avatar = json['avatar'] ?? '';
  }
}

// Map<String, String> choiceStatus = {
//   'accept waiting': 'Ожидает принятия',
//   'accepted': 'В работе',
//   'paused': 'На паузе',
//   'done': 'Выполнена',
// };
