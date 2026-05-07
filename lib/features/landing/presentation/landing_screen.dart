import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/status_colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHero(context),
                _buildFeatures(),
                _buildPreviewSection(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── HERO ──────────────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 64, 28, 56),
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Column(
        children: [
          // Logo + Nav row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.work_outline, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ResumeTrack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Sign in', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.accent.withOpacity(0.2)),
            ),
            child: const Text(
              '✦  Offline-first · No internet required',
              style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 28),

          // Headline
          const Text(
            'Build smarter resumes.\nTrack every application.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -1.2,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'One focused place to manage your career journey —\nresumes, applications, analytics, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // CTA Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get started for free',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(color: AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 52),

          // Mock dashboard preview card
          _buildHeroPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildHeroPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: Color(0xFFFF5F57), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Dashboard Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('12', 'Applications', AppColors.accent),
              const SizedBox(width: 10),
              _buildStatChip('3', 'Interviews', AppColors.statusInterview),
              const SizedBox(width: 10),
              _buildStatChip('2', 'Selected', AppColors.statusSelected),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            ('Google', 'Software Engineer', 'Interview Scheduled'),
            ('Stripe', 'Flutter Developer', 'Applied'),
            ('Notion', 'Product Analyst', 'Shortlisted'),
          ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primary)),
                    Text(item.$2, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.getStatusColor(item.$3).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.$3,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.getStatusTextColor(item.$3)),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatChip(String number, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(number, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
          ],
        ),
      ),
    );
  }

  // ── FEATURES ──────────────────────────────────────────────────────────────
  Widget _buildFeatures() {
    final features = [
      (Icons.description_outlined, 'Resume Builder', 'Create structured, polished resumes for every role you apply to.'),
      (Icons.track_changes_outlined, 'Application Tracking', 'Log every application with company, role, and date in one place.'),
      (Icons.bar_chart_rounded, 'Dashboard Analytics', 'See your pipeline at a glance — status breakdowns and trends.'),
      (Icons.cloud_off_outlined, 'Offline First', 'All your data is stored locally. No internet needed to stay productive.'),
      (Icons.copy_all_outlined, 'Resume Versioning', 'Map different resume versions to specific job applications.'),
      (Icons.search_outlined, 'Smart Search', 'Instantly filter applications by company, role, or status.'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      color: AppColors.background,
      child: Column(
        children: [
          const Text(
            'Everything you need to\nland your next role',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.8,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Purpose-built features for serious job seekers.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondaryText, fontSize: 15),
          ),
          const SizedBox(height: 36),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final f = features[index];
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(f.$1, color: AppColors.accent, size: 22),
                    ),
                    const SizedBox(height: 14),
                    Text(f.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primary)),
                    const SizedBox(height: 6),
                    Text(f.$3, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.5)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── APP PREVIEW ───────────────────────────────────────────────────────────
  Widget _buildPreviewSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      color: AppColors.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.statusSelected.withOpacity(0.15),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              '✓  Trusted by students & professionals',
              style: TextStyle(color: Color(0xFF064E3B), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'A complete career\nmanagement system',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.8,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          _buildPreviewCard(
            icon: Icons.dashboard_outlined,
            color: AppColors.accent,
            title: 'Unified Dashboard',
            subtitle: 'All your job search data in one clean, organized view.',
          ),
          const SizedBox(height: 14),
          _buildPreviewCard(
            icon: Icons.edit_note_outlined,
            color: AppColors.statusSelected,
            title: 'Resume Profiles',
            subtitle: 'Build and manage multiple resume versions for different roles.',
          ),
          const SizedBox(height: 14),
          _buildPreviewCard(
            icon: Icons.timeline_outlined,
            color: AppColors.statusInterview,
            title: 'Application Pipeline',
            subtitle: 'Track every stage from Applied → Interview → Selected.',
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text(
                'Start tracking for free →',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.secondaryText),
        ],
      ),
    );
  }

  // ── FOOTER ────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      color: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.work_outline, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('ResumeTrack', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _footerLink('About'),
              const SizedBox(width: 20),
              _footerLink('Privacy'),
              const SizedBox(width: 20),
              _footerLink('Contact'),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© 2025 ResumeTrack', style: TextStyle(color: Colors.white38, fontSize: 12)),
              Text('v1.0.0', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String label) {
    return Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w500));
  }
}
