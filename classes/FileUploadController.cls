public with sharing class FileUploadController {
  @AuraEnabled
    public static Id uploadFile(String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = new Attachment();
        a.parentId = 'a001r00000nrxtCAAQ';
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType; 
        insert a;
        System.debug(a.Id);
        return a.Id;
    }
    
    @AuraEnabled
    public static List<Attachment> getAttachs(String parentId){
        List<Attachment> attachedFiles = [select Id 
from Attachment  where parentId ='a001r00000nrxtRAAQ' and ContentType in ('image/png', 'image/jpeg', 'image/gif') ];
       
        return attachedFiles;
    }
}