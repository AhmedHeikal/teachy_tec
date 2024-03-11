import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_multi_formatter/widgets/country_flag.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class CustomizedDropdown extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final String? chosenItem;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(String, int) onChange;

  /// list of DropdownItems
  final List<String> items;
  // DropdownStyle? dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  // final DropdownButtonStyle? dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool hideIcon;
  final String? emptyChoiceText;
  final String? emptyChoiceChosenText;
  final double bottomTapHeight;
  final String Function(String input)? shownItemFormat;
  // final GlobalKey? globalKey;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;
  final bool isEnabled;
  CustomizedDropdown({
    Key? key,
    // String
    this.isEnabled = true,
    this.hideIcon = false,
    this.bottomTapHeight = 0,
    this.shownItemFormat,
    // this.globalKey,
    this.chosenItem,
    this.emptyChoiceText,
    this.emptyChoiceChosenText,
    required this.items,
    required this.onChange,
    // required this.dropdownStyle,
    // required this.dropdownButtonStyle,
    this.icon,
    this.leadingIcon = false,
  }) : super(key: key);

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState<T> extends State<CustomizedDropdown>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.emptyChoiceText != null) {
      widget.items.insert(0, widget.emptyChoiceText!);
    }

    _currentIndex =
        widget.chosenItem != null && widget.chosenItem!.trim().isNotEmpty
            ? widget.items.indexWhere((element) => element == widget.chosenItem)
            : 0;

    _currentIndex = _currentIndex == -1 ? 0 : _currentIndex;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.emptyChoiceText == null ||
        widget.items[_currentIndex] != widget.emptyChoiceText) {
      widget.onChange(widget.items[_currentIndex], _currentIndex);
    }
  }

  @override
  void didUpdateWidget(covariant CustomizedDropdown oldWidget) {
    _currentIndex =
        widget.chosenItem != null && widget.chosenItem!.trim().isNotEmpty
            ? widget.items.indexWhere((element) => element == widget.chosenItem)
            : 0;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // var style = widget.dropdownButtonStyle;
    // link the overlay to the button
    return Column(
      // key: widget.globalKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: this._layerLink,
          child: DefaultContainer(
            // width: double.infinity,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: kHelpingPadding),
            decoration: BoxDecoration(
              color: widget.isEnabled ? AppColors.white : AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: !widget.isEnabled
                  ? Border.all(color: AppColors.grey300)
                  : isValid
                      ? Border.all(color: AppColors.grey200)
                      : Border.all(color: AppColors.red500),
            ),
            child: InkWell(
              onTap: widget.isEnabled ? _toggleDropdown : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // TODO Fix the expanded error
                  // Expanded(
                  // child:
                  Text(
                    widget.items.isNotEmpty ? widget.items[_currentIndex] : "",
                    style: !widget.isEnabled
                        ? TextStyles.InterGrey400S14W400
                        : isValid
                            ? TextStyles.InterGrey700S14W400
                            : TextStyles.InterRed700S14W400,
                    // ),
                  ),
                  const SizedBox(width: kInternalPadding),
                  if (widget.isEnabled && !widget.hideIcon)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: RotationTransition(
                        turns: _rotateAnimation,
                        child: Transform.rotate(
                          angle: 0.5 * pi,
                          child: SvgPicture.asset(
                            'assets/svg/rightArrow.svg',
                            height: 10,
                            color:
                                isValid ? AppColors.grey400 : AppColors.red700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isValid && widget.emptyChoiceChosenText != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/warning.svg',
                // color: TomatoColors.Red500,
                color: AppColors.grey400,
                height: 16,
              ),
              const SizedBox(width: 2),
              Text(
                widget.emptyChoiceChosenText!,
                // style: TextStyles.InterGrey400S12W400,
                // style: TextStyles.InterRed500S12W400H16,
              ),
            ],
          )
        ],
      ],
    );
  }

  bool isValid = true;

  bool validateInput() {
    if (widget.items[_currentIndex] == widget.emptyChoiceText) {
      if (mounted && isValid) {
        setState(() {
          isValid = false;
        });
      }
      return false;
    }
    if (mounted && !isValid) {
      setState(() {
        isValid = true;
      });
    }
    return true;
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var screenSize = MediaQuery.sizeOf(context);
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    // var height = screenSize.height - offset.dy;
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: size.width,
                child: CompositedTransformFollower(
                  offset: Offset(
                      0,
                      screenSize.height - topOffset >
                              50 + widget.bottomTapHeight
                          ? size.height + 1
                          : -(widget.items.length > 5
                                  ? 200
                                  : widget.items.length * 40) -
                              5),
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  child: DefaultContainer(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey400.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.grey200,
                        )),
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenSize.height - topOffset >
                                  50 + widget.bottomTapHeight
                              ? screenSize.height - topOffset - 15
                              : widget.items.length > 5
                                  ? 200
                                  : widget.items.length * 40,
                        ),
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemCount: widget.items.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = widget.items[index];
                            return InkWell(
                              onTap: () {
                                if (mounted) {
                                  setState(() => _currentIndex = index);
                                }
                                if (widget.emptyChoiceText == null ||
                                    widget.items[_currentIndex] !=
                                        widget.emptyChoiceText) {
                                  widget.onChange(item, index);
                                }
                                _toggleDropdown();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kMainPadding,
                                    vertical: kBottomPadding),
                                child: Text(
                                  widget.shownItemFormat != null
                                      ? widget.shownItemFormat!(item)
                                      : item,
                                  // item,
                                  // style: TextStyles.InterGrey700S16W600
                                  //     .copyWith(
                                  //         color: index == _currentIndex
                                  //             ? TomatoColors.Blue700
                                  //             : null),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: kMainPadding),
                            color: AppColors.grey100,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      this._overlayEntry!.remove();
      if (mounted) {
        setState(() {
          _isOpen = false;
        });
      }
    } else {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry!);
      if (mounted) setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

class CountryPhoneCodesDropDown extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final PhoneCountryData? chosenCountryCode;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(PhoneCountryData countryData) onChange;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  const CountryPhoneCodesDropDown({
    super.key,
    this.hideIcon = false,
    // this.isCountry = false,
    this.chosenCountryCode,
    required this.onChange,
    this.icon,
    this.leadingIcon = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CountryPhoneCodesDropDownState createState() =>
      _CountryPhoneCodesDropDownState();
}

class _CountryPhoneCodesDropDownState<T>
    extends State<CountryPhoneCodesDropDown> with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  List<PhoneCountryData> countriesList = PhoneCodes.getAllCountryDatas();

  @override
  void didUpdateWidget(covariant CountryPhoneCodesDropDown oldWidget) {
    if (oldWidget.chosenCountryCode != widget.chosenCountryCode) {
      _currentIndex = widget.chosenCountryCode != null
          ? countriesList.indexWhere((element) =>
              element.countryCode == widget.chosenCountryCode!.countryCode)
          : 0;
      _currentIndex = _currentIndex == -1 ? 0 : _currentIndex;
      _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200));
      _expandAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      );
      _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.chosenCountryCode != null
        ? countriesList.indexWhere((element) =>
            element.countryCode == widget.chosenCountryCode!.countryCode)
        : 0;
    _currentIndex = _currentIndex == -1 ? 0 : _currentIndex;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    widget.onChange(countriesList[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(
            /* vertical: 10, */ horizontal: kHelpingPadding),
        child: InkWell(
          onTap: _toggleDropdown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection:
                widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
            mainAxisSize: MainAxisSize.max,
            children: [
              ...[
                CountryFlag(
                  width: 19,
                  height: 13,
                  countryId: countriesList[_currentIndex].countryCode!,
                ),
              ],
              const SizedBox(width: kHelpingPadding),
              if (!widget.hideIcon)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: RotationTransition(
                      turns: _rotateAnimation,
                      child: Transform.rotate(
                        angle: 0.5 * pi,
                        child: SvgPicture.asset('assets/svg/ArrowRight.svg',
                            height: 16, color: AppColors.grey400),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    var screenSize = MediaQuery.sizeOf(context);

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: 90,
                child: CompositedTransformFollower(
                  offset: Offset(
                      0,
                      screenSize.height - topOffset > 50 + 80
                          ? size.height + 1
                          : -(countriesList.length > 5
                                  ? 200
                                  : countriesList.length * 40) -
                              5),
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  child: DefaultContainer(
                    color: AppColors.white,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey400.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.grey200,
                        )),
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenSize.height - topOffset > 50 + 80
                              ? screenSize.height - topOffset - 15
                              : countriesList.length > 5
                                  ? 200
                                  : countriesList.length * 40,
                        ),
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemCount: countriesList.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = countriesList[index];
                            return InkWell(
                                onTap: () {
                                  if (mounted) {
                                    setState(() => _currentIndex = index);
                                  }
                                  widget.onChange(item);
                                  _toggleDropdown();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      Align(
                                        child: CountryFlag(
                                          width: 19,
                                          height: 13,
                                          countryId:
                                              countriesList[index].countryCode!,
                                        ),
                                      ),
                                      const SizedBox(width: kHelpingPadding),
                                      Expanded(
                                        child: Text(
                                          '+${countriesList[index].phoneCode!}',
                                          style: TextStyles.InterGrey700S14W400,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                  ),
                                )

                                //  Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: kMainPadding,
                                //       vertical: kBottomPadding),
                                //   child:

                                //   Text(
                                //     item,
                                //     style: TomatoTextStyles.InterGrey700S16W600H20
                                //         .copyWith(
                                //             color: index == _currentIndex
                                //                 ? TomatoColors.Green700
                                //                 : null),
                                //   ),
                                // ),
                                );
                          },
                          separatorBuilder: (context, index) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: kMainPadding),
                            color: AppColors.grey100,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      this._overlayEntry!.remove();
      if (mounted) {
        setState(() {
          _isOpen = false;
        });
      }
    } else {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry!);
      if (mounted) setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
// class DropdownItem<T> extends StatelessWidget {
//   final T value;
//   final Widget child;

//   const DropdownItem({Key? key, required this.value, required this.child})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return child;
//   }
// }
