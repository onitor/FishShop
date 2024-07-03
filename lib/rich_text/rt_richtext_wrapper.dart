import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'rt_render_paragraph.dart';

// 使用自定义的文本绘制
class RTRichTextWrapper extends RichText {
  RTRichTextWrapper({
    Key? key,
    required TextSpan text,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    double textScaleFactor = 1.0,
    int? maxLines,
    Locale? locale,
  })  : assert(text != null),
        assert(textAlign != null),
        assert(softWrap != null),
        assert(overflow != null),
        assert(textScaleFactor != null),
        assert(maxLines == null || maxLines > 0),
        super(
        key: key,
        text: text,
        textAlign: textAlign,
        textDirection: textDirection,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        locale: locale,
      );

  @override
  RTRenderParagraph createRenderObject(BuildContext context) {
    assert(textDirection != null || debugCheckHasDirectionality(context));
    return RTRenderParagraph(
      text as TextSpan,
      textAlign: textAlign,
      textDirection: textDirection ?? Directionality.of(context),
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale ?? Localizations.localeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RTRenderParagraph renderObject) {
    assert(textDirection != null || debugCheckHasDirectionality(context));
    renderObject
      ..text = text
      ..textAlign = textAlign
      ..textDirection = textDirection ?? Directionality.of(context)
      ..softWrap = softWrap
      ..overflow = overflow
      ..textScaleFactor = textScaleFactor
      ..maxLines = maxLines
      ..locale = locale ?? Localizations.localeOf(context);
  }
}
