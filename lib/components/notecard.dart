import 'package:flutter/material.dart';
import 'package:notephp/constant/linkapi.dart';

import '../model/viewnotemodel.dart';

class CardNote extends StatelessWidget {
  final ViewNote viewnote;
  final void Function()? ontap;
  final void Function()? onlongpress;
  const CardNote(
      {super.key, this.ontap, this.onlongpress, required this.viewnote});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onlongpress,
      onTap: ontap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                '$linkimagenote/${viewnote.notesImage}',
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(viewnote.notesTitle!),
                subtitle: Text(viewnote.notesContent!),
              ),
            )
          ],
        ),
      ),
    );
  }
}
