/************************************************************************************** 
 Apex Class Name     : caseServices
 Created Date        : 1/2016
 Function            : Methods called from the caseTriggerhandler handlers
*************************************************************************************/

public class caseServices {

    public static string testDay;
    
  /**************************************************************************************************************
  Method name:    calculateBusinessHoursAgesOnInsert
  Object:         Case
  Date:           1/2016
  Details and Notes:
  Modification of the Case Age in Business Hours app from Salesforce Labs; calculates Start and End Times
  on Case Creation
  ***************************************************************************************************************/

    public static void calculateBusinessHoursAgesOnInsert(List<Case> cases){ 
    
        //Pull the default business hours
        BusinessHours bh = [Select Id, TimeZoneSidKey, SundayStartTime, SundayEndTime, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime From BusinessHours Where IsDefault = TRUE];
        Time BHStartTime;
        Time BHEndTime;
        
        for (Case updatedCase:cases) {
            updatedCase.Time_With_Customer__c = 0;
            updatedCase.Time_With_Support__c = 0;
            
            //Pull the timezone for the organization
            Timezone tz = Timezone.getTimeZone(bh.TimeZoneSidKey);
            
            //Pull the timezone for the current user
            String uTzId = UserInfo.getTimeZone().getID();
            Timezone tzU = Timezone.getTimeZone(uTzId);

            //Calculate the offset between organization's timezone and GMT
            Integer Offset = tz.getOffset(system.now());
            //Calculate the offset between current user's timezone and GMT
            Integer OffsetU = tzU.getOffset(system.now());
                
            //Calculate the offset between organization's and current user's timezones
            //Take ABS(A)-ABS(B); IF NEGATIVE, add the absolute value to formatted time; if POSITIVE, add the value (multiplied by -1)
            Integer tzDiff = math.abs(Offset/3600000)-math.abs(OffsetU/3600000);
            if(tzDiff < 1){
                tzDiff = math.abs(tzDiff);
            }else{
                tzDiff = tzDiff*-1;
            }         

            //Get next business day
            DateTime todaysDateGMT = system.now();
            DateTime nextStartDateGMT = BusinessHours.nextStartDate(bh.Id, todaysDateGMT);
            DateTime nextStartDate = nextStartDateGMT.addHours(Offset/3600000);
            
            string day;
         
            if(Test.isRunningTest()){
                day = testDay;
            }else{
                day = ((nextStartDateGMT).addHours(tzDiff)).format('u');
            }
            
            //Pull the business hours for the next business day
            if(day == '1'){
                BHStartTime = bh.MondayStartTime;
                BHEndTime = bh.MondayEndTime;
            }else if(day == '2'){
                BHStartTime = bh.TuesdayStartTime;
                BHEndTime = bh.TuesdayEndTime;
            }else if(day == '3'){
                BHStartTime = bh.WednesdayStartTime;
                BHEndTime = bh.WednesdayEndTime;
            }else if(day == '4'){
                BHStartTime = bh.ThursdayStartTime;
                BHEndTime = bh.ThursdayEndTime;
            }else if(day == '5'){
                BHStartTime = bh.FridayStartTime;
                BHEndTime = bh.FridayEndTime;
            }else if(day == '6'){
                BHStartTime = bh.SaturdayStartTime;
                BHEndTime = bh.SaturdayEndTime;
            }else{
                BHStartTime = bh.SundayStartTime;
                BHEndTime = bh.SundayEndTime;
            }
            
            if(BHStartTime != null && BHEndTime != null){
                
                //Build SLA Start and End Times in GMT
                DateTime SLAStartTime = DateTime.newInstanceGMT(nextStartDateGMT.year(), nextStartDateGMT.month(), nextStartDateGMT.day(), BHStartTime.hour(), BHStartTime.minute(), 0);
                DateTime SLAEndTime = DateTime.newInstanceGMT(nextStartDateGMT.year(), nextStartDateGMT.month(), nextStartDateGMT.day(), BHEndTime.hour(), BHEndTime.minute(), 0);

                //Build SLA Start and End Times in organization's default timezone
                DateTime SLAStartTimeGMT = SLAStartTime.addHours(math.abs(Offset/3600000));
                DateTime SLAEndTimeGMT = SLAEndTime.addHours(math.abs(Offset/3600000));

                //Set the Case's SLA Start and End Times
                updatedCase.SLA_Start_Time__c = SLAStartTimeGMT;
                updatedCase.SLA_End_Time__c = SLAEndTimeGMT;
                
                if(system.now() < SLAStartTimeGMT){
                    updatedCase.Last_Status_Change__c = SLAStartTimeGMT;
                }else{
                    updatedCase.Last_Status_Change__c = system.now();
                }
            }
        } 
    }

  /**************************************************************************************************************
  Method name:    calculateBusinessHoursAgesOnUpdate
  Object:         Case
  Date:           1/2016
  Details and Notes:
  Modification of the Case Age in Business Hours app from Salesforce Labs; calculates Start and End Times
  on Case Update (end of business day); update SLA clocks on status update.
  ***************************************************************************************************************/

   public static void calculateBusinessHoursAgesOnUpdate(List<Case> cases, Map<Id, Case> oldCases){

        //Get the stop statuses
        Set<String> stopStatusSet = new Set<String>();
        for (Stop_Status__c stopStatus:[Select Name From Stop_Status__c]) {
            stopStatusSet.add(stopStatus.Name);
        }

        //Get the default business hours
        BusinessHours defaultHours = [select Id from BusinessHours where IsDefault=true];

        //Get the closed statuses
        Set<String> closedStatusSet = new Set<String>();
        for (CaseStatus status:[Select MasterLabel From CaseStatus where IsClosed=true]) {
            closedStatusSet.add(status.MasterLabel);
        }

        //At close of business each night, update the case with the next business day's SLA Start and End Times
        for (Case updatedCase:cases) {
            
            Case oldCase = oldCases.get(updatedCase.Id);

            //Is it the end of the business day?
            if (updatedCase.Update_SLA_Times__c == TRUE) {
                
                //Is the case still open?
                if (!oldCase.IsClosed) {

                    //On the off-chance that the business hours on the case are null, use the default ones instead
                    Id hoursToUse = updatedCase.BusinessHoursId!=null?updatedCase.BusinessHoursId:defaultHours.Id;

                    if(updatedCase.SLA_Start_Time__c!=null && updatedCase.SLA_End_Time__c!=null){

                        //Find the time in business hours between last status change and tonight's close of business
                        Double timeSinceLastStatus = BusinessHours.diff(hoursToUse, updatedCase.Last_Status_Change__c, updatedCase.SLA_End_Time__c)/3600000.0;
                    
                        //We decide which clock to add the time to depending on current case status
                        if (stopStatusSet.contains(oldCase.Status)) {
                            updatedCase.Time_With_Customer__c += timeSinceLastStatus;
                        } else {
                            updatedCase.Time_With_Support__c += timeSinceLastStatus;
                        }
                    
                        if (closedStatusSet.contains(updatedCase.Status)) {
                            updatedCase.Case_Age_In_Business_Hours__c = updatedCase.Time_With_Customer__c + updatedCase.Time_With_Support__c;
                        }
                    }
                }
                   
                //Pull the default business hours
                BusinessHours bh = [Select Id, TimeZoneSidKey, SundayStartTime, SundayEndTime, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime From BusinessHours Where IsDefault = TRUE];
                Time BHStartTime;
                Time BHEndTime;
                
                //Pull the timezone for the organization
                Timezone tz = Timezone.getTimeZone(bh.TimeZoneSidKey);
            
                //Pull the timezone for the current user
                String uTzId = UserInfo.getTimeZone().getID();
                Timezone tzU = Timezone.getTimeZone(uTzId);

                //Calculate the offset between organization's timezone and GMT
                Integer Offset = tz.getOffset(system.now());
                //Calculate the offset between current user's timezone and GMT
                Integer OffsetU = tzU.getOffset(system.now());
                
                //Calculate the offset between organization's and current user's timezones
                //Take ABS(A)-ABS(B); IF NEGATIVE, add the absolute value to formatted time; if POSITIVE, add the value (multiplied by -1)
                Integer tzDiff = math.abs(Offset/3600000)-math.abs(OffsetU/3600000);
                if(tzDiff < 1){
                  tzDiff = math.abs(tzDiff);
                }else{
                  tzDiff = tzDiff*-1;
                }         

                //Get next business day
                DateTime todaysDateGMT = system.now();
                DateTime nextStartDateGMT = BusinessHours.nextStartDate(bh.Id, todaysDateGMT);
                DateTime nextStartDate = nextStartDateGMT.addHours(Offset/3600000);

                string day;
         
                if(Test.isRunningTest()){
                    day = testDay;
                }else{
                    day = ((nextStartDateGMT).addHours(tzDiff)).format('u');
                }

                //Pull the business hours for the next business day
                if(day == '1'){
                    BHStartTime = bh.MondayStartTime;
                    BHEndTime = bh.MondayEndTime;
                }else if(day == '2'){
                    BHStartTime = bh.TuesdayStartTime;
                    BHEndTime = bh.TuesdayEndTime;
                }else if(day == '3'){
                    BHStartTime = bh.WednesdayStartTime;
                    BHEndTime = bh.WednesdayEndTime;
                }else if(day == '4'){
                    BHStartTime = bh.ThursdayStartTime;
                    BHEndTime = bh.ThursdayEndTime;
                }else if(day == '5'){
                    BHStartTime = bh.FridayStartTime;
                    BHEndTime = bh.FridayEndTime;
                }else if(day == '6'){
                    BHStartTime = bh.SaturdayStartTime;
                    BHEndTime = bh.SaturdayEndTime;
                }else{
                    BHStartTime = bh.SundayStartTime;
                    BHEndTime = bh.SundayEndTime;
                }

                if(BHStartTime != null && BHEndTime != null){

                    //Build SLA Start and End Times in GMT
                    DateTime SLAStartTime = DateTime.newInstanceGMT(nextStartDateGMT.year(), nextStartDateGMT.month(), nextStartDateGMT.day(), BHStartTime.hour(), BHStartTime.minute(), 0);
                    DateTime SLAEndTime = DateTime.newInstanceGMT(nextStartDateGMT.year(), nextStartDateGMT.month(), nextStartDateGMT.day(), BHEndTime.hour(), BHEndTime.minute(), 0);

                    //Build SLA Start and End Times in organization's default timezone
                    DateTime SLAStartTimeGMT = SLAStartTime.addHours(math.abs(Offset/3600000));
                    DateTime SLAEndTimeGMT = SLAEndTime.addHours(math.abs(Offset/3600000));

                    //Set the Case's SLA Start and End Times
                    updatedCase.SLA_Start_Time__c = SLAStartTimeGMT;
                    updatedCase.SLA_End_Time__c = SLAEndTimeGMT;
                    
                    //Set the Case's Last Status Change to the next business day's start time
                    updatedCase.Last_Status_Change__c = SLAStartTimeGMT;
                }
            }
        }
                
        //Whenever there is a status change, update the Case's SLA clocks
        for (Case updatedCase:cases) {
            Case oldCase = oldCases.get(updatedCase.Id);

            if (oldCase.Status!=updatedCase.Status && updatedCase.Last_Status_Change__c!=null) {
                if (!oldCase.IsClosed) {

                    //On the off-chance that the business hours on the case are null, use the default ones instead
                    Id hoursToUse = updatedCase.BusinessHoursId!=null?updatedCase.BusinessHoursId:defaultHours.Id;

                    //Find the time in business hours between last status change and tonight's close of business
                    Double timeSinceLastStatus = BusinessHours.diff(hoursToUse, updatedCase.Last_Status_Change__c, System.now())/3600000.0;
                                       
                    //We decide which clock to add the time to depending on current case status
                    if (stopStatusSet.contains(oldCase.Status)) {
                        updatedCase.Time_With_Customer__c += timeSinceLastStatus;
                    } else {
                        updatedCase.Time_With_Support__c += timeSinceLastStatus;
                    }

                    if (closedStatusSet.contains(updatedCase.Status)) {
                        updatedCase.Case_Age_In_Business_Hours__c = updatedCase.Time_With_Customer__c + updatedCase.Time_With_Support__c;
                    }
                }
                
                //Set the Case's Last Status Change Date to right now (the time of status change)
                if(system.now() >= updatedCase.SLA_Start_Time__c && system.now() <= updatedCase.SLA_End_Time__c){
                    updatedCase.Last_Status_Change__c = system.now();
                }
            }        
        }  
    }
    
  /**************************************************************************************************************
  Method name:    caseSetSubmitterEmail
  Object:         Case
  Date:           4/2016
  Details and Notes:
  Sets the Case submitter's email to which workflow notifications should be delivered.
  ***************************************************************************************************************/ 
  
   public static void caseSetSubmitterEmail(List<Case> cases) {
        
        List<Case> currentCases = [select id, contactId, createdBy.Email, SuppliedEmail, Automated_Notification_Email__c from Case where id In :cases];
        List<User> currentUsers = [select id,contactId, Email from User where contactId != null];
        List<Case> casesToUpdate = new List<Case>();
        
        for(Case c : currentCases) {
            if(c.SuppliedEmail != null) {
                c.Automated_Notification_Email__c = c.SuppliedEmail;
                casesToUpdate.add(c);
            }
            else if(c.contactId == null) {
                c.Automated_Notification_Email__c = c.createdBy.Email;
                casesToUpdate.add(c); 
            }
            else{
                for(User u : currentUsers) {
                    if(c.ContactId == u.ContactId){
                        c.Automated_Notification_Email__c = u.Email;
                        casesToUpdate.add(c);
                    }  
                }
            }       
        }
        
        update casesToUpdate;
    }
    
  /**************************************************************************************************************
  Method name:    caseSetLanguage
  Object:         Case
  Date:           4/2016
  Details and Notes:
  Sets the language for the Case, used for email notifications.
  ***************************************************************************************************************/ 
    
    public static void caseSetLanguage(List<Case> cases) {
        List<Case> currentCases = [select id,contactId,createdBy.LanguageLocaleKey from Case where id In :cases];
        List<User> currentUsers = [select id,contactId, LanguageLocaleKey from User where contactId != null];
        List<Case> casesToUpdate = new List<Case>();
        for(Case a : currentCases) {
                if(a.contactId == null) {
                    a.Case_Language__c = a.createdBy.LanguageLocaleKey;
                    casesToUpdate.add(a); 
                }
                else{
                    for(User u : currentUsers) {
                        if(a.ContactId == u.ContactId){
                            a.Case_Language__c = u.LanguageLocaleKey;
                            casesToUpdate.add(a);
                        }  
                    }
                }
                  
        }
        
        update casesToUpdate;
    }

}