class UserSeller {
  static String _firstName = 'temp',
      _lastName = 'temp',
      _phone,
      _sex,
      _email,
      _pass,
      _company,
      _tax;

  static var typeList = [];

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  get lastName => _lastName;

  get getPass => _pass;

  set pass(value) {
    _pass = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get sex => _sex;

  set sex(value) {
    _sex = value;
  }

  get phone => _phone;

  set phone(value) {
    _phone = value;
  }

  set lastName(value) {
    _lastName = value;
  }

  get tax => _tax;

  set tax(value) {
    _tax = value;
  }

  get company => _company;

  set company(value) {
    _company = value;
  }

  UserSeller();
}
