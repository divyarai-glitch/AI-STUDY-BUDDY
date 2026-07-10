package com.example.pro.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;


import java.util.*;

@Service
public class EmbeddingService {
    @Value("${gemini.api-key}")
    private String apiKey;

//    @Value("${spring.ai.google.genai.api-key}")
//    private String apiKey;

    private final RestClient restClient = RestClient.create();
    private final ObjectMapper mapper = new ObjectMapper();

    //private static final String EMBED_URL =
           // "https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=";
    private static final String EMBED_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=";
//    public List<Double> embed(String text) throws Exception {
//        Map<String, Object> body = Map.of(
//                "model", "models/text-embedding-004",
//                "content", Map.of("parts", List.of(Map.of("text", text)))
//        );
//
//        String response = restClient.post()
//                .uri(EMBED_URL + apiKey)
//                .contentType(MediaType.APPLICATION_JSON)
//                .body(body)
//                .retrieve()
//                .body(String.class);
//
//        JsonNode root = mapper.readTree(response);
//        JsonNode values = root.path("embedding").path("values");
//
//        List<Double> vector = new ArrayList<>();
//        values.forEach(v -> vector.add(v.asDouble()));
//        return vector;
//    }

    public List<Double> embed(String text) throws Exception {
        Map<String, Object> body = Map.of(
                "model", "models/gemini-embedding-001",   // <-- updated here
                "content", Map.of("parts", List.of(Map.of("text", text)))
        );

        String response = restClient.post()
                .uri(EMBED_URL + apiKey)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .body(String.class);

        JsonNode root = mapper.readTree(response);
        JsonNode values = root.path("embedding").path("values");

        List<Double> vector = new ArrayList<>();
        values.forEach(v -> vector.add(v.asDouble()));
        return vector;
    }
    public double cosineSimilarity(List<Double> a, List<Double> b) {
        double dot = 0, normA = 0, normB = 0;
        for (int i = 0; i < a.size(); i++) {
            dot += a.get(i) * b.get(i);
            normA += Math.pow(a.get(i), 2);
            normB += Math.pow(b.get(i), 2);
        }
        return dot / (Math.sqrt(normA) * Math.sqrt(normB));
    }
}