public class CSFlowController {
    public Flow.Interview.Form_Selection_Master_Flow myFlow {get;set;}
    public List<Attachment> newAttachments {get; set; }
    public ID returnId;
    public String recordTypeName {get;set;}
    public String militaryPriority {get;set;}
    public Boolean recordCreated {get;set;}
    private final Integer NUM_OF_ATTACHMENTS = 10; 
    public String currentUserlanguage {get;set;}
    public ID flowID {get;set;}
    public String AccessGroup {get;set;}
    public List<FeedItem> lfi {get;set;}

    public CSFlowController() {
        if(myFlow != null) {
            flowID = myFlow.RecordIDMaster;
            System.debug('flowid===>'+flowID);
        }

        newAttachments=new List<Attachment>();
          for(Integer i=0; i<NUM_OF_ATTACHMENTS; i++) {
              newAttachments.add(new Attachment());
          }
        currentUserLanguage = userinfo.getLanguage();
        
    }

    public String getUserProfile() {
        Profile p =[select Name from Profile where Id = :userinfo.getProfileId() Limit 1];
        
            System.debug('profile ' + p.Name);
            recordTypeName = p.Name;
            return recordTypeName;
    }
    
    public String getuserAccessGroup() {
        User u =[select Access_Group__c from User where Id = :userinfo.getUserId() Limit 1];
            System.debug('User Access Group: ' + u.Access_Group__c);
            AccessGroup = u.Access_Group__c;
            return AccessGroup;
    }     
   
    public String getMilitaryPriorityCurrentUser() {
        User p1 = [select name,profileId, Profile.Name,Military__c from User where Id = :userinfo.getUserId()];
        System.debug(p1.Profile.Name);
        if(p1.Profile.Name == 'Company Employee') {
            militaryPriority = p1.Military__c;
            return militaryPriority;
        }
        else {
            User currentUser = [select contactID from User where id = :userinfo.getUserId()];
            List<Contact> c = [select accountId from Contact where id = :currentUser.contactID ];
            system.debug('contact size:::'+c.size());
            if(c.size() > 0) {
                Account a = [select Name, Military__c from Account where id =: c[0].AccountId];
                    if(a.military__c == null){
                       militaryPriority = 'null';
                       return militaryPriority;
                    } else {
                      militaryPriority = a.Military__c;
                      return militaryPriority;
                    }
            }
             else {
                militaryPriority = 'null';
                return militaryPriority;
             }
        }
    }

    public void addMore() {
        newAttachments=new List<Attachment>();
        for (Integer i=0; i<NUM_OF_ATTACHMENTS; i++) {
            newAttachments.add(new Attachment());
        }
    }
    
/*    public List<Attachment> getAtts() {
        if(myFlow != null) {
            List<Attachment> currentAttachments = [select Name, BodyLength, ContentType  from Attachment where parentId = :myFlow.RecordIDMaster];
            if(currentAttachments.size() > 0) {
                return currentAttachments;
            }

        }
        return null;
    }
*/

    public Map<String,String> getFeedList() {
            
            Map<String,String> MapOfFiles=new Map<String,String>();
            if(myFlow != null) {
               lfi = [select parentId,Type, ContentSize, ContentFileName,Title from FeedItem where parentId = :myFlow.RecordIDMaster AND Type = 'ContentPost'];
               if(lfi.size() > 0) {
                   system.debug('Feedlist to render ==>'+lfi);
                   for(FeedItem FI:lfi)
                   {
                       String fsize=String.valueOf(FI.ContentSize);
                       String fname=String.valueOf(FI.ContentFileName);
                       MapOfFiles.put(fname,fsize);
                    }   
                   return MapOfFiles;
                }
            }
            return null;
        }


    public void save() {
        if(myFlow != null) {
        flowID = myFlow.RecordIDMaster;
        }
        List<Attachment> toInsert=new List<Attachment>();
        for (Attachment newAtt : newAttachments) {
            if (newAtt.Body!=null) {
                newAtt.parentId=flowID;
                toInsert.add(newAtt);
            }
        }
        if(toInsert.size() > 0){
            recordCreated = true;
            insert toInsert;
            newAttachments.clear();
            addMore();   
        }
    }
}