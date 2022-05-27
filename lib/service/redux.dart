// import 'package:admin_mobile_work_it/models/models.dart';
// import 'package:admin_mobile_work_it/models/view_models.dart';
// import 'package:admin_mobile_work_it/service/redux_actions.dart';
// import 'package:async_redux/async_redux.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class Factory extends VmFactory<AppState, dynamic> {
//   Factory(widget) : super(widget);
//
//   @override
//   ViewModel fromStore() => ViewModel(
//         user: state.user,
//         loading: state.loading,
//         isAuth: state.isAuth,
//         isDarkTheme: state.isDarkTheme,
//
//         setUser: ({required Account user}) => dispatch(SetUserAction(user: user)),
//         tryAuth: ({required String username, required String password}) => dispatch(TryAuth(username: username, password: password)),
//         changeAuth: ({required bool isAuth}) => dispatch(ChangeAuth(isAuth: isAuth)),
//         changeTheme: ({required bool isDarkTheme}) => dispatch(ChangeTheme(isDarkTheme: isDarkTheme)),
//       );
// }
//
// class AppState {
//   final Account? user;
//   final bool isAuth;
//   final bool loading;
//   final bool isDarkTheme;
//
//   AppState({
//     this.user,
//     this.isAuth = false,
//     this.loading = false,
//     this.isDarkTheme = false,
//   });
//
//   AppState copy({
//     Account? user,
//     bool? isAuth,
//     bool? loading,
//     bool? isDarkTheme,
//   }) {
//     return AppState(
//       user: user ?? this.user,
//       isAuth: isAuth ?? this.isAuth,
//       loading: loading ?? this.loading,
//       isDarkTheme: isDarkTheme ?? this.isDarkTheme,
//     );
//   }
//
//   static AppState initialState() {
//     return AppState(user: null);
//   }
// }
