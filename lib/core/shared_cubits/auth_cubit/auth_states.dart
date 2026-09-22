abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthGuestState extends AuthState {}
class AuthLoggedInState extends AuthState {}
class AuthLoggedOutState extends AuthState {}