import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

class DatabaseService {
	final DatabaseReference _db = FirebaseDatabase.instance.ref().child('attendees');

	Future<Map<dynamic, dynamic>?> getAttendee(String userId) async {
 	  DatabaseReference userRef = _db.child(userId);
 	  DataSnapshot snapshot = await userRef.get();

 	  if (snapshot.exists) {
 	    return snapshot.value as Map<dynamic, dynamic>;
 	  } else {
 	    print('User data not found for userId: $userId');
 	    return null;
 	  }
 	}

 	Future<void> updateAttendanceStatus(String userId) async {
	    DatabaseReference userRef = _db.child(userId);

	    try {
	      // Updating attendance_status to TRUE
	      await userRef.update({'attendance_status': true});
	      print('Successfully updated attendance status for userId: $userId');
	    } catch (e) {
	      print('Failed to update attendance status: $e');
	    }
	}

	Future<void> updateFoodStatus(String userId) async {
	    DatabaseReference userRef = _db.child(userId);

	    try {
	      // Updating attendance_status to TRUE
	      await userRef.update({'food_status': true});
	      print('Successfully updated attendance status for userId: $userId');
	    } catch (e) {
	      print('Failed to update attendance status: $e');
	    }
	}
}