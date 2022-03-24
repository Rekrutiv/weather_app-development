import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/auth/auth_bloc.dart';

class AuthScreen extends StatelessWidget {
  static const id = '/auth_screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'auth_screen_title'.tr(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final type = state.runtimeType;
          switch (type) {
            case SignedInState:
              Navigator.of(context).pop();
              break;
            case SignInErrorState:
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Material Alert!'),
                ),
              );
              break;
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is LoadingState;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'google_sign_in_button_text'.tr(),
                          ),
                    onPressed: () => authBloc.add(
                      SignInWithGoogleEvent(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MaterialButton(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'facebook_sign_in_button_text'.tr(),
                          ),
                    onPressed: () => authBloc.add(
                      SignInWithFacebookEvent(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
