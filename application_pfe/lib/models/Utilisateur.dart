import 'Defis.dart';
import 'Historique.dart';
import 'Rapport.dart';

class Utilisateur {
  String email = '';
  String nom = '';
  String motDePasse = '';
  double salaire = 0.0;
  String profession = '';
  int age = 0;

  List<Defis> defis = [];
  List<Rapport> rapports = [];
  List<Historique> historiques = [];

  Utilisateur({
    required this.nom,
    required this.email,
    required this.motDePasse,
    this.salaire = 0,
    this.profession = '',
    this.age = 0,
  });

  String get getEmail => email;
  String get getNom => nom;
  String get getPassword => motDePasse;
  double get getSalaire => salaire;
  String get getProfession => profession;
  int get getAge => age;

  set setEmail(String newEmail) {
    this.email = newEmail;
  }

  set setNom(String newNom) {
    this.nom = newNom;
  }

  set setPassword(String newPassword) {
    this.motDePasse = newPassword;
  }

  set setSalaire(double newSalaire) {
    this.salaire = newSalaire;
  }

  set setProfession(String newProfession) {
    this.profession = newProfession;
  }

  set setAge(int newAge) {
    this.age = newAge;
  }


  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['nom'] = nom;
    map['email'] = email;
    map['motDePasse'] = motDePasse;
    map['profession'] = profession;
    map['salaire'] = salaire;
    map['age'] = age;
    return map;
  }

  Utilisateur.fromMapObject(Map<String, dynamic> map) {
    this.nom = map['nom'] ?? ''; // Assign empty string if 'nom' is null
    this.email = map['email'] ?? ''; // Assign empty string if 'email' is null
    this.motDePasse = map['motDePasse'] ?? ''; // Assign empty string if 'motDePasse' is null
    this.profession = map['profession'] ?? ''; // Assign empty string if 'profession' is null
    this.salaire = (map['salaire'] ?? 0.0).toDouble(); // Assign 0.0 if 'salaire' is null
    this.age = (map['age'] ?? 0).toInt(); // Assign 0 if 'age' is null
  }


}
