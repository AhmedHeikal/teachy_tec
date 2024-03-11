import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/PreviewData.dart';
import 'package:teachy_tec/widgets/linkDetectionParser.dart';
import 'package:url_launcher/url_launcher.dart';

class InteractiveText extends StatefulWidget {
  const InteractiveText({
    Key? key,
    required this.text,
    required this.style,
    this.linkStyle = TextStyles.InterYellowS16W600,
    this.showPreview = true,
  }) : super(key: key);
  final String text;
  final linkStyle;
  final TextStyle style;
  final bool showPreview;
  @override
  State<InteractiveText> createState() => _InteractiveTextState();
}

class _InteractiveTextState extends State<InteractiveText> {
  // Map<String, PreviewData> datas = {};
  bool isFetchingPreviewData = false;
  PreviewData previewData = const PreviewData();

  Future<void> _onOpen(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(InteractiveText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!isFetchingPreviewData && widget.showPreview) {
      _fetchData(widget.text);
    }
  }

  void _handlePreviewDataFetched(PreviewData previewData) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (mounted) {
      setState(() {
        isFetchingPreviewData = false;
        this.previewData = previewData;
      });
    }
  }

  Future<void> _fetchData(String text) async {
    setState(() {
      isFetchingPreviewData = true;
    });

    final previewData = await getPreviewData(
      text,
    );
    // // debugPrint('Heikal - fetchingData ${previewData.title}');
    _handlePreviewDataFetched(previewData);
    return;
  }

  @override
  Widget build(BuildContext context) {
    // // debugPrint('Heikal - Interactive text in Chat bubble build');

    // Widget _linkify() =>

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Linkify(
            linkifiers: const [EmailLinkifier(), UrlLinkifier()],
            linkStyle: widget.linkStyle,
            maxLines: 100,
            onOpen: (link) => _onOpen(link.url),
            options: const LinkifyOptions(
              defaultToHttps: true,
              humanize: true,
              looseUrl: true,
            ),
            // textAlign: TextAlign.left,
            text: widget.text,
            style: widget.style,
          ),
        ),
        if (previewData.title != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kBottomPadding),
            child: Text(
              previewData.title!,
              textAlign: TextAlign.left,
              style: widget.style.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        if (previewData.description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: kInternalPadding),
            child: Text(
              previewData.description!,
              textAlign: TextAlign.left,
              style: widget.style.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        if (previewData.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(previewData.image!.url),
          ),
      ],
    );
  }
}
