import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_connect/services/profile_service.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final _profileService = ProfileService();

  Future<String> get _uid async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('uid');
  }

  Future<bool> hasProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool('has_profile')) return true;

    return false;
  }

  Future<void> fetchProfile() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final String uid = await _uid;
      // final String uid = pref.getString('uid');

      DocumentSnapshot documentSnapshot =
          await _profileService.fetchProfile(uid: uid);

      final _profileSnap = documentSnapshot.data;

      if (documentSnapshot.exists) {
        await pref.setBool('has_profile', true);
        await pref.setString('firstname', _profileSnap['firstname']);
        await pref.setString('lastname', _profileSnap['lastname']);
        await pref.setString('mobilePhone', _profileSnap['mobilePhone']);
        await pref.setString('otherPhone', _profileSnap['otherPhone']);
        await pref.setString('address', _profileSnap['address']);
        await pref.setString('created', _profileSnap['created'].toString());
        await pref.setString(
            'lastUpdate', _profileSnap['lastUpdate'].toString());
      }

      // return Profile(
      //     uid: uid,
      //     firstname: _profileSnap['firstname'],
      //     lastname: _profileSnap['lastname'],
      //     mobilePhone: _profileSnap['mobilePhone'],
      //     otherPhone: _profileSnap['otherPhone'],
      //     address: _profileSnap['address'],
      //     created: _profileSnap['created'],
      //     lastUpdate: _profileSnap['lastUpdate']);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> createProfile(
      {@required String firstname,
      @required String lastname,
      @required String mobilePhone,
      @required String otherPhone,
      @required String address}) async {
    try {
      final String uid = await _uid;

      await _profileService.createProfile(
          uid: uid,
          firstname: firstname,
          lastname: lastname,
          mobilePhone: mobilePhone,
          otherPhone: otherPhone,
          address: address);
    } catch (e) {
      throw (e);
    }
  }
}
