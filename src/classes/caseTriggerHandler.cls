/************************************************************************************** 
 Apex Class Name     : caseTriggerHandler
 Created Date        : 1/2016
 Function            : Handles events from the caseTrigger trigger
*************************************************************************************/

public class caseTriggerHandler {

  /**************************************************************************************************************
  Method name:    handleAfterInsert
  Object:         Case
  Event:          after insert
  Date:           1/2016
  Details and Notes: Handles all after insert triggers
  ***************************************************************************************************************/

  public static void handleBeforeInsert(List<Case> cases){
    caseServices.calculateBusinessHoursAgesOnInsert(cases);
  }

  public static void handleBeforeUpdate(List<Case> cases, Map<Id, Case> oldCases){
    caseServices.calculateBusinessHoursAgesOnUpdate(cases, oldCases);
  }
  
  public static void handleAfterInsert(List<Case> cases){
    caseServices.caseSetSubmitterEmail(cases);
    caseServices.caseSetLanguage(cases);
  }
}