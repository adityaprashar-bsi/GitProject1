public without sharing class CaseController {
  
   @AuraEnabled
   public static List<Case> getCases() {
       String CurrentUser=UserInfo.getUserId();
       return [SELECT Id, CaseNumber,CreatedDate,Status,Owner.Name,Subject,RecordType.Name,Type,Submitter__r.Name FROM Case WHERE Submitter__c=:CurrentUser AND Submitted__c=True ORDER BY CaseNumber DESC];
   }
   
   @AuraEnabled
   public static Boolean getUserProf() {  
        User u=[Select id,AccountId,UserType,ProfileId from User where id=:UserInfo.getUserId()];
        system.debug(u);
        string uid=u.id;
        List<Profile> p = [SELECT UserLicense.Name FROM Profile WHERE id=:u.ProfileId limit 1];
        system.debug(p);
        String usrLic= p[0].UserLicense.Name;
        system.debug('usrLic====>'+usrLic);
        String usrAcc= u.AccountId;
              
         if(usrLic=='Customer Community Plus')
            return true;
         else
            return false;
   } 
  
   @AuraEnabled
   public static List<Case> getClosedCases() {
       String CurrentUser=UserInfo.getUserId();
       return [SELECT Id, CaseNumber,CreatedDate,Status,Owner.Name,Subject,RecordType.Name,Type,Submitter__r.Name FROM Case WHERE Submitter__c=:CurrentUser AND Submitted__c=True AND IsClosed=true ORDER BY CaseNumber DESC];
   }    
   
    @AuraEnabled
    public static List<Case> getOpenCases() {
       String CurrentUser=UserInfo.getUserId();
       return [SELECT Id, CaseNumber,CreatedDate,Status,Owner.Name,Subject,RecordType.Name,Type,Submitter__r.Name FROM Case WHERE Submitter__c=:CurrentUser AND IsClosed!=true AND Submitted__c=True ORDER BY CaseNumber DESC];
   }     

   @AuraEnabled
   public static List<Case> getAllClosedCases() {
   
       if(getUserProf())
         {
              UserAccess ua=new UserAccess(); 
              Set<Case> userCaseSet=ua.userCases();
              List<Case> sumitterCaselist = [Select id from case where Submitter__c=:UserInfo.getUserId()];
              system.debug('Set Size BEFORE adding list==>'+userCaseSet.size());
              userCaseSet.addAll(sumitterCaselist);
              system.debug('Set Size AFTER adding list==>'+userCaseSet.size());             
              List<Case> csList= [SELECT id, Account.Name, CaseNumber,CreatedDate,Status,Owner.Name,Subject,RecordType.Name,Type,Submitter__r.Name FROM Case WHERE IsClosed=true AND id IN :userCaseSet AND Submitted__c=True ORDER BY CaseNumber DESC];
              system.debug('csList=====>'+csList);
              return csList;
         }
       else
              return null;    
   }    
   
    @AuraEnabled
    public static List<Case> getAllOpenCases() {
       
       if(getUserProf())
         {
              UserAccess ua=new UserAccess();
              Set<Case> userCaseSet=ua.userCases();
              List<Case> sumitterCaselist = [Select id from case where Submitter__c=:UserInfo.getUserId()];
              userCaseSet.addAll(sumitterCaselist);
              return [SELECT id,Account.Name,CaseNumber,CreatedDate,Status,Owner.Name,Subject,RecordType.Name,Type,Submitter__r.Name FROM Case WHERE IsClosed!=true AND id IN :userCaseSet AND Submitted__c=True ORDER BY CaseNumber DESC];
          }
       else
           return null;
    }  


}