import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notion_test/data/models/note_model.dart';
import 'package:notion_test/data/repository/firestore_repository.dart';

class FirestoreService implements FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Future<void> addNote(NoteModel note) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(note.id)
          .set(note.toDocument());
    } catch (e) {
      log('$e');
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(note.id)
          .update(note.toDocument());
    } catch (e) {
      log('$e');
      throw Exception('Error updating notes');
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      log('$e');
      throw Exception('Error deleting notes');
    }
  }

  @override
  Future<List<NoteModel>> fetchNotes() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .orderBy('date')
          .get();
      return snapshot.docs.map((doc) => NoteModel.fromDocument(doc)).toList();
    } catch (e) {
      log('$e');
      throw Exception('Error fetching notes');
    }
  }
}
