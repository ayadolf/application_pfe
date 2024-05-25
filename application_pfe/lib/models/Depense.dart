class Depense {
    int? idD ;
   late String name  ;
   late double amount ;
   late String date  ;
   late String note ;
   late String  categorie ;
    Depense({this.idD, required  this.name, required this.amount,required  this.date,required  this.note,required  this.categorie});

   // Getters
   int? get getId => idD;
   double get getPrix => amount;
   String get  getDate => date;
   String get  getNote => note;
   String get  getCategorie => categorie;


   // Setters
   set setId(int newId) {
      this.idD = newId;
   }



   set setPrix(double newPrix) {
      this.amount = newPrix;
   }

   set setDate(String newDate) {
      this.date = newDate;
   }

   set setNote(String newNote) {
      this.note = newNote;
   }

   set setCategorie(String newCategorie) {
      this.categorie =newCategorie ;
   }

   Map<String, dynamic> tomap() {
      var map = <String, dynamic>{
         'name' : name,
         'prix': amount,
         'date': date,
         'categorie': categorie,
         'note': note,


      };
      return map;
   }

   Depense.fromMapObject(Map<String, dynamic> map){
      this.name = map['name'] ?? '';
      this.amount = map['prix'] ?? 0.0;
      this.date = map['date'] ?? '';
      this.note = map['note'] ?? '';
      this.categorie = map['categorie'] ?? '';

   }

    Depense copyWith({
       int? idD,
       required String name,
       required double amount,
       required String note,
       required String date,
       String? categorie,
    }) {
       return Depense(
          idD: idD ?? this.idD, // Use the provided idD or keep the original value if null
          name: name,
          amount: amount,
          date: date,
          note: note,
          categorie: categorie ?? this.categorie, // Use the provided categorie or keep the original value if null
       );
    }

}
