import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final isLoggedIn = authProvider.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
      ),
      body: Column(
        children: [
          // Auth section
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(isLoggedIn ? (user?.email ?? '') : 'Not logged in'),
            trailing: isLoggedIn
                ? TextButton(
                    onPressed: () => authProvider.signOut(),
                    child: const Text('Logout'),
                  )
                : authProvider.isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: () => authProvider.signInWithGoogle(),
                        child: const Text('Sign in with Google'),
                      ),
          ),
          const Divider(),

          // Menu items
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Students'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/students'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Majors'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/majors'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Student Map'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/map'),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
