@isTest(SeeAllData=false)
public class CaseServicesTest {
   public static final String CASE_RT_Standard= 'Standard Case';
   public static final String ACCOUNT_RT_Distributor = 'Distributor';
   public static final String Vendor_Community_Profile = 'Vendor Community';
   public static final String Admin_Profile = 'System Administrator';
   public static final String Admin_Role = 'Application Admin';
   private static Id caseRTId{
    get{
      if (caseRTId== null){
        caseRTId= Schema.SObjectType.Case.getRecordTypeInfosByName().get(CASE_RT_Standard).getRecordTypeId();
      }
      return caseRTId;
    }
    set;
   }
   private static Id accountRTId{
    get{
      if (accountRTId== null){
        accountRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_RT_Distributor).getRecordTypeId();
      }
      return accountRTId;
    }
    set;
   }
   
   
   
   public static testMethod void testBusinessHoursBucketer() {
    
        //Define the next business day (Monday)
        caseServices.testDay = '1';
       
        //Setup the stop statuses
        Stop_Status__c ss = new Stop_Status__c(Name = 'On Hold');
        insert ss;

        //Insert new case
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;

        //Update the case with Stop Status
        c.Status = 'On Hold';
        update c;

        //Update the case with Non-Stop Status
        c.Status = 'New';
        update c;

        Case updatedCase = [select Time_With_Customer__c,Time_With_Support__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];
        System.assert(updatedCase.Time_With_Customer__c!=null);
        System.assert(updatedCase.Time_With_Support__c!=null);
        System.assert(updatedCase.Case_Age_In_Business_Hours__c==null);

        //Update Case with Closed Status
        c.Status = 'Closed';
        update c;

        updatedCase = [select Time_With_Customer__c,Time_With_Support__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];
        System.assert(updatedCase.Time_With_Customer__c!=null);
        System.assert(updatedCase.Time_With_Support__c!=null);
        System.assert(updatedCase.Case_Age_In_Business_Hours__c!=null);
    }
    
    public static testMethod void testSLATimesOnInsert() {
    
        //Setup default business hours
        BusinessHours bh = [Select Id, TimeZoneSidKey, SundayStartTime, SundayEndTime, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime From BusinessHours Where IsDefault = TRUE];

        //Setup test user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'beamtu', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Chicago', UserName='beamsuntorytestuser@test-user-system.com.test-only');
        
        //Define the next business day (Monday)
        caseServices.testDay = '1';
        
        System.runAs(u) {
            
            //Insert a case
            Case c = new Case();
            c.Status = 'New';
            c.Last_Status_Change__c = System.Now();
            c.RecordTypeId = caseRTId;
            insert c;
                        
            Case case_test = [select CaseNumber, CreatedDate, SLA_Start_Time__c, SLA_End_Time__c from Case where Id=:c.Id];
            System.assert(case_Test.SLA_Start_Time__c!=null);
            System.assert(case_Test.SLA_End_Time__c!=null);
                      
        }
    }
    
    public static testMethod void testInsertUpdateWeekly_Monday() {
        
        //Setup the stop statuses
        Stop_Status__c ss = new Stop_Status__c(Name = 'On Hold');
        insert ss;
        
        //Define the next business day (Tuesday)
        caseServices.testDay = '1';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Status = 'On Hold';    
        c.Update_SLA_Times__c = TRUE;
        update c;
        
        c.Status = 'Closed';    
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testInsertUpdateWeekly_Tuesday() {
               
        //Define the next business day (Tuesday)
        caseServices.testDay = '2';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testInsertUpdateWeekly_Wednesday() {
               
        //Define the next business day (Tuesday)
        caseServices.testDay = '3';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testInsertUpdateWeekly_Thursday() {
       
        //Define the next business day (Tuesday)
        caseServices.testDay = '4';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testInsertUpdateWeekly_Friday() {
               
        //Define the next business day (Tuesday)
        caseServices.testDay = '5';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testInsertUpdateWeekly_Saturday() {
               
        //Define the next business day (Tuesday)
        caseServices.testDay = '6';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testInsertUpdateWeekly_Sunday() {
               
        //Define the next business day (Tuesday)
        caseServices.testDay = '7';
           
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        insert c;
            
        c.Update_SLA_Times__c = TRUE;
        update c;
    }
    
    public static testMethod void testCaseEmailSuppliedEmail() {
                          
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        c.SuppliedEmail = 'test@testmailer.com';
        insert c;
           
    }
    
    public static testMethod void testCaseEmailNoContact() {
           
     Profile p0 = [SELECT Id FROM Profile WHERE Name=:Admin_Profile];
     UserRole r = [SELECT Id FROM UserRole WHERE Name=:Admin_Role];
     User u0 = new User(Alias = 'beamtu2', Email='standarduser2@testorg.com',
     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
     LocaleSidKey='en_US', ProfileId = p0.Id, UserRoleId = r.Id,
     TimeZoneSidKey='America/Chicago', UserName='beamsuntorytestuser2@test-user-system.com.test-only');   
     insert u0;   
           
     System.runAs(u0) {
        Account a = new Account();
        a.RecordTypeId = accountRTId;
        a.Name = 'Test Account';
        insert a;  
        
        system.debug('Account Owner: '+a.OwnerId);
               
        Contact con = new Contact();
        con.LastName = 'Tester';
        con.AccountId = a.Id;
        insert con;
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:Vendor_Community_Profile];
        User u = new User(Alias = 'beamtu', ContactId=con.Id, Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Chicago', UserName='beamsuntorytestuser@test-user-system.com.test-only');
        insert u;
                          
        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        c.RecordTypeId = caseRTId;
        c.ContactId = con.Id;
        c.SuppliedEmail = null;
        insert c;
        
        system.debug('Contact Id: '+c.ContactId);
        system.debug('Supplied Email: '+c.SuppliedEmail);
        
      }
           
    }
    
    public static testMethod void testCaseLanguageNoContact() {

           
     Profile p0 = [SELECT Id FROM Profile WHERE Name=:Admin_Profile];
     UserRole r = [SELECT Id FROM UserRole WHERE Name=:Admin_Role];
     User u0 = new User(Alias = 'beamtu2', Email='standarduser2@testorg.com',
     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
     LocaleSidKey='en_US', ProfileId = p0.Id, UserRoleId = r.Id,
     TimeZoneSidKey='America/Chicago', UserName='beamsuntorytestuser2@test-user-system.com.test-only');   
     insert u0;   
        

        
           
     System.runAs(u0) {
	 	Case c = new Case();
     	c.Status = 'New';
     	insert c;
     }
    }
 
    
}