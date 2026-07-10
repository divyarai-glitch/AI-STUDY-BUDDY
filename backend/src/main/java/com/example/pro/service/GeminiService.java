package com.example.pro.service;

import com.example.pro.model.QuizQuestion;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.*;

@Service
public class GeminiService {

    @Value("${gemini.api-key}")
    private String apiKey;

    private final RestClient restClient = RestClient.create();
    private final ObjectMapper mapper = new ObjectMapper();

    private static final String GENERATE_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=";

    private String callGemini(String systemPrompt, String userPrompt) throws Exception {
        Map<String, Object> body = Map.of(
                "contents", List.of(
                        Map.of("role", "user", "parts", List.of(Map.of("text", userPrompt)))
                ),
                "systemInstruction", Map.of(
                        "parts", List.of(Map.of("text", systemPrompt))
                )
        );

        String response = restClient.post()
                .uri(GENERATE_URL + apiKey)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .body(String.class);

        JsonNode root = mapper.readTree(response);
        return root.path("candidates").get(0)
                .path("content").path("parts").get(0)
                .path("text").asText();
    }

    public String generateSummary(String noteText) throws Exception {
        return callGemini(
                "You are a helpful study assistant. Summarize student notes clearly and concisely, using bullet points for key concepts.",
                "Summarize these notes:\n\n" + noteText
        );
    }

//    public List<QuizQuestion> generateQuiz(String noteText) throws Exception {
//        String formatInstructions = """
//            Respond with ONLY a valid JSON array, no markdown, no explanation, no code fences.
//            Format exactly like this:
//            [
//              {"question": "...", "options": ["...", "...", "...", "..."], "correctAnswer": "..."},
//              ...
//            ]
//            Generate exactly 5 questions.
//            """;
//
//        String rawResponse = callGemini(
//                "You are a quiz generator for students. Create multiple-choice questions based only on the provided notes.",
//                "Notes:\n" + noteText + "\n\n" + formatInstructions
//        );
//
//        // Strip markdown code fences if Gemini adds them despite instructions
//        String cleaned = rawResponse.trim()
//                .replaceAll("^```json\\s*", "")
//                .replaceAll("^```\\s*", "")
//                .replaceAll("```$", "")
//                .trim();
//
//        JsonNode arrayNode = mapper.readTree(cleaned);
//        List<QuizQuestion> questions = new ArrayList<>();
//
//        for (JsonNode q : arrayNode) {
//            List<String> options = new ArrayList<>();
//            q.path("options").forEach(o -> options.add(o.asText()));
//            questions.add(new QuizQuestion(
//                    q.path("question").asText(),
//                    options,
//                    q.path("correctAnswer").asText()
//            ));
//        }
//
//        return questions;
//    }
public List<QuizQuestion> generateQuiz(String noteText) throws Exception {
    String formatInstructions = """
        Respond with ONLY a valid JSON array, no markdown, no explanation, no code fences.
        Format exactly like this:
        [
          {"question": "...", "options": ["...", "...", "...", "..."], "correctAnswer": "..."},
          ...
        ]
        Generate exactly 5 questions.
        """;

    String rawResponse = callGemini(
            "You are a quiz generator for students. Create multiple-choice questions based only on the provided notes.",
            "Notes:\n" + noteText + "\n\n" + formatInstructions
    );

    System.out.println("RAW GEMINI QUIZ RESPONSE: " + rawResponse); // temporary debug line

    String cleaned = rawResponse.trim()
            .replaceAll("^```json\\s*", "")
            .replaceAll("^```\\s*", "")
            .replaceAll("```$", "")
            .trim();

    try {
        JsonNode arrayNode = mapper.readTree(cleaned);
        List<QuizQuestion> questions = new ArrayList<>();

        for (JsonNode q : arrayNode) {
            List<String> options = new ArrayList<>();
            q.path("options").forEach(o -> options.add(o.asText()));
            questions.add(new QuizQuestion(
                    q.path("question").asText(),
                    options,
                    q.path("correctAnswer").asText()
            ));
        }
        return questions;
    } catch (Exception e) {
        System.out.println("FAILED TO PARSE QUIZ JSON. Cleaned text was:\n" + cleaned);
        throw e;
    }
}
    public String callGeminiPublic(String systemPrompt, String userPrompt) throws Exception {
        return callGemini(systemPrompt, userPrompt);
    }
}