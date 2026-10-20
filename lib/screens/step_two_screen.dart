import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_profile.dart';
import '../utils/validators.dart';
import 'summary_screen.dart';

/// Maquette 02_Etape2_ProfilPro
class StepTwoScreen extends StatefulWidget {
  /// Nom de la route, utilisé par Navigator.popUntil (bonus 4)
  static const String routeName = '/etape2';

  final UserProfile profil;

  const StepTwoScreen({super.key, required this.profil});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  /// Bonus 3 : liste des professions proposées
  static const List<String> _professions = [
    'Développeur mobile',
    'Développeur web',
    'Designer UX/UI',
    'Chef de projet',
    'Data scientist',
    'Autre',
  ];

  final _formKey = GlobalKey<FormState>();
  final _experienceCtrl = TextEditingController();
  final _tjmCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  String? _profession; // valeur choisie dans la liste déroulante

  @override
  void initState() {
    super.initState();
    // Bonus 5 : on reconstruit l'écran à chaque saisie pour que
    // PopScope sache si des champs sont remplis.
    for (final ctrl in [_experienceCtrl, _tjmCtrl, _bioCtrl]) {
      ctrl.addListener(_rafraichir);
    }
  }

  void _rafraichir() => setState(() {});

  @override
  void dispose() {
    _experienceCtrl.dispose();
    _tjmCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  /// Bonus 5 : vrai si l'utilisateur a commencé à remplir l'écran
  bool get _aDesDonnees =>
      _profession != null ||
      _experienceCtrl.text.isNotEmpty ||
      _tjmCtrl.text.isNotEmpty ||
      _bioCtrl.text.isNotEmpty;

  /// Bonus 5 : boîte de confirmation avant de quitter
  Future<void> _confirmerSortie() async {
    final quitter = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter cette étape ?'),
        content: const Text(
            'Les informations saisies sur cet écran seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Rester'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    // Navigator.pop ignore PopScope : on quitte vraiment l'écran
    if (quitter == true && mounted) Navigator.of(context).pop();
  }

  void _suivant() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final profilComplet = widget.profil.copyWith(
      profession: _profession,
      experience: int.parse(_experienceCtrl.text.trim()),
      tjm: double.parse(_tjmCtrl.text.trim().replaceAll(',', '.')),
      biographie: _bioCtrl.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SummaryScreen(profil: profilComplet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Bonus 5 : si des champs sont remplis, le retour est bloqué
    // et on demande une confirmation.
    return PopScope(
      canPop: !_aDesDonnees,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // déjà quitté (aucune donnée saisie)
        _confirmerSortie();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: "Retour à l'étape 1",
            // maybePop respecte PopScope (contrairement à pop)
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text('Profil Professionnel - Étape 2/3'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4),
            child: LinearProgressIndicator(value: 2 / 3),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Bonjour ${widget.profil.prenom}, parlez-nous de votre activité.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                // Bonus 3 : profession choisie dans une liste
                DropdownButtonFormField<String>(
                  value: _profession,
                  decoration: const InputDecoration(
                    labelText: 'Profession',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  items: _professions
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _profession = v),
                  validator: (v) =>
                      v == null ? 'Choisissez une profession' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _experienceCtrl,
                  decoration: const InputDecoration(
                    labelText: "Années d'expérience",
                    prefixIcon: Icon(Icons.timeline),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  textInputAction: TextInputAction.next,
                  validator: Validators.experience,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tjmCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tarif Journalier Moyen (TJM)',
                    prefixIcon: Icon(Icons.euro),
                    suffixText: '€',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    // chiffres, un seul séparateur (. ou ,), 2 décimales max
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*[.,]?\d{0,2}')),
                  ],
                  textInputAction: TextInputAction.next,
                  validator: Validators.tjm,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Biographie (facultative)',
                    hintText: 'Présentez votre parcours en quelques lignes',
                    alignLabelWithHint: true,
                  ),
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 300,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  validator: Validators.biographie,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _suivant,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}