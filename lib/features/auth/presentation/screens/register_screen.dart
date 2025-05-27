import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/core/mixins/input_validators.dart';
import 'package:pokemon_guessing_game/features/auth/presentation/widgets/auth_base.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../features/game/presentation/screens/game_screen.dart';

class RegisterScreen extends StatelessWidget with InputValidators {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final List<InputConfig> inputs = [
      InputConfig(
        label: 'Username',
        keyboardType: TextInputType.text,
        validator: validateRequired,
        controller: _userNameController,
      ),
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
        authBtnText: 'Register',
        redirectLinkText: 'Already have an account? Login',
        authBtnAction: () => authProvider.signUp(
              _emailController.text,
              _passwordController.text,
              _userNameController.text,
            ),
        redirectLinkAction: () {
          Navigator.pushNamed(context, '/login');
        });
  }
}
