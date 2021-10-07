class Rules {
  static required(value) => value.isNotEmpty ? true : 'Requerido';
  static email(value) =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)
          ? true
          : 'Email inválido';
}
