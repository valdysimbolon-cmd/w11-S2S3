import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesRepository {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // CREATE
  Future<void> add(String title) => _db.collection('notes').add({
        'title': title,
        'uid': _uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

  // READ (real time), hanya catatan milik pengguna
  Stream<QuerySnapshot<Map<String, dynamic>>> watch() => _db
      .collection('notes')
      .where('uid', isEqualTo: _uid)
      .snapshots();

  // UPDATE
  Future<void> update(String id, String title) =>
      _db.collection('notes').doc(id).update({'title': title});

  // DELETE
  Future<void> delete(String id) => _db.collection('notes').doc(id).delete();
}