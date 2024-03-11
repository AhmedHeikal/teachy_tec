import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/utils/AppAuthenticationService.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/Popups/DeleteItemPopup.dart';

class SettingsScreenVM extends ChangeNotifier {
  Future<void> onDeleteUser() async {
    await UIRouter.showAppBottomDrawerWithCustomWidget(
      bottomPadding: 0,
      child: DeleteItemPopup(
        onDeleteCallback: () async {
          UIRouter.showEasyLoader();
          UIRouter.popScreen(rootNavigator: true);
          deleteUserAccount();
          EasyLoading.dismiss(animation: true);
        },
        deleteMessage: AppLocale
            .byProceedingYouAreRequestingPermanentDeletionOfYourAccount
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
        dangerAdviceText: AppLocale
            .yourAppDatWillAlsoBeDeletedAndYouWontBeAbleToRetrieve
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
      ),
    );
  }
}
