

class Contact {
  static  const  tblContact = "contacts";
  static  const colId = 'id';
  static  const colName = 'name';
  static  const colMobile = 'mobile';
  static  const colEmail = 'email';

  int id;
  String name;
  String mobile;
  String email;

  Contact({this.id,this.name,this.mobile,this.email});

  //convert to contact after retrieve fom sqlite
  Contact.fromMap(Map<String,dynamic> map){
    id = map[colId];
    name = map[colName];
    mobile = map[colMobile];
    email = map[colEmail];
  }

  // convert to map before insert to sqlite
  Map<String,dynamic> toMap(){
    var map = <String,dynamic> {colName:name,colMobile:mobile,colEmail:email};
    if (id != null) map[colId] = id;
    return map;
  }
}
