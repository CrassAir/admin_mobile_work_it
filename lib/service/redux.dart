import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/models/view_models.dart';
import 'package:admin_mobile_work_it/service/redux_actions.dart';
import 'package:async_redux/async_redux.dart';

class Factory extends VmFactory<AppState, dynamic> {
  Factory(widget) : super(widget);

  @override
  ViewModel fromStore() => ViewModel(
        user: state.user,
        loading: state.loading,
        isAuth: state.isAuth,

        setUser: ({required User user}) => dispatch(SetUserAction(user: user)),
        tryAuth: ({required String username, required String password}) => dispatch(TryAuth(username: username, password: password)),
        changeAuth: ({required bool isAuth}) => dispatch(ChangeAuth(isAuth: isAuth)),
      );
}

class AppState {
  final User? user;
  final bool isAuth;
  final bool loading;

  AppState({
    this.user,
    this.isAuth = false,
    this.loading = false,
  });

  AppState copy({
    User? user,
    bool? isAuth,
    bool? loading,
  }) {
    return AppState(
      user: user ?? this.user,
      isAuth: isAuth ?? this.isAuth,
      loading: loading ?? this.loading,
    );
  }

  static AppState initialState() => AppState(user: null);
}
