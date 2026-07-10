package com.example.pro.controller;

import com.example.pro.service.GeminiService;
import com.example.pro.service.RagService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notes")
@CrossOrigin(origins = "*")
public class ChatController {

    private final GeminiService geminiService;
    private final RagService ragService;

    public ChatController(GeminiService geminiService, RagService ragService) {
        this.geminiService = geminiService;
        this.ragService = ragService;
    }

    @PostMapping("/{noteId}/chat")
    public ResponseEntity<?> chat(@PathVariable String noteId, @RequestBody Map<String, String> body) throws Exception {
        String question = body.get("question");
        List<String> relevantChunks = ragService.retrieveRelevantChunks(noteId, question, 4);
        String context = String.join("\n\n", relevantChunks);

        String answer = geminiService.callGeminiPublic(
                "You are a study assistant. Answer ONLY using the context below, from the student's own notes. If the answer isn't in the context, say \"That's not covered in your notes.\"\nContext:\n" + context,
                question
        );

        return ResponseEntity.ok(Map.of("answer", answer));
    }
}