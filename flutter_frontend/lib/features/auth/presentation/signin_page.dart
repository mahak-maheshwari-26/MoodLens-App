import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/widgets/auth_widgets.dart';
// import 'package:flutter_frontend/theme/app_theme2.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SigninPage extends ConsumerStatefulWidget{

  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {

  final _formKey = GlobalKey<FormState>(); // ID of the form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

    @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(){
    if (_formKey.currentState!.validate()){
      ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<String?>>(authProvider, (previous,next){
      next.whenOrNull(
        error : (error , stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error Occurred"),
            backgroundColor: Palette.error,
            )
          );
        },
        data : (token) {
          if(token != null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login Successful!",
                style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
              backgroundColor: Palette.success,),
              
            );
          }
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground),
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
                    Row(
                      children: [
                        Text(
                          "Pick up where you left off at\nMoodLens 🌙",                      
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Palette.indigoPrimary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Step back into your quiet space and continue your journey.",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                        color: Palette.darkGrey.withValues(alpha: 0.7),
                        height: 1.4,
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
                
                      const SizedBox(height: 30),
                            
                        AuthButton(
                          text : "Sign In",
                          isLoading : authState.isLoading,
                          onPressed: _submit,
                        ),
                          
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New to the journey ?  ",
                              style: TextStyle(
                                color: Palette.deepSpace,
                                fontSize: 15),
                              ),
              
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => Navigator.pop(context),
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
              
                                  child: Text(" Start here ",
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