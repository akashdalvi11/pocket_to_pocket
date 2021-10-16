import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseEndpoint{
    addCurrentTimestamp() async{
      await FirebaseFirestore.instance.collection('signals').doc('movingAverage').update({
        'timestamps':FieldValue.arrayUnion([DateTime.now()])
      });
    }
}