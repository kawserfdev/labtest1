import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labtest1/app_routes.dart';
import 'package:labtest1/providers/loginState.dart';

class LandDevelopmentLoginPage extends ConsumerWidget {
  const LandDevelopmentLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sateRef = ref.watch(stateChangeNotifierProvider);
    final sateNotifire = ref.watch(stateChangeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bgImage.jpg"),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch(
                      value: sateRef.langChange,
                      onChanged: (val) {
                        if (!sateRef.langChange) {
                          sateNotifire.setLangChange(true);
                        } else {
                          sateNotifire.setLangChange(false);
                        }
                      },
                      activeColor:
                          !sateRef.langChange ? Colors.grey : Colors.green,
                    ),
                    const Text(
                      'বাং',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'ভূমি উন্নয়ন কর ব্যবস্থাপনা সিস্টেমে\nআপনাকে স্বাগতম !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _buildLoginButton(
                      icon: Icons.person,
                      text: 'নাগরিক লগইন',
                      onPressed:
                          () => Navigator.pushNamed(context, AppRoutes.login),
                    ),
                    const SizedBox(height: 12),
                    _buildLoginButton(
                      icon: Icons.apartment,
                      text: 'সংস্থা লগইন',
                      onPressed:
                          () => Navigator.pushNamed(context, AppRoutes.login),
                    ),
                    const SizedBox(height: 12),
                    _buildLoginButton(
                      icon: Icons.work,
                      text: 'অফিস লগইন',
                      onPressed:
                          () => Navigator.pushNamed(context, AppRoutes.login),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon),
        label: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
