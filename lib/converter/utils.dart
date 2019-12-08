import 'package:emarket_app/model/feetyp.dart';

class Converter {
  static FeeTyp convertStringToFeeTyp(String newValue) {
    switch (newValue) {
      case 'Kdo':
        {
          return FeeTyp.gift;
        }
        break;
      case 'Negociable':
        {
          return FeeTyp.negotiable;
        }
        break;
      case 'Fixe':
        {
          return FeeTyp.fixed;
        }
        break;
    }
  }
}
