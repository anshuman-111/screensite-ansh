import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/search/search_results.dart';
import 'package:screensite/theme.dart';
import 'package:flutter/services.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class SearchDetails extends ConsumerWidget {
  final DocumentReference entityId;
  final StateNotifierProvider<GenericStateNotifier<DocumentReference?>,
      DocumentReference?> _selectedItemNotifier;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  SearchDetails(this.entityId, this._selectedItemNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return ref
        .watch(docSP('user/${auth.currentUser!.uid}/${entityId.path}'))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (searchDoc) {
              Timestamp? timeCreated = searchDoc.data()!['timeCreated'];
              return Container(
                  decoration: RoundedCornerContainer.containerStyle,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                'Searched Target: ${searchDoc.data()!['target']}'), //kk

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                                  foregroundColor: Theme.of(context).colorScheme.surface,
                                  // padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text("Copy"),
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: searchDoc.data()!['target'].toString()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Copied: ${searchDoc.data()!['target']}')));
                                })
                          ]),
                          SizedBox(height: 10,),
                      Text(
                          'Search Time: ${timeCreated != null ? Jiffy(timeCreated.toDate()).format("h:mm a, do MMM, yyyy") : ''}'),
                      SearchResults(searchDoc, _selectedItemNotifier),
                    ],
                  )));
            });
  }
}
