import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> getOnboardingData() async {
    final snapshot =
        await _firestore
            .collection('onboarding')
            .orderBy(FieldPath.documentId)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'tag': data['tag'] as String? ?? '',
        'title': data['title'] as String? ?? '',
        'subtitle': data['subtitle'] as String? ?? '',
        'image': data['image'] as String? ?? '',
      };
    }).toList();
  }
}
