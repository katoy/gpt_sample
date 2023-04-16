import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;
    // const maxLines = 3;

    Widget buildText(BuildContext context) {
      final textSpan = TextSpan(
        text: text.trim(),
        style: TextStyle(
          color: isUserMessage ? Colors.white : Colors.black,
          fontSize: 16.0,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        // maxLines: maxLines,
        // ellipsis: '...', // 最大行数を超えた場合に末尾に表示するテキスト
      );
      textPainter.layout(maxWidth: maxWidth); // 最大幅を指定してテキストをレイアウト

      // 最大行数を超える場合は、テキストを適宜改行する
      if (textPainter.didExceedMaxLines) {
        final lines = text.trim().split('\n'); // 改行で区切る
        final textWidgets = <Widget>[];

        for (final line in lines) {
          final trimmedLine = line.trim(); // 行の先頭と末尾の空白文字を削除
          if (trimmedLine.length == 0) {
            continue;
          }

          final textWidget = Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Text(
              trimmedLine,
              style: TextStyle(
                color: isUserMessage ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
          );

          textWidgets.add(textWidget);
        }

        return Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: textWidgets,
        );
      } else {
        return Text(
          text.trim(),
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CircleAvatar(
            backgroundColor: isUserMessage ? Colors.blue : Colors.grey[300],
            child: Icon(
              isUserMessage ? Icons.person : Icons.computer,
              color: Colors.white,
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: buildText(context),
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}
