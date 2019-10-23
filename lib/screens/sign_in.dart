import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:unbottled/store/app_state.dart';
import 'package:unbottled/store/auth/actions.dart';
import 'package:unbottled/widgets/api_provider.dart';

class SignInScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignInScreen());

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          _SignInTab(),
          _buildCreateAccountTab(context),
        ],
      ),
    );
  }

  Widget _buildCreateAccountTab(BuildContext context) {
    return Text('b');
  }
}

class _SignInTab extends StatefulWidget {
  final VoidCallback onCreateAccountTap;

  _SignInTab({Key key, this.onCreateAccountTap}) : super(key: key);

  @override
  __SignInTabState createState() => __SignInTabState();
}

class __SignInTabState extends State<_SignInTab> {
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignInTap() {
    final store = StoreProvider.of<AppState>(context);

    store.dispatch(signIn(
      ApiProvider.of(context),
      _emailOrUsernameController.text,
      _passwordController.text,
      completer: Completer()
        ..future.then((_) {
          setState(() => _loading = false);

          if (store.state.auth.authenticated) {
            Navigator.pop(context);
          }
        }),
    ));

    setState(() => _loading = true);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).buttonTheme.colorScheme.primary;
    final onPrimary = Theme.of(context).buttonTheme.colorScheme.onPrimary;
    final surface = Theme.of(context).buttonTheme.colorScheme.surface;
    final onSurface = Theme.of(context).buttonTheme.colorScheme.onSurface;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.display2,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailOrUsernameController,
                decoration: const InputDecoration(
                  labelText: 'Email or username',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              FlatButton(
                color: primary,
                child: _loading
                    ? Transform.scale(
                        scale: 0.4,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(onPrimary),
                        ),
                      )
                    : Text(
                        'SIGN IN',
                        style: TextStyle(color: onPrimary),
                      ),
                onPressed: _onSignInTap,
              ),
              const SizedBox(height: 24),
              const Text('or'),
              const SizedBox(height: 24),
              FlatButton(
                color: surface,
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(color: onSurface),
                ),
                onPressed: widget.onCreateAccountTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
