package com.example.pro.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@Service
public class CloudinaryService {

    private final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "jhf225yx",
            "api_key", "719397824391293",
            "api_secret", "qPhh0sLzGvlczgU0sGmAkwNUmfI"
    ));

    public String uploadPdf(MultipartFile file) throws Exception {
        Map uploadResult = cloudinary.uploader().upload(
                file.getBytes(),
                ObjectUtils.asMap("resource_type", "raw") // "raw" = needed for PDFs, not just images
        );
        return uploadResult.get("secure_url").toString(); // permanent public URL
    }
}