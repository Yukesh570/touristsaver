package org.touristsaver.memberapp

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onNewIntent(intent: Intent) {
        intent.putExtra("branch_force_new_session", true)
        super.onNewIntent(intent)
    }
}
