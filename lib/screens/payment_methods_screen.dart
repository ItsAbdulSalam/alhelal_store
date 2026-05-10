import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('طرق الدفع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Column(
            children: [
              const Gap(20),
              // ── قائمة البطاقات ──
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.paymentCards.length,
                  itemBuilder: (context, i) {
                    final card = state.paymentCards[i];
                    final isSelected = state.selectedCardIndex == i;
                    return GestureDetector(
                      onTap: () =>
                          context.read<ProfileBloc>().add(SelectPaymentCard(i)),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(left: 14, bottom: 10),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Color(card['color'] as int),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      card['type'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.contactless_outlined,
                                      color: Colors.white54,
                                    ),
                                  ],
                                ),
                                Text(
                                  card['number'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'ALHELAL PRIME',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      card['expiry'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // زر التعديل
                          Positioned(
                            top: 8,
                            right: 22,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white70,
                                size: 18,
                              ),
                              onPressed: () =>
                                  _showCardDialog(context, index: i),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Gap(24),

              // ── زر إضافة بطاقة ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _showCardDialog(context),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          size: 20,
                        ),
                        const Gap(8),
                        Text(
                          'إضافة بطاقة جديدة',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ── زر التأكيد ──
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم اختيار طريقة الدفع بنجاح'),
                        backgroundColor: Colors.green.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'تأكيد طريقة الدفع',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCardDialog(BuildContext context, {int? index}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.read<ProfileBloc>().state;

    final numCtrl = TextEditingController(
      text: index != null ? state.paymentCards[index]['number'] as String : '',
    );
    final expCtrl = TextEditingController(
      text: index != null ? state.paymentCards[index]['expiry'] as String : '',
    );
    final String type = index != null
        ? state.paymentCards[index]['type'] as String
        : 'Visa';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(20),
            Text(
              index == null ? 'إضافة بطاقة' : 'تعديل البطاقة',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            TextField(
              controller: numCtrl,
              keyboardType: TextInputType.number,
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                labelText: 'رقم البطاقة',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.credit_card, color: Colors.orange),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF111111)
                    : const Color(0xFFF9F9F9),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFF0F0F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const Gap(14),
            TextField(
              controller: expCtrl,
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                labelText: 'تاريخ الانتهاء (MM/YY)',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.orange,
                ),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF111111)
                    : const Color(0xFFF9F9F9),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFF0F0F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const Gap(20),
            GestureDetector(
              onTap: () {
                final card = {
                  'type': type,
                  'number': numCtrl.text.trim().isEmpty
                      ? '**** **** **** ****'
                      : numCtrl.text.trim(),
                  'expiry': expCtrl.text.trim().isEmpty
                      ? '--/--'
                      : expCtrl.text.trim(),
                  'color': index != null
                      ? state.paymentCards[index]['color']
                      : 0xFF1A1A1A,
                };
                if (index == null) {
                  context.read<ProfileBloc>().add(AddPaymentCard(card));
                } else {
                  context.read<ProfileBloc>().add(
                    UpdatePaymentCard(index, card),
                  );
                }
                Navigator.pop(sheetCtx);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'حفظ البطاقة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
