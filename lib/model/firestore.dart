import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeProvider = Provider((_) => FirebaseFirestore.instance);

final cdbProvider = Provider((ref) async {});
