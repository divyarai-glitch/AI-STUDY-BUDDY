package com.example.pro.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.stereotype.Service;
import com.google.firebase.cloud.FirestoreClient;
@Service
public class NotificationService {

//    public void sendToUser(String fcmToken, String title, String body) throws Exception {
//        Message message = Message.builder()
//                .setToken(fcmToken)
//                .setNotification(Notification.builder().setTitle(title).setBody(body).build())
//                .build();
//        FirebaseMessaging.getInstance().send(message);
//    }

    public void sendToUser(String userId, String title, String body) throws Exception {
        var userDoc = FirestoreClient.getFirestore().collection("users").document(userId).get().get();
        String fcmToken = userDoc.getString("fcmToken");
        if (fcmToken == null) return;

        Message message = Message.builder()
                .setToken(fcmToken)
                .setNotification(Notification.builder().setTitle(title).setBody(body).build())
                .build();
        FirebaseMessaging.getInstance().send(message);
    }
}