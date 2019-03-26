import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageRepository {
  final _pageService = PageService();

  Future<String> get _uid async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('uid');
  }

  Future<List<Page>> fetchPages() async {
    try {
      QuerySnapshot snapshot = await _pageService.fetchPages();
      final List<Page> pages = [];

      if (snapshot.documents.length == -1) return pages;

      snapshot.documents.forEach((DocumentSnapshot snap) {
        pages.add(Page(
          uid: snap.documentID,
          pageTitle: snap.data['pageTitle'],
          pageDescription: snap.data['pageDescription'],
          pageImageUrl: snap.data['pageImageUrl'],
          created: snap.data['created'],
          lastUpdate: snap.data['lastUpdate'],
        ));
      });

      return pages;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchPage() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final String uid = await _uid;

      DocumentSnapshot documentSnapshot =
          await _pageService.fetchPage(uid: uid);

      final _profileSnap = documentSnapshot.data;

      if (documentSnapshot.exists) {
        await pref.setString('pageTitle', _profileSnap['pageTitle']);
        await pref.setString(
            'pageDescription', _profileSnap['pageDescription']);
        await pref.setString('pageImageUrl', _profileSnap['pageImageUrl']);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> createPage(
      {@required String pageTitle, String pageDescription}) async {
    try {
      final uid = await _uid;

      return await _pageService.createPage(
          uid: uid, pageTitle: pageTitle, pageDescription: pageDescription);
    } catch (e) {
      throw (e);
    }
  }
}
