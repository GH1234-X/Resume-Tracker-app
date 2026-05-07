import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/utils/status_colors.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // Password strength 0-3
  int get _passwordStrength {
    final p = _passwordController.text;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#\$&*~%^]'))) score++;
    return score;
  }

  Color get _strengthColor {
    switch (_passwordStrength) {
      case 1: return const Color(0xFFFCA5A5);
      case 2: return const Color(0xFFFCD34D);
      case 3: return const Color(0xFF6EE7B7);
      case 4: return const Color(0xFF059669);
      default: return AppColors.border;
    }
  }

  String get _strengthLabel {
    switch (_passwordStrength) {
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Strong';
      default: return '';
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go('/');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => context.go('/landing'),
                    borderRadius: BorderRadius.circular(8),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios, size: 16, color: AppColors.secondaryText),
                        SizedBox(width: 4),
                        Text('Back', style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Logo
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.work_outline, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start managing your career for free. No internet needed.',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 36),

                  // Error banner
                  if (authState.error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.statusRejected.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.statusRejected.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.statusRejected, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(authState.error!, style: const TextStyle(color: Color(0xFF7F1D1D), fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline, color: AppColors.secondaryText),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Name is required';
                            if (v.trim().length < 2) return 'Enter your full name';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.secondaryText),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email is required';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.secondaryText),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.secondaryText,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password is required';
                            if (v.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),

                        // Strength Indicator
                        if (_passwordController.text.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ...List.generate(4, (i) => Expanded(
                                child: Container(
                                  height: 4,
                                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                                  decoration: BoxDecoration(
                                    color: i < _passwordStrength ? _strengthColor : AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10),
                              Text(
                                _strengthLabel,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _strengthColor),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.secondaryText),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.secondaryText,
                              ),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please confirm your password';
                            if (v != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                              disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20, width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Offline badge
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.statusSelected.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: AppColors.statusSelected.withOpacity(0.3)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cloud_off_outlined, size: 14, color: Color(0xFF064E3B)),
                                SizedBox(width: 6),
                                Text(
                                  'Your data is stored 100% offline',
                                  style: TextStyle(color: Color(0xFF064E3B), fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? ', style: TextStyle(color: AppColors.secondaryText)),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
