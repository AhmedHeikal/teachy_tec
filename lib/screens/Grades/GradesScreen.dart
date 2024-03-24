import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/screens/Grades/GradesScreenVM.dart';
import 'package:teachy_tec/screens/Grades/SchemaPreview.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/AppPullToRefreshComponent.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/EmptyPlugins.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key, required this.model});
  final GradesScreenVM model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppPullToRefreshComponent(
        onRefresh: model.getSchemasList,
        child: ChangeNotifierProvider.value(
          value: model,
          child: Scaffold(
            appBar: CustomAppBar(
              screenName: 'Schemas',
              actions: [
                InkWell(
                  onTap: model.onAddNewSchema,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMainPadding),
                    child: SvgPicture.asset(
                      'assets/svg/addButton.svg',
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<GradesScreenVM>(
                      builder: (context, model, _) {
                        if (!model.isInitialized) return Container();
                        if (model.schemas.isEmpty) {
                          return EmptyPlugin(
                            plugin: AppPluginsItems().activitiesEmptyPlugin,
                          );
                        }

                        return ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kMainPadding,
                              vertical: kMainPadding * 2),
                          shrinkWrap: true,
                          itemCount: model.schemas.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: kBottomPadding),
                          itemBuilder: (context, index) {
                            var currentItem = model.schemas[index];
                            return SchemaPreview(
                              key: UniqueKey(),
                              model: currentItem,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
