package com.miracos.mirchat

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import com.google.firebase.Timestamp
import com.google.firebase.firestore.FirebaseFirestore

class CallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
            val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
            val incomingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

            if (state == TelephonyManager.EXTRA_STATE_RINGING && !incomingNumber.isNullOrEmpty()) {
                val db = FirebaseFirestore.getInstance()
                val callData = hashMapOf(
                    "callerNumber" to incomingNumber,
                    "timestamp" to Timestamp.now(),
                    "device" to "J7 Prime"
                )

                db.collection("calls").add(callData)
            }
        }
    }
}