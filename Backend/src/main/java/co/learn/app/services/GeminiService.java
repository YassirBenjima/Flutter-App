package co.learn.app.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.*;

@Service
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public String generateContent(String prompt) {
        // Construct the URL with the API key
        String url = apiUrl + "?key=" + apiKey;

        // Set headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Build the request body: { "contents": [{ "parts": [{ "text": "prompt" }] }] }
        Map<String, Object> part = new HashMap<>();
        part.put("text", prompt);

        Map<String, Object> contentObject = new HashMap<>();
        contentObject.put("parts", Collections.singletonList(part));

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("contents", Collections.singletonList(contentObject));

        // Create the HTTP entity
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        int maxRetries = 6;
        int attempt = 0;

        while (attempt < maxRetries) {
            try {
                // Send POST request
                ResponseEntity<Map> response = restTemplate.postForEntity(url, request, Map.class);
                return extractTextFromResponse(response.getBody());
            } catch (org.springframework.web.client.HttpClientErrorException.TooManyRequests e) {
                attempt++;
                long waitTime = attempt * 5000L; // 5s, 10s, 15s...
                System.err.println("Gemini Quota Exceeded (429). Details: " + e.getResponseBodyAsString());
                System.err.println("Retrying in " + (waitTime / 1000) + " seconds... (Attempt " + attempt + "/"
                        + maxRetries + ")");
                try {
                    Thread.sleep(waitTime);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                }
            } catch (Exception e) {
                System.err.println("Error calling Gemini API: " + e.getMessage());
                throw new RuntimeException("Gemini API Error: " + e.getMessage());
            }
        }

        throw new RuntimeException(
                "Gemini API Error: Quota exceeded after " + maxRetries + " retries. Please try again later.");
    }

    private String extractTextFromResponse(Map<String, Object> response) {
        try {
            if (response == null || !response.containsKey("candidates"))
                return "No response data";

            List<Map<String, Object>> candidates = (List<Map<String, Object>>) response.get("candidates");
            if (candidates == null || candidates.isEmpty())
                return "No candidates found";

            Map<String, Object> candidate = candidates.get(0);
            Map<String, Object> content = (Map<String, Object>) candidate.get("content");
            if (content == null)
                return "No content in candidate";

            List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
            if (parts == null || parts.isEmpty())
                return "No parts in content";

            return (String) parts.get(0).get("text");
        } catch (Exception e) {
            return "Error parsing response: " + e.getMessage();
        }
    }
}
