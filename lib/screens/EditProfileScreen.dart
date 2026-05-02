import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/services/database_service.dart';
import 'package:first_store/services/notification_service.dart'; // ✅ استيراد الخدمة
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    _nameCtrl = TextEditingController(text: state.name);
    _emailCtrl = TextEditingController(text: state.email);
    _phoneCtrl = TextEditingController(text: state.phone);
  }

  Future<void> _updatePhoto() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جاري رفع الصورة...'),
            duration: Duration(seconds: 1),
          ),
        );

        try {
          final downloadUrl = await DatabaseService().uploadProfileImage(
            File(image.path),
            uid,
          );

          if (!mounted) return;

          context.read<ProfileBloc>().add(UpdateAvatar(newPath: downloadUrl!));

          // ✅ إرسال إشعار عند نجاح تغيير الصورة
          await NotificationService.instance.sendNotification(
            title: "تحديث الصورة الشخصية ✨",
            body: "يا سلام، لقد قمت بتغيير صورتك الشخصية بنجاح.",
            type: "promo",
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الصورة بنجاح ✓'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل تحديث الصورة: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isSaved) {
          // ✅ التعديل الاحترافي: إرسال الإشعار فور تأكيد الحفظ من البلوك
          NotificationService.instance.notifyProfileUpdate();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم تحديث البيانات بنجاح ✓'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.pop(context);
        }
        if (state.status == ProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'حدث خطأ في الاتصال'),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تعديل الملف الشخصي',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _updatePhoto,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            return CircleAvatar(
                              radius: 55,
                              backgroundColor: isDark
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFF5F5F5),
                              backgroundImage:
                                  (state.avatarPath.isNotEmpty &&
                                      state.avatarPath.startsWith('http'))
                                  ? NetworkImage(state.avatarPath)
                                  : const AssetImage('assets/images/me.jpg')
                                        as ImageProvider,
                              child: (state.avatarPath.isEmpty)
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 55,
                                      color: isDark
                                          ? Colors.grey[700]
                                          : Colors.grey[400],
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF0F0F0F)
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(36),
                _ProfileField(
                  label: 'الاسم الكامل',
                  controller: _nameCtrl,
                  icon: Icons.person_outline_rounded,
                  isDark: isDark,
                  validator: (v) => v!.trim().isEmpty ? 'الاسم مطلوب' : null,
                ),
                const Gap(16),
                _ProfileField(
                  label: 'البريد الإلكتروني',
                  controller: _emailCtrl,
                  icon: Icons.email_outlined,
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.contains('@') ? null : 'بريد غير صحيح',
                ),
                const Gap(16),
                _ProfileField(
                  label: 'رقم الهاتف',
                  controller: _phoneCtrl,
                  icon: Icons.phone_outlined,
                  isDark: isDark,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.trim().isEmpty ? 'الهاتف مطلوب' : null,
                ),
                const Gap(40),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isSaving = state.status == ProfileStatus.saving;
                    return GestureDetector(
                      onTap: isSaving
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                context.read<ProfileBloc>().add(
                                  UpdateProfile(
                                    name: _nameCtrl.text.trim(),
                                    email: _emailCtrl.text.trim(),
                                    phone: _phoneCtrl.text.trim(),
                                  ),
                                );
                              }
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          color: isSaving
                              ? Colors.orange.shade700
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'حفظ التغييرات',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isDark;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.isDark,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: Colors.orange,
          style: TextStyle(
            color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.orange, size: 20),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFF9F9F9),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF0F0F0),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.orange, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
