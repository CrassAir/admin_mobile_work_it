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

class Door {
  late int id;
  late String name;
  late int perco_id;

  Door();
  Map<String, String> rel_name = {'ABK': 'АБК',
    'SGP': 'СГП',
    'Teplica': 'Теплица',
    'Turn1': 'Турникет 1',
    'Turn2': 'Турникет 2',
    'Tamb2': 'Тамбур КПП 2',
    'Kotel': 'Котельная',
    'Rossa': 'Розарий',
  };

  String get_name() {
    Map<String, String> rel_name = {'ABK': 'АБК',
      'SGP': 'СГП',
      'Teplica': 'Теплица',
      'Turn1': 'Турникет 1',
      'Turn2': 'Турникет 2',
      'Tamb2': 'Тамбур КПП 2',
      'Kotel': 'Котельная',
      'Rossa': 'Розарий',
    };
    return rel_name[name]!;
  }

  Door.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    perco_id = json['perco_id'];
  }
}

// Map<String, String> choiceStatus = {
//   'accept waiting': 'Ожидает принятия',
//   'accepted': 'В работе',
//   'paused': 'На паузе',
//   'done': 'Выполнена',
// };
