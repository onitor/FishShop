import 'package:codes/rich_text/rt_image_span.dart';
import 'package:flutter/rendering.dart';

class RTRenderParagraph extends RenderParagraph {
  RTRenderParagraph(TextSpan text,
      {TextAlign textAlign = TextAlign.start,
        required TextDirection textDirection,
        bool softWrap = true,
        TextOverflow overflow = TextOverflow.clip,
        double textScaleFactor = 1.0,
        int? maxLines,
        Locale? locale})
      : super(
    text,
    textAlign: textAlign,
    textDirection: textDirection,
    softWrap: softWrap,
    overflow: overflow,
    textScaleFactor: textScaleFactor,
    maxLines: maxLines,
    locale: locale,
  );

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    text.visitChildren((InlineSpan span) {
      if (span is RTImageSpan) {
        span.imageResolver.addListening();
      }
      return true;
    });
  }

  @override
  void detach() {
    super.detach();
    text.visitChildren((InlineSpan span) {
      if (span is RTImageSpan) {
        span.imageResolver.stopListening();
      }
      return true;
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    paintImageSpan(context, offset);
  }

  void paintImageSpan(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Rect bounds = offset & size;
    canvas.save();

    int textOffset = 0;
    text.visitChildren((InlineSpan span) {
      if (span is RTImageSpan) {
        Offset offsetForCaret = getOffsetForCaret(TextPosition(offset: textOffset), bounds);
        if (textOffset == 0) {
          offsetForCaret = Offset(0, offsetForCaret.dy);
        }
        if (textOffset != 0 && offsetForCaret.dx == 0 && offsetForCaret.dy == 0) {
          return true;
        }
        Offset topLeftOffset = Offset(
          offset.dx + offsetForCaret.dx - (textOffset == 0 ? 0 : span.width / 2),
          offset.dy + offsetForCaret.dy,
        );
        if (span.imageResolver.image == null) {
          span.imageResolver.resolve((imageInfo, synchronousCall) {
            if (synchronousCall) {
              paintImage(
                canvas: canvas,
                rect: topLeftOffset & Size(span.width, span.height),
                image: span.imageResolver.image!,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              );
            } else {
              if (owner == null || owner?.debugDoingPaint==false) {
                markNeedsPaint();
              }
            }
          });
          textOffset += span.toPlainText().length;
          return true;
        }
        paintImage(
          canvas: canvas,
          rect: topLeftOffset & Size(span.width, span.height),
          image: span.imageResolver.image!,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        );
      }
      textOffset += span.toPlainText().length;
      return true;
    });

    canvas.restore();
  }
}
