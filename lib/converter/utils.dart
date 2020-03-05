import 'package:emarket_app/model/enumeration/feetyp.dart';

class Converter {
  static FeeTyp convertStringToFeeTyp(String newValue) {
    switch (newValue) {
      //English translation
      case 'Gift':
        {
          return FeeTyp.gift;
        }
        break;
      case 'Negotiable':
        {
          return FeeTyp.negotiable;
        }
        break;
      case 'Fixed':
        {
          return FeeTyp.fixed;
        }
        break;

      //French translation
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
    return FeeTyp.negotiable;
  }
}
