import 'dart:html' as html;
import 'dart:convert';

class WebUtils {
  static void downloadCSV(String content, String fileName) {
    // Convert content to bytes and then to a blob
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes]);
    
    // Create an object URL from the blob
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // Create an anchor element and set the download attribute
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    
    // Clean up by revoking the object URL
    html.Url.revokeObjectUrl(url);
  }
}
