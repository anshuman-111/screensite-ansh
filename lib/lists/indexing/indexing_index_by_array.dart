import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firestore.dart';

class IndexingIndexByArray extends ConsumerWidget {
  final String entityId;
  final String indexId;

  const IndexingIndexByArray(this.entityId, this.indexId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(filteredColSP(QueryParams(
            path: 'list/$entityId/index/$indexId/entityIndexFields/',
            orderBy: 'createdTimestamp')))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (data) {
              return Row(children: [
                Container(
                    width: 80,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Text('Index by'))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Text(
                        '[${data.docs.map((entry) => entry.data()['value']).join('')}]'))
              ]);
            });
  }
}
