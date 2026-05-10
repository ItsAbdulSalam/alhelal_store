import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/services/database_service.dart';
import 'package:first_store/services/notification_service.dart';
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
  String? _currentFirestoreAvatar; // لتخزين الصورة القادمة من الفايربيز

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();

    // جلب البيانات الأولية من البلوك الحالي
    final state = context.read<ProfileBloc>().state;
    _nameCtrl.text = state.name;
    _emailCtrl.text = state.email;
    _phoneCtrl.text = state.phone;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePhoto() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image == null) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final downloadUrl = await DatabaseService().updateProfileImage(
        File(image.path),
        uid,
      );
      if (downloadUrl != null && mounted) {
        context.read<ProfileBloc>().add(UpdateAvatar(newPath: downloadUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الصورة بنجاح ✓'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) debugPrint("Error updating photo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isSaved) {
          NotificationService.instance.notifyProfileUpdate();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الملف الشخصي'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              _currentFirestoreAvatar =
                  data['profilePic'] ?? data['imagePath'] ?? data['avatarPath'];

              // تحديث النصوص فقط إذا كانت فارغة (عند أول تحميل)
              if (_nameCtrl.text.isEmpty) {
                _nameCtrl.text = data['fullName'] ?? "";
              }
              if (_phoneCtrl.text.isEmpty) {
                _phoneCtrl.text = data['phone'] ?? "";
              }
              if (_emailCtrl.text.isEmpty) _emailCtrl.text = user?.email ?? "";
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // قسم الصورة الشخصية الموحد
                    _buildAvatarSection(_currentFirestoreAvatar, isDark),
                    const Gap(36),
                    _ProfileField(
                      label: 'الاسم الكامل',
                      controller: _nameCtrl,
                      icon: Icons.person_outline,
                      isDark: isDark,
                    ),
                    const Gap(16),
                    _ProfileField(
                      label: 'البريد الإلكتروني',
                      controller: _emailCtrl,
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      enabled: false,
                    ),
                    const Gap(16),
                    _ProfileField(
                      label: 'رقم الهاتف',
                      controller: _phoneCtrl,
                      icon: Icons.phone_outlined,
                      isDark: isDark,
                    ),
                    const Gap(40),
                    _buildSaveButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarSection(String? avatarUrl, bool isDark) {
    final bool hasImage =
        avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        avatarUrl.startsWith('http');
    return GestureDetector(
      onTap: _updatePhoto,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
            backgroundImage: hasImage ? NetworkImage(avatarUrl) : null,
            child: !hasImage
                ? Icon(
                    Icons.person,
                    size: 50,
                    color: isDark ? Colors.white24 : Colors.grey,
                  )
                : null,
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange,
              child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<ProfileBloc>().add(
            UpdateProfile(
              name: _nameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        'حفظ التغييرات',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isDark;
  final bool enabled;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.isDark,
    this.enabled = true,
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
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.orange),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
