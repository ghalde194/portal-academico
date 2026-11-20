import 'package:flutter/material.dart';

import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';

/// Formulário de edição do perfil (nome, e-mail e telefone).
///
/// As alterações ficam em memória via [AppController.updateProfile]. Com uma
/// API real, o repositório enviaria os dados ao servidor.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AppScope.read(context).user;
    _name = TextEditingController(text: user.fullName);
    _email = TextEditingController(text: user.email);
    _phone = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await AppScope.read(
      context,
    ).updateProfile(fullName: _name.text, email: _email.text, phone: _phone.text);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil atualizado com sucesso!')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = AppScope.of(context).user;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Editar Perfil'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Center(
              child: Stack(
                children: [
                  ProfileAvatar(initials: user.initials),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Alterar foto',
                        icon: const Icon(
                          Icons.photo_camera_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => showComingSoon(context, 'Alterar foto'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) => (v == null || v.trim().split(RegExp(r'\s+')).length < 2)
                  ? 'Informe nome e sobrenome'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (v) =>
                  (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()))
                  ? 'E-mail inválido'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (v) => (v == null || v.replaceAll(RegExp(r'\D'), '').length < 10)
                  ? 'Telefone inválido'
                  : null,
            ),
            const SizedBox(height: 16),
            // Campos institucionais (somente leitura)
            TextFormField(
              initialValue: user.ra,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'RA (não editável)',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.course,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Curso (não editável)',
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Text('Salvar alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
