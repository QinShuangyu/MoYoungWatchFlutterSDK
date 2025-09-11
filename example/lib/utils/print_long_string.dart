/// 分行打印超长字符串
void printLongString(String tag, String message) {
  if (message.isEmpty) {
    print('$tag: (空数据)');
    return;
  }

  const int maxLogSize = 800; // Flutter print 安全长度限制
  final int messageLength = message.length;

  if (messageLength <= maxLogSize) {
    print('$tag: $message');
    return;
  }

  // 分行打印
  print(
      '$tag (总长度: $messageLength 字符，分${(messageLength / maxLogSize).ceil()}行打印):');

  for (int i = 0; i < messageLength; i += maxLogSize) {
    int end = messageLength < i + maxLogSize ? messageLength : i + maxLogSize;
    int partNumber = (i / maxLogSize).floor() + 1;
    String part = message.substring(i, end);
    print('$tag [第$partNumber部分]: $part');
  }

  print('$tag ===== 打印完成 =====');
}
