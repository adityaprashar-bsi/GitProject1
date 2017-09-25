public with sharing class CampaignMultiRecordEditor extends PageControllerBase {
    public Boolean MyAllowCreateIO {get; set;}
    public Boolean MyAllowAdd {get; set;}
    public Boolean MyAllowEdit {get; set;}
    public Boolean MyAllowDelete {get; set;}  
      
    public String MysObj {get; set;}
    public String MyRecId {get; set;}
    public String MyRelationField {get; set;}    
    public list<String> MyFieldList {get; set;}
    public list<String> MySearchFieldList {get; set;}
    public list<String> MyLabelOverrideFieldList {get; set;}
    public list<String> MyLabelOverrideTextList {get; set;}
    public list<String> MyDefaultValueFieldList {get; set;}
    public list<String> MyDefaultValueTextList {get; set;}
    
    public String MyBlockTitle {get; set;}
    public ApexPages.StandardController standardController {get; set; }
 
    public CampaignMultiRecordEditor(ApexPages.StandardController stdController) {
        this.standardController = stdController;
        Id recordId = this.standardController.getId();
        MyAllowAdd = true;
        MyAllowEdit = true;
        MyAllowDelete = false;
        
        //For Create IO Button
        MyAllowCreateIO = true;
        
        MyBlockTitle = 'Edit Campaigns';
        MysObj = 'Campaign__c';
        MyRecId = '' + recordId; 
        MyRelationField = 'ParentMarketingPlan__c';
        MyFieldList = new list<String> {'IOCode__c',
                                        'Name',
                                        'Brand_Quality__c',
                                        'PlannedCampaignSpend__c',
                                        'ActualCampaignSpend__c',
                                        'CommittedCampaignSpend__c',
                                        'CampaignBalance__c',                                                                                
                                        'Comments__c',
                                        'InitialStartDate__c',
                                        'InitialEndDate__c',
                                        //'CampaignBrand__c',
                                        'CampaignType__c',
                                        'GLAccountType__c',
                                        'GLDescription__c',
                                        'GLCode__c',
                                        'Description__c'
                                         };        
                                      
         
        MySearchFieldList = new list<String> {  'Name',
                                                'IOCode__c',                                                                
                                                'CampaignType__c',
                                                'GLAccountType__c',
                                                'GLDescription__c'};
        MyLabelOverrideFieldList = new list<String> {   'CampaignBrand__c',
                                                        'PlannedCampaignSpend__c',
                                                        'CampaignBalance__c',
                                                        'ActualCampaignSpend__c',
                                                        'CommittedCampaignSpend__c' };
        MyLabelOverrideTextList = new list<String> {    'Brand',
                                                        'Budget',
                                                        'Balance',
                                                        'Actual',
                                                        'Committed',
                                                        'Description' };
        
         String defaultCampaignBrand = [SELECT Brand__r.CampaignBrand__c
            FROM MarketingPlan__c 
            WHERE Id = :recordId].Brand__r.CampaignBrand__c;
        System.debug(LoggingLevel.INFO,'Default CampaignBrand: ' + defaultCampaignBrand);
            
            //'CampaignBrand__c', 'Strategy__c', 'Objective__c', 'CampaignType__c', 'GLAccountType__c', 'GLCode__c'
        MyDefaultValueFieldList = new list<String> { 'CampaignBrand__c' };
        MyDefaultValueTextList = new list<String> { defaultCampaignBrand };
    }
        
    public override void RefreshPage() {
        //Without Test.isRunningTest(), this lines errors because of the following sObject error:
        //System.SObjectException: You cannot call reset when the data is being passed into the controller by the caller.
        if (!Test.isRunningTest()) {
            this.standardController.reset();    
        } 
    }
}