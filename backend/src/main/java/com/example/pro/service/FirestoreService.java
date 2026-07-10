
package com.example.pro.service;

import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import com.example.pro.model.Note;
import com.example.pro.model.QuizQuestion;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FirestoreService {

    public String saveNote(Note note) throws Exception {
        Firestore db = FirestoreClient.getFirestore();
        var docRef = db.collection("notes").document();
        docRef.set(note).get();
        return docRef.getId();
    }

    public String getNoteText(String noteId) throws Exception {
        var doc = FirestoreClient.getFirestore().collection("notes").document(noteId).get().get();
        return doc.getString("text");
    }

    public void saveSummary(String noteId, String summary) throws Exception {
        FirestoreClient.getFirestore().collection("notes").document(noteId)
                .update("summary", summary).get();
    }

    public void saveQuiz(String noteId, List<QuizQuestion> quiz) throws Exception {
        List<Map<String, Object>> quizData = quiz.stream()
                .map(q -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("question", q.question());
                    map.put("options", q.options());
                    map.put("correctAnswer", q.correctAnswer());
                    return map;
                })
                .toList();

        FirestoreClient.getFirestore().collection("notes").document(noteId)
                .update("quiz", quizData).get();
    }

    public String getSummary(String noteId) throws Exception {
        var doc = FirestoreClient.getFirestore().collection("notes").document(noteId).get().get();
        return doc.getString("summary");
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getQuiz(String noteId) throws Exception {
        var doc = FirestoreClient.getFirestore().collection("notes").document(noteId).get().get();
        return (List<Map<String, Object>>) doc.get("quiz");
    }
}