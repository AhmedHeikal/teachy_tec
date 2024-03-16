import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/PracticeMainPageVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/SliverGridLayoutWithCustomGeometryLayout.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class MultioptionsPracticePage extends StatelessWidget {
  const MultioptionsPracticePage({
    super.key,
    required this.model,
    required this.currentTask,
  });
  final TaskViewModel currentTask;
  final PracticeMainPageVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Column(
        children: [
          if (currentTask.downloadUrl != null) ...[
            Text(currentTask.task, style: TextStyles.InterBlackS18W700),
            const SizedBox(
              height: kMainPadding,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DefaultContainer(
                  height: 220,
                  width: double.infinity,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      currentTask.downloadUrl!,
                    ),
                    loadingBuilder: (context, event) {
                      final expectedBytes = event?.expectedTotalBytes;
                      final loadedBytes = event?.cumulativeBytesLoaded;
                      final value = loadedBytes != null && expectedBytes != null
                          ? loadedBytes / expectedBytes
                          : null;

                      return Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: value,
                            color: AppColors.primary700,
                          ),
                        ),
                      );
                    },
                    initialScale: PhotoViewComputedScale.contained,
                  ),
                ),
              ),
            ),
          ],
          if (currentTask.downloadUrl == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DefaultContainer(
                    height: 220,
                    padding: const EdgeInsets.all(kInternalPadding),
                    color: AppColors.black,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        currentTask.task,
                        style: TextStyles.InterWhiteS18W700,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          Consumer<PracticeMainPageVM>(
            builder: (context, model, _) => GridView.builder(
              itemCount: currentTask.options?.length ?? 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: kMainPadding, vertical: kBottomPadding),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                var currentOption = currentTask.options![index];
                return InkWell(
                  onTap: model.currentSelectedOption != null
                      ? null
                      : () => model.onSelectOption(currentOption),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        border: Border.all(
                          width: 2,
                          color: model.currentSelectedOption == null ||
                                  model.currentSelectedOption?.name !=
                                      currentOption.name
                              ? Colors.transparent
                              : model.currentSelectedOption!.isCorrect
                                  ? AppColors.green600
                                  : AppColors.red600,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 20,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/png/emptyOptionAlternative.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                            ),
                          ),
                          if (currentOption.downloadUrl != null)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: PhotoView(
                                  imageProvider: NetworkImage(
                                    currentOption.downloadUrl!,
                                  ),
                                  initialScale:
                                      PhotoViewComputedScale.contained,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container();
                                  },
                                  loadingBuilder: (context, event) {
                                    final expectedBytes =
                                        event?.expectedTotalBytes;

                                    final loadedBytes =
                                        event?.cumulativeBytesLoaded;

                                    final value = loadedBytes != null &&
                                            expectedBytes != null
                                        ? loadedBytes / expectedBytes
                                        : null;

                                    return Stack(
                                      children: [
                                        Positioned(
                                          top: kBottomPadding,
                                          right: kBottomPadding,
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              value: value,
                                              color: AppColors.primary700,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            top: currentOption.downloadUrl == null ? 0 : null,
                            right: 0,
                            child: DefaultContainer(
                              borderRadius: BorderRadius.only(
                                topLeft: currentOption.downloadUrl == null
                                    ? const Radius.circular(8)
                                    : Radius.zero,
                                topRight: currentOption.downloadUrl == null
                                    ? const Radius.circular(8)
                                    : Radius.zero,
                                bottomLeft: const Radius.circular(8),
                                bottomRight: const Radius.circular(8),
                              ),
                              color: AppColors.grey900.withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: kInternalPadding,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Text(
                                  currentOption.name,
                                  style: TextStyles.InterWhiteS14W400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                itemCount: currentTask.options?.length ?? 0,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
