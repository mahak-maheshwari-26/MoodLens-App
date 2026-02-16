import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/widgets/auth_widgets.dart';
import 'package:flutter_frontend/features/auth/presentation/signin_page.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {

  final _formKey = GlobalKey<FormState>(); // ID of the form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(){
    if (_formKey.currentState!.validate()){
      ref.read(authProvider.notifier).signup(
        _emailController.text.trim(),
         _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // add listener

    ref.listen<AsyncValue<String?>>(authProvider,(previous,next){
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()),
            backgroundColor: Palette.error,
            behavior: SnackBarBehavior.floating,

            )
          );
        },
        data: (token) {
          if (token != null && previous?.value == null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Welcome to MoodLens! ✨" ,
              style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
              backgroundColor: Palette.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              duration: Duration(seconds: 3),
              ),
            );
            // Pop the SignupPage. AuthGate is already sitting underneath 
            // and has already switched to ProfileSetupPage!
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If you used pushReplacement, just clear the stack to let AuthGate take over
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            }
          }
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground,
        ),
        child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),                
                physics: const BouncingScrollPhysics(),
                child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Begin your story with \nMoodLens✨",
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: Palette.indigoPrimary
                        ),
                      ),
                  
                      const SizedBox(height: 12),
                      Text(
                        "A quiet space to capture your thoughts and understand your world.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                          color: Palette.deepSpace.withValues(alpha: 0.8),
                          height: 1.5, // Better line height for readability
                        ),
                      ),
                      const SizedBox(height: 30),
                  
                      AuthTextField(
                        controller: _emailController,
                        label: "Email" ,
                        icon: Icons.email_rounded ,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Email is required";
                          final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"          
                          ).hasMatch(value);
                          return emailValid ? null : "Please enter a valid email address";
                        },
                      ),
                      const SizedBox(height: 20),
                  
                      AuthTextField(
                        controller: _passwordController, 
                        label: "Password", 
                        icon: Icons.lock,
                        isPassword: true,
                        validator: (value) => value!.length < 6 ? "Password should be of minimum 6 characters" : null,
                        ),
                  
                        const SizedBox(height: 20),
                  
                        AuthTextField(
                          controller: _confirmPasswordController, 
                          label: "Confirm Password", 
                          icon: Icons.lock_reset,
                          isPassword: true,
                          validator: (value) {
                            if (value != _passwordController.text) return "Passwords don't match";
                            return null;
                          },
                          ),
                  
                          const SizedBox(height: 30),
                  
                          AuthButton(
                            text : "SignUp",
                            isLoading : authState.isLoading,
                            onPressed: _submit,
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already part of the journey ?  ",
                              softWrap: true,
                              style: TextStyle(
                                color: Palette.deepSpace,
                                fontSize: 15),
                              ),
                  
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => SigninPage())
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 1),
                  
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Palette.violetAccent.withValues(alpha: 1),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                  
                                  child: Text(" Log in ",
                                  style: TextStyle(
                                    color: Palette.violetAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),),
                                ),
                              )
                            ],
                          ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom * 0.85),
                    ],
                  ),
                ),
                ),
              ),
            ),
          ),
      ),
      );
  }
}