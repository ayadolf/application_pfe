import 'dart:ffi';

import 'Depense.dart';

class Rapport {
  int idR =0;
  String periode ='';
  List<Depense> depenses = []; // Liste des dépenses associées au rapport

  Rapport(this.idR,this.periode);


  //getters
  String get getperiode => periode;
  int get getidR => idR;


  //setters
  set setperiode (String periode){
    this.periode = periode;
  }
  set setidR (int idR){
    this.idR = idR;
  }

  Map<String ,dynamic> tomap(){
    var map =Map<String ,dynamic>();
    map['periode'] = periode;
    map['idR'] = idR;

    return map;
  }

  Rapport.fromMapObject(Map<String,dynamic> map){
    this.periode=map['periode'];
    this.idR=map['idR'];

  }
}