import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:first_store/screens/auth/auth_welcome_screen.dart';

// ════════════════════════════════════════════
//  ALHELAL PRIME — Onboarding Screen v2
//  Clean, luxury dark — refined & minimal
// ════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _textAnimController;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  // ── Brand Colors ──────────────────────────
  static const Color _gold = Color(0xFFE8960C);
  static const Color _goldLight = Color(0xFFF5B53F);
  static const Color _bg = Color(0xFF080808);

  final List<_PageData> _pages = const [
    _PageData(
      title: 'أحدث التقنيات',
      desc:
          'اكتشف تشكيلة واسعة من أحدث أجهزة الآيفون، الساعات الذكية، والسماعات الأصلية في مكان واحد.',
      image: 'assets/SplashScreen/1.jpeg',
      tag: 'NEW ARRIVALS',
    ),
    _PageData(
      title: 'دفع آمن وسريع',
      desc:
          'نوفر لك خيارات دفع متعددة وآمنة تماماً لضمان أفضل تجربة شراء لعملائنا في إسطنبول.',
      image: 'assets/SplashScreen/2.jpeg',
      tag: 'SECURE',
    ),
    _PageData(
      title: 'توصيل لباب بيتك',
      desc:
          'استمتع بخدمة توصيل سريعة وموثوقة لجميع مشترياتك بأعلى معايير الجودة.',
      image: 'assets/SplashScreen/3.jpeg',
      tag: 'EXPRESS',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _textAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _textFade = CurvedAnimation(
      parent: _textAnimController,
      curve: Curves.easeOut,
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    _textAnimController.forward();
  }

  @override
  void dispose() {
    _textAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    setState(() => _currentPage = i);
    _textAnimController.forward(from: 0);
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutQuart,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const AuthWelcomeScreen(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  void _skip() {
    HapticFeedback.selectionClick();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthWelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final top = MediaQuery.of(context).padding.top;
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Scrollable Pages ─────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (_, i) => _buildPage(_pages[i], top),
          ),

          // ── Skip Button ──────────────────────
          if (!isLast)
            Positioned(
              top: top + 14,
              right: 20,
              child: GestureDetector(
                onTap: _skip,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

          // ── Bottom Area ──────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(28, 24, 28, bottom + 28),
              // subtle top fade so content blends up
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_bg.withOpacity(0), _bg, _bg],
                  stops: const [0.0, 0.18, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => _Dot(active: i == _currentPage, gold: _gold),
                    ),
                  ),
                  const Gap(28),

                  // CTA Button
                  _CTAButton(
                    isLast: isLast,
                    onTap: _next,
                    gold: _gold,
                    goldLight: _goldLight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_PageData data, double topPadding) {
    return Column(
      children: [
        // ── Image Half ─────────────────────────
        Expanded(
          flex: 52,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(data.image, fit: BoxFit.cover),

              // Dark vignette top
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.75, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                      Colors.transparent,
                      _bg,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Text Half ──────────────────────────
        Expanded(
          flex: 48,
          child: ColoredBox(
            color: _bg,
            child: FadeTransition(
              opacity: _textFade,
              child: SlideTransition(
                position: _textSlide,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(28),

                      // Brand wordmark — refined, not floating
                      const _BrandWordmark(gold: _gold),

                      const Gap(24),

                      // Tiny tag
                      _Tag(text: data.tag, gold: _gold),

                      const Gap(14),

                      // Title
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const Gap(12),

                      // Description
                      Text(
                        data.desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 14,
                          height: 1.75,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      // Push bottom controls down
                      const Spacer(),
                      const Gap(110),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════
//  Sub-widgets
// ════════════════════════════════════════════

// ── Brand Wordmark (inline, not floating) ──
class _BrandWordmark extends StatelessWidget {
  final Color gold;
  const _BrandWordmark({required this.gold});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Thin divider line
        Container(width: 28, height: 0.5, color: gold.withOpacity(0.4)),
        const Gap(12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ALHELAL ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3.5,
                ),
              ),
              TextSpan(
                text: 'PRIME',
                style: TextStyle(
                  color: gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.5,
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        Container(width: 28, height: 0.5, color: gold.withOpacity(0.4)),
      ],
    );
  }
}

// ── Small category tag ──────────────────────
class _Tag extends StatelessWidget {
  final String text;
  final Color gold;
  const _Tag({required this.text, required this.gold});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: gold.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: gold.withOpacity(0.85),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.5,
        ),
      ),
    );
  }
}

// ── Animated dot indicator ──────────────────
class _Dot extends StatelessWidget {
  final bool active;
  final Color gold;
  const _Dot({required this.active, required this.gold});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      height: 4,
      width: active ? 24 : 4,
      decoration: BoxDecoration(
        color: active ? gold : Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ── CTA Button ──────────────────────────────
class _CTAButton extends StatefulWidget {
  final bool isLast;
  final VoidCallback onTap;
  final Color gold;
  final Color goldLight;

  const _CTAButton({
    required this.isLast,
    required this.onTap,
    required this.gold,
    required this.goldLight,
  });

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            // ── Key change: removed strong glow, softer gradient ──
            gradient: LinearGradient(
              colors: widget.isLast
                  ? [widget.gold, widget.goldLight]
                  : [
                      widget.gold.withOpacity(0.9),
                      widget.goldLight.withOpacity(0.9),
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            // Subtle shadow — not a glow ring
            boxShadow: [
              BoxShadow(
                color: widget.gold.withOpacity(_pressed ? 0.15 : 0.22),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isLast ? 'ابدأ الآن' : 'التالي',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                if (!widget.isLast) ...[
                  const Gap(8),
                  const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 13,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Data model ──────────────────────────────
class _PageData {
  final String title;
  final String desc;
  final String image;
  final String tag;

  const _PageData({
    required this.title,
    required this.desc,
    required this.image,
    required this.tag,
  });
}
