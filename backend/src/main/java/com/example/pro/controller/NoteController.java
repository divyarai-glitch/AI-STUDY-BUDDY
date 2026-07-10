package com.example.pro.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.example.pro.model.Note;
import com.example.pro.service.CloudinaryService;
import com.example.pro.service.FirestoreService;
import com.example.pro.service.PdfService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.example.pro.service.RagService;

import java.util.Map;

@RestController
@RequestMapping("/api/notes")
@CrossOrigin(origins = "*")
public class NoteController {

    private final PdfService pdfService;
    private final FirestoreService firestoreService;
    private final CloudinaryService cloudinaryService;
    private final RagService ragService;

    public NoteController(PdfService pdfService, FirestoreService firestoreService, CloudinaryService cloudinaryService,RagService ragService) {
        this.pdfService = pdfService;
        this.firestoreService = firestoreService;
        this.cloudinaryService = cloudinaryService;
        this.ragService = ragService;
    }

    @PostMapping("/upload")
    public ResponseEntity<?> uploadNote(
            @RequestParam("file") MultipartFile file,
            @RequestParam("title") String title,
            @RequestParam("subject") String subject,
            @RequestParam("userId") String userId,
            @RequestHeader("Authorization") String authHeader) {

        try {
            String idToken = authHeader.replace("Bearer ", "");
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String verifiedUid = decodedToken.getUid();

            if (!verifiedUid.equals(userId)) {
                return ResponseEntity.status(403).body(Map.of("error", "User ID mismatch"));
            }

            // 1. Upload PDF to Cloudinary, get back a permanent URL
            String pdfUrl = cloudinaryService.uploadPdf(file);

            // 2. Extract text from the PDF
            String extractedText = pdfService.extractText(file);

            // 3. Save everything (including pdfUrl) to Firestore
          //  Note note = new Note(title, subject, extractedText, verifiedUid, pdfUrl);
            // 3. Save everything (including pdfUrl) to Firestore
            Note note = new Note(title, subject, extractedText, verifiedUid, pdfUrl);
            String noteId = firestoreService.saveNote(note);
            ragService.ingestNote(noteId, extractedText);
//            Note note = new Note(title, subject, extractedText, pdfUrl, verifiedUid);
//            String noteId = firestoreService.saveNote(note);
//            ragService.ingestNote(noteId, extractedText);

            return ResponseEntity.ok(Map.of(
                    "message", "Upload successful",
                    "noteId", noteId,
                    "pdfUrl", pdfUrl
            ));

        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}