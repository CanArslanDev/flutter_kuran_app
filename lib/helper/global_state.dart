import 'package:get/get.dart';

class GlobalState extends GetxController {
  var isLoading = false.obs;
  var isLoadingGoogle = false.obs;
  var isSubmitted = false.obs;
  var isObscure = true.obs;
  var isOpen = false.obs;

  var emailError = "".obs;
  var passwordError = "".obs;
  var emailText = "".obs;
  var passwordText = "".obs;

  String? validateEmail() {
    final text = emailText.value;
    if (text.isEmpty) {
      emailError("Email boş olamaz");
      return emailError.value;
    }

    if (!GetUtils.isEmail(text)) {
      emailError("Email geçerli değil");
      return emailError.value;
    }

    return null;
  }

  String? validatePassword() {
    final text = passwordText.value;
    if (text.isEmpty) {
      passwordError("Şifre boş olamaz");
      return passwordError.value;
    }

    if (text.length < 6) {
      passwordError("Şifre çok kısa, en az 5 karakter");
      return passwordError.value;
    }

    passwordError("");
    return null;
  }
}
