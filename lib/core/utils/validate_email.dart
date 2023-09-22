String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  if (value == null || value.isEmpty) {
    return null;
  }
  RegExp regex = RegExp(pattern);
  bool hasMatch = regex.hasMatch(value) && value.contains('.');
  return hasMatch ? null : 'Enter a valid email address';
}

String removeDiacritics(String str) {
  var withDia =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var withoutDia =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }
  return str;
}

String? validateName(String? rawName) {
  rawName = rawName?.trim();
  if (rawName == null || rawName.isEmpty) {
    return 'Tell us Your Name';
  }
  final name = removeDiacritics(rawName).replaceAll(RegExp(r'\s+'), ' ');

  if (RegExp(r'^[a-zA-Z]{2,}( [a-zA-Z]{2,}){1,3}$').hasMatch(name)) {
    return null;
  }
  return 'Enter at least 2 names';
}
