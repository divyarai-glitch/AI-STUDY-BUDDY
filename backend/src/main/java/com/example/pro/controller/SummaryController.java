package com.example.pro.controller;

import com.example.pro.service.GeminiService;
import com.example.pro.service.FirestoreService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.pro.service.NotificationService;

import java.util.Map;

@RestController
@RequestMapping("/api/notes")
@CrossOrigin(origins = "*")
public class SummaryController {

    private final GeminiService geminiService;
    private final FirestoreService firestoreService;
    private final NotificationService notificationService;

    public SummaryController(GeminiService geminiService, FirestoreService firestoreService, NotificationService notificationService) {
        this.geminiService = geminiService;
        this.firestoreService = firestoreService;
        this.notificationService = notificationService;
    }

//    @PostMapping("/{noteId}/summary")
//    public ResponseEntity<?> generateSummary(@PathVariable String noteId, @RequestParam String userId) throws Exception {
//        String noteText = firestoreService.getNoteText(noteId);
//        String summary = geminiService.generateSummary(noteText);
//
//        firestoreService.saveSummary(noteId, summary);
//        notificationService.sendToUser(userId, "Summary Ready! 📚", "Your notes summary is ready to view.");
//
//        return ResponseEntity.ok(Map.of("summary", summary));
//    }

    @PostMapping("/{noteId}/summary")
    public ResponseEntity<?> generateSummary(@PathVariable String noteId, @RequestParam String userId) throws Exception {
        // Check if summary already exists — avoid regenerating every time
        String existingSummary = firestoreService.getSummary(noteId);
        if (existingSummary != null && !existingSummary.isBlank()) {
            return ResponseEntity.ok(Map.of("summary", existingSummary));
        }

        String noteText = firestoreService.getNoteText(noteId);
        String summary = geminiService.generateSummary(noteText);

        firestoreService.saveSummary(noteId, summary);
        notificationService.sendToUser(userId, "Summary Ready! 📚", "Your notes summary is ready to view.");

        return ResponseEntity.ok(Map.of("summary", summary));
    }
}