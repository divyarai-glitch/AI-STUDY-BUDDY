
package com.example.pro.model;

import java.util.Date;

public class Note {
    public String title;
    public String subject;
    public String text;
    public String userId;
    public Date createdAt;
    public String pdfUrl;
    public Note() {
    }

    public Note(String title, String subject, String text, String userId,String pdfUrl) {
        this.title = title;
        this.subject = subject;
        this.text = text;
        this.userId = userId;
        this.createdAt = new Date();
        this.pdfUrl = pdfUrl;
    }
}