class Historique {
  double nvsalaire =0.0;
  double ansalaire =0.0;
  String datech ='';

  Historique(this.nvsalaire,this.ansalaire,this.datech);

  //getters
 double get getnvsalaire => nvsalaire;
 double get getansalaire => ansalaire;
 String get getdatech => datech;

 //setters
  set setnvsalaire(double nvsalaire){
   this.nvsalaire=nvsalaire;
 }
  set setansalaire(double ansalaire){
    this.ansalaire=ansalaire;
  }
  set setdatech(String datech){
    this.datech=datech;
  }
  Map<String ,dynamic> toMap(){
    var map =Map<String ,dynamic>();
    map['nvsalaire'] = nvsalaire;
    map['ansalaire'] = ansalaire;
    map['datech'] = datech;
    return map;
  }

  Historique.fromMapObject(Map<String,dynamic> map){
    this.nvsalaire=map['nvsalaire'];
    this.ansalaire=map['ansalaire'];
    this.datech=map['datech'];
  }
}