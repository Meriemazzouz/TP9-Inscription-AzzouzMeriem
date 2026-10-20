import 'package:flutter_test/flutter_test.dart';
import 'package:tp_inscription/utils/validators.dart';

void main() {
  group('Validators.nom', () {
    test('refuse un seul caractère', () {
      expect(
        Validators.nom('A', champ: 'Le nom'),
        'Le nom doit contenir au moins 2 caractères',
      );
    });
    test('refuse les chiffres', () {
      expect(
        Validators.nom('Ben 3li', champ: 'Le nom'),
        'Le nom ne doit contenir que des lettres',
      );
    });
    test('accepte accents et tiret', () {
      expect(Validators.nom('Azzouz-Ben Hélène'), isNull);
    });
  });

  group('Validators.email', () {
    test('refuse une valeur vide', () {
      expect(Validators.email(''), isNotNull);
    });
    test('refuse une adresse sans extension', () {
      expect(Validators.email('ali@gmail'), isNotNull);
    });
    test('accepte une adresse valide', () {
      expect(Validators.email('ali.ben@gmail.com'), isNull);
    });
  });

  group('Validators.motDePasse', () {
    test('trop court', () {
      expect(Validators.motDePasse('Ab1'), 'Au moins 8 caractères');
    });
    test('sans majuscule', () {
      expect(
        Validators.motDePasse('bonjour12'),
        'Au moins une lettre majuscule',
      );
    });
    test('sans chiffre', () {
      expect(Validators.motDePasse('Bonjourrr'), 'Au moins un chiffre');
    });
    // Bonus 2 : caractère spécial obligatoire
    test('sans caractère spécial', () {
      expect(
        Validators.motDePasse('Bonjour12'),
        'Au moins un caractère spécial',
      );
    });
    test('valide', () {
      expect(Validators.motDePasse('Bonjour12!'), isNull);
    });
  });

  // Bonus 1 : calcul de la force du mot de passe
  group('Validators.forceMotDePasse', () {
    test('vide = 0', () {
      expect(Validators.forceMotDePasse(''), 0);
    });
    test('faible', () {
      expect(Validators.forceMotDePasse('abc'), 0);
      expect(Validators.forceMotDePasse('abcdefgh'), 1);
    });
    test('moyen', () {
      expect(Validators.forceMotDePasse('Bonjour12'), 3);
    });
    test('fort', () {
      expect(Validators.forceMotDePasse('Bonjour12!'), 4);
    });
  });

  group('Validators.confirmation', () {
    test('différente', () {
      expect(Validators.confirmation('Abc12345', 'Abc12346'), isNotNull);
    });
    test('identique', () {
      expect(Validators.confirmation('Abc12345', 'Abc12345'), isNull);
    });
  });

  group('Validators numériques', () {
    test('expérience hors bornes', () {
      expect(Validators.experience('51'), isNotNull);
    });
    test('expérience valide', () {
      expect(Validators.experience('5'), isNull);
    });
    test('TJM avec virgule', () {
      expect(Validators.tjm('350,50'), isNull);
    });
    test('TJM trop bas', () {
      expect(Validators.tjm('20'), isNotNull);
    });
  });

  group('Validators.biographie (facultative)', () {
    test('vide = valide', () {
      expect(Validators.biographie(''), isNull);
    });
    test('trop courte', () {
      expect(
        Validators.biographie('Je code.'),
        'Au moins 20 caractères (8/20) ou laissez vide',
      );
    });
  });
}
