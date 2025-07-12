//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labtest1/app_routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isMobileSelected = true;
  String _generatedCaptcha = 'IQYKRDY';

  final List<String> _bdOperatorPrefixes = [
    '013',
    '014',
    '015',
    '016',
    '017',
    '018',
    '019',
    '013',
    '014',
    '017',
    '019',
    '015',
    '016',
    '017',
    '018',
    '019',
    '017',
    '013',
    '014',
    '015',
    '016',
    '018',
    '019',
  ];

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    _generatedCaptcha = String.fromCharCodes(
      Iterable.generate(
        7,
        (_) => chars.codeUnitAt(
          (chars.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)
              .floor(),
        ),
      ),
    );
    setState(() {});
  }

  String? _validateBDPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'মোবাইল নম্বর প্রয়োজন';
    }

    String cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.startsWith('880')) {
      cleanNumber = cleanNumber.substring(3);
    }

    if (cleanNumber.length != 11) {
      return 'বাংলাদেশী মোবাইল নম্বর ১১ ডিজিটের হতে হবে';
    }

    if (!cleanNumber.startsWith('01')) {
      return 'বাংলাদেশী মোবাইল নম্বর ০১ দিয়ে শুরু হতে হবে';
    }
    String prefix = cleanNumber.substring(0, 3);
    bool isValidPrefix = _bdOperatorPrefixes.any((p) => prefix.startsWith(p));

    if (!isValidPrefix) {
      return 'অবৈধ বাংলাদেশী মোবাইল নম্বর';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'পাসওয়ার্ড প্রয়োজন';
    }
    if (value.length < 6) {
      return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
    }
    return null;
  }

  String? _validateCaptcha(String? value) {
    if (value == null || value.isEmpty) {
      return 'ক্যাপচা কোড প্রয়োজন';
    }
    if (value.toUpperCase() != _generatedCaptcha.toUpperCase()) {
      return 'ক্যাপচা কোড সঠিক নয়';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text('লগইন সফল হয়েছে!'),
              backgroundColor: Colors.green,
            ),
          )
          .closed;
      Navigator.pushNamed(context, AppRoutes.repositories);
    }
  }

  void _handleRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('নিবন্ধন পেজে নিয়ে যাওয়া হচ্ছে...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'ট',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  'লগইন',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _isMobileSelected,
                            onChanged: (value) {
                              setState(() {
                                _isMobileSelected = value!;
                              });
                            },
                            activeColor: Color(0xFF2E7D32),
                          ),
                          Text('মোবাইল'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: _isMobileSelected,
                            onChanged: (value) {
                              setState(() {
                                _isMobileSelected = !value!;
                              });
                            },
                            activeColor: Color(0xFF2E7D32),
                          ),
                          Text('ইমেইল'),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        '+880',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          hintText: 'মোবাইল নম্বর (ইংরেজিতে)*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        validator: _validateBDPhoneNumber,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'পাসওয়ার্ড*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Text(
                      'ক্যাপচা : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        _generatedCaptcha,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _generateCaptcha,
                    ),
                  ],
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _captchaController,
                  decoration: InputDecoration(
                    hintText: 'ক্যাপচা লিখুন*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  validator: _validateCaptcha,
                ),

                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'লগইন করুন',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextButton(
                  onPressed: _handleRegistration,
                  child: Text(
                    'রেজিস্ট্রেশন করুন',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }
}
