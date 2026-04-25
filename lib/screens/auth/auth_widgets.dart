import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════
//  ALHELAL PRIME — Auth Widgets
//  Refined luxury dark UI — no glow, clean & professional
// ═══════════════════════════════════════════════════════════

// ── Brand Colors (single source of truth) ──────────────────
abstract class AuthColors {
  static const bg = Color(0xFF080808);
  static const surface = Color(0xFF111111);
  static const surfaceHigh = Color(0xFF1A1A1A);
  static const border = Color(0xFF242424);
  static const borderFocus = Color(0xFFE8960C);
  static const gold = Color(0xFFE8960C);
  static const goldDim = Color(0xFFA86A08);
  static const white = Colors.white;
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF888888);
  static const textMuted = Color(0xFF444444);
  static const error = Color(0xFFE05252);
}

// ══════════════════════════════════════════════════════════
//  AuthField
// ══════════════════════════════════════════════════════════
class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const AuthField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.isVisible = false,
    this.onToggleVisibility,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _focused = false;
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = widget.focusNode ?? FocusNode();
    _node.addListener(() => setState(() => _focused = _node.hasFocus));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: TextStyle(
            color: _focused ? AuthColors.gold : AuthColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),

        // Field
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AuthColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focused ? AuthColors.borderFocus : AuthColors.border,
              width: _focused ? 1.0 : 0.5,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _node,
            obscureText: widget.isPassword && !widget.isVisible,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: const TextStyle(
              color: AuthColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AuthColors.gold,
            cursorWidth: 1.5,
            decoration: InputDecoration(
              filled: false,
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: AuthColors.textMuted,
                fontSize: 13,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(
                  widget.icon,
                  color: _focused ? AuthColors.gold : AuthColors.textMuted,
                  size: 18,
                ),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        widget.isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AuthColors.textMuted,
                        size: 18,
                      ),
                      onPressed: widget.onToggleVisibility,
                      splashRadius: 20,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: const TextStyle(
                color: AuthColors.error,
                fontSize: 11,
                height: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  AuthPrimaryButton
// ══════════════════════════════════════════════════════════
class AuthPrimaryButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.isLoading) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: widget.isLoading ? AuthColors.goldDim : AuthColors.gold,
            borderRadius: BorderRadius.circular(12),
            // No glow — clean flat shadow only
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  AuthBackButton
// ══════════════════════════════════════════════════════════
class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AuthColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AuthColors.border, width: 0.5),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AuthColors.textSecondary,
          size: 16,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  AuthSocialButton
// ══════════════════════════════════════════════════════════
class AuthSocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const AuthSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<AuthSocialButton> createState() => _AuthSocialButtonState();
}

class _AuthSocialButtonState extends State<AuthSocialButton> {
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
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: AuthColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AuthColors.border, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AuthColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  AuthDivider
// ══════════════════════════════════════════════════════════
class AuthDivider extends StatelessWidget {
  final String label;
  const AuthDivider({super.key, this.label = 'أو'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 0.5, color: AuthColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: const TextStyle(color: AuthColors.textMuted, fontSize: 12),
          ),
        ),
        Expanded(child: Container(height: 0.5, color: AuthColors.border)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  AuthHeader  (logo + title + subtitle)
// ══════════════════════════════════════════════════════════
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand mark
        Row(
          children: [
            Container(width: 20, height: 0.5, color: AuthColors.gold),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'ALHELAL ',
                    style: TextStyle(
                      color: AuthColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.5,
                    ),
                  ),
                  TextSpan(
                    text: 'PRIME',
                    style: TextStyle(
                      color: AuthColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Title
        Text(
          title,
          style: const TextStyle(
            color: AuthColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          style: const TextStyle(
            color: AuthColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
