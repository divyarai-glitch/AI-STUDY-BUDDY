//package com.example.pro.scheduler;
//
//public class MotivationScheduler {
//}

package com.example.pro.scheduler;

import com.example.pro.service.NotificationService;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

@Component
public class MotivationScheduler {

    private final NotificationService notificationService;

    private final List<String> quotes = List.of(
            "A little progress each day adds up to big results. 💪",
            "Your future self will thank you for studying today. 📖",
            "Consistency beats intensity — keep showing up!",
            "Every note you review today is a step closer to your goal."
    );

    public MotivationScheduler(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @Scheduled(cron = "0 0 9 * * *") // every day at 9 AM
    public void sendDailyMotivation() throws Exception {
        String quote = quotes.get(ThreadLocalRandom.current().nextInt(quotes.size()));
        List<String> allUserIds = getAllUserIds(); // implement: fetch from Firestore "users" collection
        for (String userId : allUserIds) {
            notificationService.sendToUser(userId, "Today's Motivation ✨", quote);
        }
    }

    private List<String> getAllUserIds() throws Exception {
        var docs = FirestoreClient.getFirestore().collection("users").get().get().getDocuments();
        return docs.stream().map(d -> d.getId()).toList();
    }
}