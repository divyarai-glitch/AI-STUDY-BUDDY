package com.example.pro.service;

import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class RagService {

    private final EmbeddingService embeddingService;

    // In-memory cache: noteId -> list of (chunkText, embedding)
    private final Map<String, List<Chunk>> noteChunks = new ConcurrentHashMap<>();

    public RagService(EmbeddingService embeddingService) {
        this.embeddingService = embeddingService;
    }

    public record Chunk(String text, List<Double> embedding) {}

    public void ingestNote(String noteId, String fullText) throws Exception {
        List<String> chunks = splitIntoChunks(fullText, 800); // ~800 chars per chunk
        List<Chunk> embeddedChunks = new ArrayList<>();

        for (String chunk : chunks) {
            List<Double> embedding = embeddingService.embed(chunk);
            embeddedChunks.add(new Chunk(chunk, embedding));
        }

        noteChunks.put(noteId, embeddedChunks);
    }

    public List<String> retrieveRelevantChunks(String noteId, String question, int topK) throws Exception {
        List<Chunk> chunks = noteChunks.get(noteId);

        // Lazily ingest if not already cached (e.g. after server restart)
        if (chunks == null) return List.of();

        List<Double> questionEmbedding = embeddingService.embed(question);

        return chunks.stream()
                .sorted((a, b) -> Double.compare(
                        embeddingService.cosineSimilarity(questionEmbedding, b.embedding()),
                        embeddingService.cosineSimilarity(questionEmbedding, a.embedding())
                ))
                .limit(topK)
                .map(Chunk::text)
                .toList();
    }

    private List<String> splitIntoChunks(String text, int chunkSize) {
        List<String> chunks = new ArrayList<>();
        for (int i = 0; i < text.length(); i += chunkSize) {
            chunks.add(text.substring(i, Math.min(i + chunkSize, text.length())));
        }
        return chunks;
    }
}