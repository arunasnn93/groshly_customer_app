import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../domain/entities/auth_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/google_sign_in_button.dart';

/// Login page for user authentication
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isSignUpMode = false;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authProvider);
    final isLoading = ref.watch(authLoadingProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final errorMessage = ref.watch(authErrorProvider);

    // Listen to authentication state changes
    ref.listen<bool>(isAuthenticatedProvider, (previous, next) {
      if (next) {
        context.go(RouteConstants.home);
      }
    });

    // Listen to error messages
    ref.listen<String?>(authErrorProvider, (previous, next) {
      if (next != null) {
        context.showErrorSnackBar(next);
      }
    });

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  
                  // Logo and title
                  _buildHeader(),
                  
                  const SizedBox(height: 32),
                  
                  // Sign in/up toggle
                  _buildModeToggle(),
                  
                  const SizedBox(height: 32),
                  
                  // Name field (only for sign up)
                  if (_isSignUpMode) ...[
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateName,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password field
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    onFieldSubmitted: (_) => _handleEmailPasswordAuth(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit button
                  CustomButton(
                    text: _isSignUpMode ? 'Sign Up' : 'Sign In',
                    onPressed: _handleEmailPasswordAuth,
                    isLoading: isLoading,
                  ),
                  
                  if (!_isSignUpMode) ...[
                    const SizedBox(height: 16),
                    
                    // Forgot password
                    TextButton(
                      onPressed: _handleForgotPassword,
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Google Sign In
                  GoogleSignInButton(
                    onPressed: () => authService.signInWithGoogleAccount(),
                    isLoading: isLoading,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Terms and privacy (for sign up)
                  if (_isSignUpMode) _buildTermsAndPrivacy(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App logo
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/icons/app_icon.png',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          AppConstants.appName,
          style: AppTextStyles.heading2.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 4),
        
        Text(
          AppConstants.appTagline,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignUpMode
              ? 'Already have an account?'
              : "Don't have an account?",
          style: AppTextStyles.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isSignUpMode = !_isSignUpMode;
            });
            // Clear form
            _formKey.currentState?.reset();
            _emailController.clear();
            _passwordController.clear();
            _nameController.clear();
          },
          child: Text(
            _isSignUpMode ? 'Sign In' : 'Sign Up',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndPrivacy() {
    return Text.rich(
      TextSpan(
        text: 'By signing up, you agree to our ',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppTheme.textSecondary,
        ),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTheme.primaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTheme.primaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  void _handleEmailPasswordAuth() {
    if (!_formKey.currentState!.validate()) return;

    final authService = ref.read(authProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isSignUpMode) {
      final name = _nameController.text.trim();
      authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
    } else {
      authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.isEmpty) {
      context.showErrorSnackBar('Please enter your email address');
      return;
    }

    final authService = ref.read(authProvider);
    authService.sendPasswordResetEmail(_emailController.text.trim());
    context.showSuccessSnackBar('Password reset email sent!');
  }
}