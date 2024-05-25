class Defis {
  int? idDefis; // Nullable
   double montant=0.0;
   String nom ='';

   Defis(this.idDefis,this.montant,this.nom);

   //getters
   get getid => idDefis;
   get getmontant => montant;
   get getnom => nom;

   //setters
   set setid(int newid){
     this.idDefis=newid;
   }
   set setmontant(double newmontant){
     this.montant=newmontant;
   }
   set setnom(String newnom){
     this.nom=newnom;
   }


   Map<String ,dynamic> toMap(){
     var map =Map<String ,dynamic>();
     map['montant'] = montant;
     map['nom'] = nom;
     return map;
   }

   Defis.fromMapObject(Map<String, dynamic> map) {
     this.montant = map['montant'] ?? 0.0; // Use default value if 'montant' is null
     this.nom = map['nom'] ?? ''; // Use default value if 'nom' is null
   }
   }