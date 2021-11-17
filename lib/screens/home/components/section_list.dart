import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/section.dart';
import 'package:sim_chefe_2021/screens/home/components/section_header.dart';

import 'item_tile.dart';

class SectionList extends StatelessWidget {

  const SectionList(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return ItemTile(section.items[index]);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 4,),
              itemCount: section.items.length
            ),
          )
        ],
      ),
    );
  }
}
