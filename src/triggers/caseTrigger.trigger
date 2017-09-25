/************************************************************************************** 
 Apex Class Name     : caseTrigger
 Created Date        : 1/2016
 Function            : calls method in caseTriggerHandler
*************************************************************************************/

trigger caseTrigger on Case (before insert, after insert, before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            caseTriggerHandler.handleBeforeInsert(Trigger.New);
        }else if(Trigger.isUpdate){
            caseTriggerHandler.handleBeforeUpdate(Trigger.New, Trigger.oldMap);
        }
    }
    else if (Trigger.isAfter ){
        if(Trigger.isInsert){
            caseTriggerHandler.handleAfterInsert(Trigger.New);
        
            List<Case> cases = new List<Case>();
            for (Case c : Trigger.new) {
                cases.add(new Case(id = c.id));
            }
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            Database.update(cases, dmo);
        }
    }
}