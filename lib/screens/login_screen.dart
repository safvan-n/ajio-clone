import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/ajio_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isSignUpMode = false; // Toggle between Login and Registration
  bool _isOtpLogin = false; // Toggle between Email Login and Mobile OTP Login

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // Verification & State vars
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _termsAgreed = true;
  bool _isOtpSent = false;
  int _otpCountdown = 30;
  Timer? _countdownTimer;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _otpCountdown = 30;
      _isOtpSent = true;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpCountdown == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _otpCountdown--;
        });
      }
    });
  }

  void _mockSendOtp() {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: AjioTheme.discountRed,
        ),
      );
      return;
    }
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.message_outlined, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('OTP code [1234] sent to your mobile number!'),
          ],
        ),
        backgroundColor: Colors.blue.shade800,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSignUpMode && !_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms & Conditions'),
          backgroundColor: AjioTheme.discountRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate luxury server loading response
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    final store = Provider.of<StoreProvider>(context, listen: false);

    if (_isSignUpMode) {
      // Registration complete
      store.login(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
      );
      _showAuthSuccessSheet('Account Created Successfully!');
    } else {
      // Login Complete
      if (_isOtpLogin) {
        if (_otpController.text != '1234') {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incorrect OTP! Try using mock code [1234]'),
              backgroundColor: AjioTheme.discountRed,
            ),
          );
          return;
        }
        store.login(
          'Safwan',
          'safwan@ajio-clone.com',
          _phoneController.text.trim(),
        );
      } else {
        // Email login details
        final emailPart = _emailController.text.split('@').first;
        final formattedName = emailPart[0].toUpperCase() + emailPart.substring(1);
        store.login(
          formattedName,
          _emailController.text.trim(),
          '9876543210',
        );
      }
      _showAuthSuccessSheet('Welcome Back to AJIO!');
    }
  }

  void _showAuthSuccessSheet(String message) {
    setState(() {
      _isLoading = false;
    });

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars, color: AjioTheme.ajioGold, size: 64),
              const SizedBox(height: 16),
              Text(
                message.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: AjioTheme.darkSlate,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'You now have full access to AJIO VIP offers, orders, and premium bags.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AjioTheme.textGrey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                    Navigator.pop(context); // Pop Login Page
                    if (widget.onLoginSuccess != null) {
                      widget.onLoginSuccess!();
                    }
                  },
                  child: const Text('EXPLORE FASHION'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'A J I O',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'serif',
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
            color: AjioTheme.darkSlate,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AjioTheme.ajioGold),
                  SizedBox(height: 16),
                  Text(
                    'AUTHENTICATING SECURELY...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: AjioTheme.darkSlate,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Header Promos
                    Text(
                      _isSignUpMode ? 'CREATE AN ACCOUNT' : 'WELCOME BACK',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: AjioTheme.darkSlate,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isSignUpMode
                          ? 'Join the AJIO VIP Club and grab flat 15% off your first purchase!'
                          : 'Sign in to access your bag, saved items, and order history.',
                      style: const TextStyle(fontSize: 12, color: AjioTheme.textGrey),
                    ),
                    const SizedBox(height: 28),

                    // LogIn Tab selector (only on LogIn mode)
                    if (!_isSignUpMode) ...[
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isOtpLogin = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: !_isOtpLogin ? AjioTheme.darkSlate : AjioTheme.borderGrey,
                                      width: !_isOtpLogin ? 2 : 1,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'EMAIL & PASSWORD',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: !_isOtpLogin ? AjioTheme.darkSlate : AjioTheme.textGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isOtpLogin = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _isOtpLogin ? AjioTheme.darkSlate : AjioTheme.borderGrey,
                                      width: _isOtpLogin ? 2 : 1,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'MOBILE NUMBER (OTP)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _isOtpLogin ? AjioTheme.darkSlate : AjioTheme.textGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Input Form Fields
                    if (_isSignUpMode) ...[
                      // Name Input
                      const Text('FULL NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
                        decoration: const InputDecoration(
                          hintText: 'Enter your first & last name',
                          prefixIcon: Icon(Icons.person_outline, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email Field
                    if (!_isOtpLogin || _isSignUpMode) ...[
                      const Text('EMAIL ADDRESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter email';
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'e.g. safwan@example.com',
                          prefixIcon: Icon(Icons.email_outlined, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Phone Field (SignUp or OTP Login)
                    if (_isSignUpMode || _isOtpLogin) ...[
                      const Text('MOBILE NUMBER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: AjioTheme.lightGrey,
                            alignment: Alignment.center,
                            child: const Text('+91', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter mobile number';
                                if (value.length < 10) return 'Enter a valid 10-digit number';
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: '10-digit number',
                                counterText: '',
                                prefixIcon: Icon(Icons.phone_outlined, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Password Field (Regular Login or SignUp)
                    if (!_isOtpLogin || _isSignUpMode) ...[
                      const Text('PASSWORD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter password';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter account password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 18),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              size: 18,
                              color: AjioTheme.textGrey,
                            ),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),
                      ),
                    ],

                    // OTP verification workspace (OTP Login Mode)
                    if (!_isSignUpMode && _isOtpLogin) ...[
                      if (_isOtpSent) ...[
                        const Text('ENTER OTP CODE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: (value) => value == null || value.length < 4 ? 'Enter 4-digit code' : null,
                          decoration: const InputDecoration(
                            hintText: 'Enter mock code [1234]',
                            counterText: '',
                            prefixIcon: Icon(Icons.security, size: 18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _otpCountdown > 0 ? 'Resend OTP in ${_otpCountdown}s' : 'Didn’t receive code?',
                              style: const TextStyle(fontSize: 11, color: AjioTheme.textGrey),
                            ),
                            if (_otpCountdown == 0)
                              TextButton(
                                onPressed: _mockSendOtp,
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                child: const Text(
                                  'RESEND OTP',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AjioTheme.ajioGold),
                                ),
                              ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _mockSendOtp,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AjioTheme.ajioGold, width: 1.2),
                              foregroundColor: AjioTheme.ajioGold,
                            ),
                            child: const Text('GET OTP CODE'),
                          ),
                        ),
                      ],
                    ],

                    // Terms conditions agreement (SignUp only)
                    if (_isSignUpMode) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _termsAgreed,
                              activeColor: AjioTheme.darkSlate,
                              onChanged: (val) => setState(() => _termsAgreed = val ?? true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'By signing up, I agree to AJIO’s Privacy Policy and Terms and Conditions of use.',
                              style: TextStyle(fontSize: 11, color: AjioTheme.textGrey),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Primary Submit Button
                    if (!_isOtpLogin || _isSignUpMode || _isOtpSent)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(_isSignUpMode ? 'CREATE ACCOUNT' : 'SIGN IN'),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Alternating Switch Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isSignUpMode ? 'Already have an account?' : 'New to AJIO?',
                          style: const TextStyle(fontSize: 12, color: AjioTheme.textGrey),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSignUpMode = !_isSignUpMode;
                              _isOtpSent = false;
                              _formKey.currentState?.reset();
                            });
                          },
                          child: Text(
                            _isSignUpMode ? 'SIGN IN' : 'CREATE ACCOUNT',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AjioTheme.ajioGold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),
                    const Divider(color: AjioTheme.borderGrey),
                    const SizedBox(height: 24),

                    // Social login header
                    const Center(
                      child: Text(
                        'OR SIGN IN WITH',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AjioTheme.textGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Social icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(Icons.g_mobiledata, 'Google', Colors.red.shade700),
                        const SizedBox(width: 16),
                        _buildSocialButton(Icons.apple, 'Apple', Colors.black),
                        const SizedBox(width: 16),
                        _buildSocialButton(Icons.facebook, 'Facebook', Colors.blue.shade900),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        // Mock social authentication
        final store = Provider.of<StoreProvider>(context, listen: false);
        store.login('Safwan', 'safwan@social.com', '9876543210');
        _showAuthSuccessSheet('Signed in with $label successfully!');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AjioTheme.borderGrey),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AjioTheme.darkSlate),
            ),
          ],
        ),
      ),
    );
  }
}
