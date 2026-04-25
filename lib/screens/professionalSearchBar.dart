// ═══════════════════════════════════════════════════════════
//  professional_search_bar.dart — fixed isSelected, themed
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/home_bloc.dart';
import '../shared/app_colors.dart';

class ProfessionalSearchBar extends StatefulWidget {
  const ProfessionalSearchBar({super.key});

  @override
  State<ProfessionalSearchBar> createState() =>
      _ProfessionalSearchBarState();
}

class _ProfessionalSearchBarState extends State<ProfessionalSearchBar> {
  final _ctrl = TextEditingController();
  bool _hasFocus = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    setState(() => _hasFocus = val.isNotEmpty);
    final state = context.read<HomeBloc>().state;
    final cat =
        state is HomeLoaded ? state.selectedCategory : 'الكل';
    context.read<HomeBloc>().add(FilterProducts(val, cat));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasFocus ? c.gold.withOpacity(0.5) : c.border,
          width: _hasFocus ? 1.0 : 0.5,
        ),
      ),
      child: TextField(
        controller: _ctrl,
        onChanged: _onChanged,
        style: TextStyle(color: c.textPrimary, fontSize: 14),
        cursorColor: c.gold,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.search_rounded,
                color: _hasFocus ? c.gold : c.textMuted, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44),
          hintText: 'ما الذي تبحث عنه اليوم؟',
          hintStyle: TextStyle(color: c.textMuted, fontSize: 13),
          suffixIcon: GestureDetector(
            onTap: () => _showFilterSheet(context, c),
            child: Container(
              margin: const EdgeInsets.all(6),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: c.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext ctx, AppColors c) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _FilterSheet(c: c, bloc: ctx.read<HomeBloc>()),
    );
  }
}

// ── Filter Sheet ─────────────────────────────────────────
class _FilterSheet extends StatefulWidget {
  final AppColors c;
  final HomeBloc bloc;
  const _FilterSheet({required this.c, required this.bloc});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String _selected = '';

  final _options = const [
    ('الأكثر شيوعاً', Icons.star_outline_rounded, 'popular'),
    ('وصل حديثاً', Icons.auto_awesome_rounded, 'newest'),
    ('السعر: من الأقل', Icons.arrow_downward_rounded, 'price_low'),
    ('السعر: من الأعلى', Icons.arrow_upward_rounded, 'price_high'),
    ('الأعلى تقييماً', Icons.thumb_up_outlined, 'rating'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(20),

          Align(
            alignment: Alignment.centerRight,
            child: Text('ترتيب النتائج',
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
          ),
          const Gap(4),
          Align(
            alignment: Alignment.centerRight,
            child: Text('اختر طريقة عرض المنتجات',
                style:
                    TextStyle(color: c.textSecondary, fontSize: 12)),
          ),
          const Gap(20),

          // خيارات الترتيب — isSelected مربوط بـ _selected
          ...(_options.map((opt) => GestureDetector(
                onTap: () {
                  setState(() => _selected = opt.$3);
                  widget.bloc.add(SortProducts(opt.$3));
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: c.borderLight, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(opt.$2,
                          color: _selected == opt.$3
                              ? c.gold
                              : c.textSecondary,
                          size: 20),
                      const Gap(14),
                      Text(opt.$1,
                          style: TextStyle(
                            color: _selected == opt.$3
                                ? c.gold
                                : c.textPrimary,
                            fontSize: 14,
                            fontWeight: _selected == opt.$3
                                ? FontWeight.w600
                                : FontWeight.w400,
                          )),
                      const Spacer(),
                      if (_selected == opt.$3)
                        Icon(Icons.check_rounded,
                            color: c.gold, size: 18),
                    ],
                  ),
                ),
              ))),

          const Gap(20),

          // زر إغلاق
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: c.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.border, width: 0.5),
              ),
              child: Center(
                child: Text('إغلاق',
                    style: TextStyle(
                        color: c.textSecondary,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
