import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import 'step_one_screen.dart';
import 'step_two_screen.dart';

/// Maquette 03_Recapitulatif
class SummaryScreen extends StatefulWidget {
  final UserProfile profil;

  const SummaryScreen({super.key, required this.profil});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  void _retourDebut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StepOneScreen()),
      (route) => false,
    );
  }

  Future<void> _reinitialiser() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text('Toutes les données saisies seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
    if (confirme == true && mounted) _retourDebut();
  }

  Future<void> _confirmer() async {
    if (!_formKey.currentState!.validate()) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Compte créé !'),
        content: Text(
          'Bienvenue ${widget.profil.prenom}.\n'
          'Un e-mail de confirmation a été envoyé à ${widget.profil.email}.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
    if (mounted) _retourDebut();
  }

  /// Bonus 4 : retour à l'étape 1 (première route de la pile).
  /// Les écrans intermédiaires sont retirés, l'écran 1 garde ses saisies.
  void _modifierEtape1() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Bonus 4 : retour à l'étape 2 grâce à son nom de route.
  void _modifierEtape2() {
    Navigator.popUntil(context, ModalRoute.withName(StepTwoScreen.routeName));
  }

  Widget _section(String titre, VoidCallback onModifier, List<Widget> lignes) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(titre,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  // Bonus 4 : bouton « Modifier » sur chaque carte
                  TextButton.icon(
                    onPressed: onModifier,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Modifier'),
                  ),
                ],
              ),
            ),
            ...lignes,
          ],
        ),
      ),
    );
  }

  Widget _ligne(IconData icone, String libelle, String valeur) {
    return ListTile(
      leading: Icon(icone),
      title: Text(libelle),
      subtitle: Text(valeur.isEmpty ? 'Non renseigné' : valeur),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profil;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Récapitulatif de votre profil'),
        actions: [
          IconButton(
            tooltip: 'Réinitialiser',
            icon: const Icon(Icons.restart_alt),
            onPressed: _reinitialiser,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('Identité', _modifierEtape1, [
                _ligne(Icons.person_outline, 'Nom complet', p.nomComplet),
                _ligne(Icons.email_outlined, 'E-mail', p.email),
                // Le mot de passe n'est jamais affiché en clair
                _ligne(Icons.lock_outline, 'Mot de passe',
                    '•' * p.password.length),
              ]),
              _section('Profil professionnel', _modifierEtape2, [
                _ligne(Icons.work_outline, 'Profession', p.profession),
                _ligne(Icons.timeline, 'Expérience', '${p.experience} an(s)'),
                _ligne(Icons.euro, 'TJM', '${p.tjm.toStringAsFixed(2)} €'),
                _ligne(Icons.notes, 'Biographie', p.biographie),
              ]),
              // Champ de formulaire personnalisé : case à cocher obligatoire
              FormField<bool>(
                initialValue: false,
                validator: (v) => v == true
                    ? null
                    : "Vous devez accepter les conditions d'utilisation",
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: field.value,
                      onChanged: field.didChange,
                      title:
                          const Text("J'accepte les conditions d'utilisation"),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _confirmer,
                icon: const Icon(Icons.check),
                label: const Text('Confirmer et créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}