import 'package:flutter/foundation.dart';
import 'package:teachy_tec/screens/Grades/SectorFormVM.dart';

class SectionComponentVM extends ChangeNotifier {
  String? name;
  double? totalGrade;
  String? colorhex;
  List<SectorFormVM>? sectorFormsVM;
  SectionComponentVM();

  List<SectorFormVM> sectors = [];

  void onAddNewSector() {
    sectors.add(
      SectorFormVM(),
    );
    notifyListeners();
  }

  Future<void> onDeleteSector(int index) async {
    // var sector = sectors.elementAt(index);
    // question.toggleIsLoading();
    // bool? isDeleted = true;
    // if (question.questionVM != null &&
    //     question.questionVM!.id != null &&
    //     question.questionVM!.id != 0) {}
    // isDeleted = await serviceLocator<TomatoNetworkProvider>()
    //     .DeleteCustomQuestion(id: question.questionVM!.id!);
    // if (isDeleted == true) {
    sectors.removeAt(index);
    notifyListeners();
    // }
    // question.toggleIsLoading();
  }
}
