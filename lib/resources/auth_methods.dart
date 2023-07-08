import 'dart:typed_data';
import 'package:ogchat/models/user.dart' as model;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ogchat/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentuser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('usuarios').doc(currentuser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Error inesperado";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('fotosPerfil', file, true);

        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            photoUrl: photoUrl,
            followers: [],
            following: []);

        await _firestore
            .collection('usuarios')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "Perfil creado";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "El correo no es valido";
      } else if (err.code == 'weak-password') {
        res = "La contraseña es demasiado corta";
      } else if (err.code == 'email-already-in-use') {
        res = "El correo ya está en uso";
      } else if (err.code == 'too-many-requests') {
        res = "Demasiados intentos de inicio de sesión";
      } else if (err.code == 'invalid-password') {
        res = "La contraseña es demasiado corta";
      } else if (err.code == 'null-email') {
        res = "El correo no puede estar vacío";
      } else if (err.code == 'null-password') {
        res = "La contraseña no puede estar vacía";
      } else if (err.code == 'null-username') {
        res = "El nombre de usuario no puede estar vacío";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error inesperado";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = "Rellena todos los campos";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "El usuario no existe";
      } else if (e.code == 'wrong-password') {
        res = "La contraseña es incorrecta";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
