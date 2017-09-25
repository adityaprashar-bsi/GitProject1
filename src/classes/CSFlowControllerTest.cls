@isTest
public class CSFlowControllerTest{

enum PortalType { CSPLiteUser, PowerCustomerSuccess, PowerPartner, CustomerSuccess }
    
    static testmethod void usertest() {
        
        CSFlowController csf = new CSFlowController();
        
        User pu = getPortalUser(PortalType.PowerCustomerSuccess, null, true);
        
        System.assert([select isPortalEnabled 
                         from user 
                        where id = :pu.id].isPortalEnabled,
                      'User was not flagged as portal enabled.');       
          
        System.RunAs(pu) {
            System.assert([select isPortalEnabled 
                             from user 
                            where id = :UserInfo.getUserId()].isPortalEnabled, 
                          'User wasnt portal enabled within the runas block. ');
          
          csf.getUserProfile();
          csf.getuserAccessGroup();
          csf.getMilitaryPriorityCurrentUser();
          csf.addMore();
          csf.save();
          csf.getFeedList();
        }
    }
     
        
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
    
        System.debug('portalType is::::::::'+portalType);
        // Make sure the running user has a role otherwise an exception will be thrown.
        if(userWithRole == null) {   
            
            if(UserInfo.getUserRoleId() == null) {

                UserRole ur= new UserRole(name = 'TEST ROLE');
                Database.insert(ur);
                
                Profile p2 = [SELECT Id  FROM Profile WHERE Name='Company Employee'];
               
        userWithRole = new User(firstname = 'user1', lastname = 'one', profileid = p2.Id ,userroleid = ur.id, Customer_priority__c = 'VIP', Military__c = 'Military', Username = 'use1@test.com.dev' ,
           Email = 'use1@test.com', Alias = 'useuse1' , Access_Group__c ='EXTERNAL', CommunityNickname = 'nickname1' , TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', 
           EmailEncodingKey='ISO-8859-1', LanguageLocaleKey = 'en_US' );        
        
        

         } else {
             UserRole ur= new UserRole(name = 'TEST ROLE');
                Database.insert(ur);
                
                Profile p2 = [SELECT Id  FROM Profile WHERE Name='CS Coordinator'];
               
        userWithRole = new User(firstname = 'user1', lastname = 'one', profileid = p2.Id ,userroleid = ur.id, Customer_priority__c = 'VIP', Military__c = '', Username = 'use1@test.com.dev' ,
           Email = 'use1@test.com', Alias = 'useuse1' , Access_Group__c ='EXTERNAL', CommunityNickname = 'nickname1' , TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', 
           EmailEncodingKey='ISO-8859-1', LanguageLocaleKey = 'en_US' );
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            
        }
        
        list<Account> aList = new list<Account>();
        list<Contact> cList = new list<Contact>();
        System.runAs(userWithRole) {

            aList.add(new Account(name = 'TEST ACCOUNT'));
            aList.add(new Account(name = 'TEST ACCOUNT2',Military__c='Military'));
            Database.insert(alist);
            
            cList.add(new Contact(AccountId = aList[0].id, lastname = 'lastname'));
            cList.add(new Contact(AccountId = aList[1].id, lastname = 'lastname'));
            Database.insert(clist);
            
            RecordType r = [select name,id from Recordtype where name = 'Orders' limit 1];
            CSFlowController test1 = new CSFlowController();
        
            Case case1 = new Case(recordTypeId = r.id);
            insert case1;
            
        //test1.flowID = CSFlowController.flowID;
        test1.flowID = case1.Id;
        test1.addMore();
        List<Attachment> newAtt = test1.newAttachments;
            
        newAtt[0].Name='Unit Test 1';
        newAtt[0].Body=Blob.valueOf('Unit Test 1');

        newAtt[2].Name='Unit Test 2';
        newAtt[2].Body=Blob.valueOf('Unit Test 2');

        test1.save();
        test1.getFeedList();
        }
             
        //all military are vip, not all vip are military
        
        //Get any profile for the given type.
        Profile p = [select id from profile where usertype = :portalType.name() limit 1];   
        
        String testemail = 'puser000@amamama.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname',contactId = cList[1].id);
        
        
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
        
        
       

    }
    
    
    public static testMethod void TestProfileType2(){
            
        CSFlowController csf1 = new CSFlowController();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Company Employee'];
        
        //System.debug('Profile name is:::'+p.Name);
        
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
        insert u1;
        
        // now insert your test data

       System.runAs(u1){
            csf1.getMilitaryPriorityCurrentUser();
        }
        
    }

}