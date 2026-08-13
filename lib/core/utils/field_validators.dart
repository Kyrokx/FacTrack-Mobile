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
  String? priceValidator({required String? value}) {
    final val = value?.trim() ?? "";
    if (val.isEmpty) return "Veuillez entrer le prix total";
    final parsed = double.tryParse(val);
    if (parsed == null) return "Prix invalide";
    if (parsed < 0) return "Le prix doit être supérieur à 0";
    return null;
  }

  String? consumptionValidator({required String? value}) {
    final val = value?.trim() ?? "";
    if (val.isEmpty) return "Veuillez entrer la consommation";
    final parsed = int.tryParse(val);
    if (parsed == null) return "Consommation invalide";
    if (parsed < 0) return "La consommation ne peut pas être négative";
    return null;
  }

  String? previousIndexValidator({required String? value}) {
    final val = value?.trim() ?? "";
    if (val.isEmpty) return "Veuillez entrer l'ancien index";
    final parsed = int.tryParse(val);
    if (parsed == null) return "Index invalide";
    if (parsed < 0) return "L'index ne peut pas être négatif";
    return null;
  }

  String? newIndexValidator({required String? value, /*required String? previousValue*/}) {
    final val = value?.trim() ?? "";
    if (val.isEmpty) return "Veuillez entrer le nouveau index";
    final parsed = int.tryParse(val);
    if (parsed == null) return "Index invalide";
    if (parsed < 0) return "L'index ne peut pas être négatif";
    /*final prev = int.tryParse(previousValue?.trim() ?? "");
    if (prev != null && parsed < prev) return "Le nouveau index doit être supérieur à l'ancien";*/
    return null;
  }

  String? billTypeValidator({required String? value}) {
    if (value == null || value.isEmpty) return "Veuillez sélectionner un type";
    //if (!['SONABEL', 'ONEA'].contains(value)) return "Type invalide";
    return null;
  }
}