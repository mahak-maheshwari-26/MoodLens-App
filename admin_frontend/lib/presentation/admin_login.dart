import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../theme/app_theme.dart'; 
import 'admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
  setState(() => _isLoading = true);
  bool success = await AdminService().adminLogin(_userController.text, _passController.text);
  
  // Guard check for async gap
  if (!mounted) return; 
  
  setState(() => _isLoading = false);

  if (success) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminDashboardPage()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use your Ice White background
      // backgroundColor: Palette.iceWhite,

      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Palette.surfaceGlass,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Moodlens Admin", 
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
                const SizedBox(height: 8),
                const Text("Management Portal", style: TextStyle(color: Palette.bodyGrey , fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextField(controller: _userController, decoration: const InputDecoration(
                    labelText: "Username",
                    floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                const SizedBox(height: 20),
                TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(
                  labelText: "Password",
                  floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                const SizedBox(height: 32),
                _isLoading 
                  ? const CircularProgressIndicator() 
                  : Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: AppGradients.electricAurora,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _login, 
                        child: const Text("Enter Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}