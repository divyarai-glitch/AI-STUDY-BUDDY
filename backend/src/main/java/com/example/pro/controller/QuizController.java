//package com.example.pro.controller;
//
//public class QuizController {
//}
package com.example.pro.controller;

import com.example.pro.model.QuizQuestion;
import com.example.pro.service.GeminiService;
import com.example.pro.service.FirestoreService;
import com.example.pro.service.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.pro.service.NotificationService;

        import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notes")
@CrossOrigin(origins = "*")
public class QuizController {

    private final GeminiService geminiService;
    private final FirestoreService firestoreService;
    private final NotificationService notificationService;

    public QuizController(GeminiService geminiService, FirestoreService firestoreService, NotificationService notificationService) {
        this.geminiService = geminiService;
        this.firestoreService = firestoreService;
        this.notificationService = notificationService;
    }

//    @PostMapping("/{noteId}/quiz")
//    public ResponseEntity<?> generateQuiz(@PathVariable String noteId, @RequestParam String userId) throws Exception {
//        String noteText = firestoreService.getNoteText(noteId);
//        List<QuizQuestion> quiz = geminiService.generateQuiz(noteText);
//
//        firestoreService.saveQuiz(noteId, quiz);
//        notificationService.sendToUser(userId, "Quiz Ready! 🧠", "Your quiz is ready — test yourself now.");
//
//        return ResponseEntity.ok(Map.of("quiz", quiz));
//    }

    @PostMapping("/{noteId}/quiz")
    public ResponseEntity<?> generateQuiz(@PathVariable String noteId, @RequestParam String userId) throws Exception {
        List<Map<String, Object>> existingQuiz = firestoreService.getQuiz(noteId);
        if (existingQuiz != null && !existingQuiz.isEmpty()) {
            return ResponseEntity.ok(Map.of("quiz", existingQuiz));
        }

        String noteText = firestoreService.getNoteText(noteId);
        List<QuizQuestion> quiz = geminiService.generateQuiz(noteText);

        firestoreService.saveQuiz(noteId, quiz);
        notificationService.sendToUser(userId, "Quiz Ready! 🧠", "Your quiz is ready — test yourself now.");

        return ResponseEntity.ok(Map.of("quiz", quiz));
    }
}