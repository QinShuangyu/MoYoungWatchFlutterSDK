import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

Widget avatar(Contact contact,
    [double radius = 48.0, IconData defaultIcon = Icons.person]) {
  Uint8List? photoOrThumbnail = contact.photoOrThumbnail;
  if (photoOrThumbnail != null) {
    return CircleAvatar(
      backgroundImage: MemoryImage(photoOrThumbnail),
      radius: radius,
    );
  }
  return CircleAvatar(
    radius: radius,
    child: Icon(defaultIcon),
  );
}
