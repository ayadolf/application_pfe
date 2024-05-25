class UtilisateurDepense {
  String email ='';
  int idDepense=0;

  UtilisateurDepense(this.email, this.idDepense);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['idDepense'] = idDepense;
    return map;
  }

  UtilisateurDepense.fromMapObject(Map<String, dynamic> map) {
    email = map['email'];
    idDepense = map['idDepense'];
  }
}
