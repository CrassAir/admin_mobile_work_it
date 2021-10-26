import 'package:async_redux/async_redux.dart';

import 'models.dart';

class ViewModel extends Vm {
  final Account? user;
  final bool isAuth;
  final bool loading;
  final Function setUser;
  final Function tryAuth;
  final Function changeAuth;

  ViewModel({
    this.user,
    required this.setUser,
    required this.tryAuth,
    required this.changeAuth,
    required this.isAuth,
    required this.loading,
  }) : super(equals: [user]);
}
