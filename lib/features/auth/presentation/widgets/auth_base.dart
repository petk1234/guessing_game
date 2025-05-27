import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/core/mixins/input_validators.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../game/presentation/screens/game_screen.dart';

class AuthBase extends StatefulWidget {
  final List<InputConfig> inputs;
  final String authBtnText;
  final String redirectLinkText;
  final Future Function() authBtnAction;
  final Function redirectLinkAction;

  const AuthBase(
      {super.key,
      required this.inputs,
      required this.authBtnText,
      required this.redirectLinkText,
      required this.authBtnAction,
      required this.redirectLinkAction});

  @override
  State<AuthBase> createState() => _AuthBaseState();
}

class _AuthBaseState extends State<AuthBase> {
  final _formKey = GlobalKey<FormState>();
  late final List<InputConfig> inputs;

  @override
  @override
  void initState() {
    inputs = widget.inputs;
    super.initState();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      FocusScope.of(context).unfocus();
      try {
        await widget.authBtnAction();
        if (mounted && authProvider.isAuthenticated) {
          Navigator.of(context).pushNamed("/game");
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error!)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pokemon Guessing Game',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                ..._buildInputs(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _submit,
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.authBtnText),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.redirectLinkAction();
                    });
                  },
                  child: Text(widget.redirectLinkText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Iterable<Widget> _buildInputs() {
    return inputs.map((input) {
      return Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            key: Key(input.label),
            controller: input.controller,
            keyboardType: input.keyboardType,
            obscureText: input.obscureText,
            decoration: InputDecoration(
              labelText: input.label,
              border: const OutlineInputBorder(),
            ),
            validator: input.validator,
          ));
    });
  }
}

class InputConfig {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  InputConfig(
      {required this.label,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.validator,
      this.controller});
}
