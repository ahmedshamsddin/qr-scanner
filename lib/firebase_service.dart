import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

class DatabaseService {
	final DatabaseReference _db = FirebaseDatabase.instance.ref().child('count');

	Future<void> getCount () async {
		DatabaseReference countRef = FirebaseDatabase.instance.ref().child('count');
		DataSnapshot snapshot = await countRef.get();

		if (snapshot.exists) {
			print(snapshot.value);
		} else {
			print('no count');
		}
	}

}