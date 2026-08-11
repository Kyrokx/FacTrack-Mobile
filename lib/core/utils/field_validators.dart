class FieldValidation {

  /// checkEmailRegex
  bool checkEmailRegex(String email) {
    return RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(email);
    //return RegExp(r"/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/").hasMatch(email);
  }

  String? usernameValidator({required String? username}) {
    final name = username?.trim() ?? "";

    if (name.isEmpty) {
      return "Veuillez entrer votre nom d'utilisateur";
    }
    if (name.length < 2) { // Un prénom peut faire 2 lettres (ex: Al)
      return 'Nom d\'utilisateur trop court';
    }
    if (name.length > 30) {
      return 'Nom d\'utilisateur trop long';
    }
    return null;
  }

  String? passwordValidator({required password}){
    if (password.isEmpty || password == "") {
      return "Veuillez entrer votre mot de passe";
    }
    if (password.length < 6) {
      return "Le mot de passe doit contenir au moins 6 caractères";
    }
    return null;
  }

  String? emailValidator({required email}){
    if (email.isEmpty || email == "") {
      return "Veuillez entrer votre adresse email";
    }
    if (!checkEmailRegex(email)) {
      return "Adresse email invalide";
    }
    return null;
  }

}