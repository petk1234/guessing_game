import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/core/mixins/input_validators.dart';
import 'package:pokemon_guessing_game/features/auth/presentation/widgets/auth_base.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../features/game/presentation/screens/game_screen.dart';

class LoginScreen extends StatelessWidget with InputValidators {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final List<InputConfig> inputs;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final List<InputConfig> inputs = [
      InputConfig(
        label: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        controller: _emailController,
      ),
      InputConfig(
        label: 'Password',
        obscureText: true,
        validator: validatePassword,
        controller: _passwordController,
      ),
    ];

    return AuthBase(
      inputs: inputs,
      authBtnText: 'Login',
      redirectLinkText: 'Don\'t have an account? Sign Up',
      authBtnAction: () => authProvider.signIn(
        _emailController.text,
        _passwordController.text,
      ),
      redirectLinkAction: () {
        Navigator.pushNamed(context, '/register');
      },
    );
  }
}
