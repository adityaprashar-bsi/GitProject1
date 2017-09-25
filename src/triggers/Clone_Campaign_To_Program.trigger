trigger Clone_Campaign_To_Program on Campaign__c (after insert, after update) {
   
    if(!Test.isRunningTest())
   { 
    List<Campaign__c> campaignsToClone = new List<Campaign__c>(); 
    List<Id>  marketingPlanIds = new List<Id>();
    List<Id> brandIds = new List<Id>();
    Map<Id,Id> brandQualityMap = new Map<Id,Id>();
    List<Program__c> programsToInsert = new List<Program__c>();
    List<Program__c> programsToUpdate = new List<Program__c>();

    
    //Fetching the record typeId for new programs to create
    Id programRecordTypeId = [SELECT Id FROM RecordType Where DeveloperName='Brand_Investment_Programs' AND SObjectType='Program__c'].Id;
    
    //Fetching CampaignToProgramTranspose__c settings values
    Map<String,CampaignToProgramTranspose__c> campaignToProgramMap = CampaignToProgramTranspose__c.getAll();
    
    Map<String,CampaignToProgramTranspose__c> programTransposeMap = new Map<String,CampaignToProgramTranspose__c>();
    
    //Preparing CampaignToProgramTranspose__c settings map with GL_Descreption as key
    for(CampaignToProgramTranspose__c c : campaignToProgramMap.values()){
        programTransposeMap.put(c.GL_Description__c,c);
    }
    
    //Preparing list of campaigns which needs to be cloned
    for(Campaign__c c : trigger.new){
        if(trigger.isUpdate){
            system.debug(trigger.oldMap.get(c.Id).Mirrored_Program__c+'from trigger mirror program'+ c.Mirrored_Program__c);
        }    
        if(trigger.isInsert || (trigger.isUpdate && c.Mirrored_Program__c==trigger.oldMap.get(c.Id).Mirrored_Program__c)){
            if((c.Region__c != 'National Accounts Region' && c.Region__c != 'Canada' && c.Region__c != 'Mexico') && (c.Territory__c !='NA Off-Premise' && c.Territory__c !='NA On-Premise')){
                campaignsToClone.add(c);
                if(c.ParentMarketingPlan__c!=null ){
                    //preparing parent marketing id list to query marketing plan
                    marketingPlanIds.add(c.ParentMarketingPlan__c);
                }
                if(c.Brand_Quality__c!=null){
                    //preparing Brand_Quality__c id list to query tag
                    brandIds.add(c.Brand_Quality__c);
                }
            }
        }
    }
    
    //Querying tags for getting PL4_Brand__c value
    Map<Id,Tags__c> qualityMap = new Map<Id,Tags__c>([SELECT Id,PL4_Brand__c FROM Tags__c WHERE Id IN:brandIds]);
   //system.debug('##qualityMap'+qualityMap);

    //Querying marketing plans for getting owner and territory
    Map<Id,MarketingPlan__c> marketingPlanMap = new Map<Id,MarketingPlan__c>([SELECT Id,OwnerId,Territory__c FROM MarketingPlan__c WHERE Id IN:marketingPlanIds]);
    

    
    //Preparing the program records for insert or update
    for(Campaign__c c : campaignsToClone){      
        Program__c p = new Program__c();

        system.debug('@@qualityMap.get(c.Brand_Quality__c).PL4_Brand__c'+qualityMap.get(c.Brand_Quality__c).PL4_Brand__c+'@qualityMap.get(c.Brand_Quality__c).PL4_Brand__c'+qualityMap.get(c.Brand_Quality__c));
        if(qualityMap.get(c.Brand_Quality__c)!=null){
            p.Brand__c = qualityMap.get(c.Brand_Quality__c).PL4_Brand__c;
        }
        
        p.BrandQuality__c = c.Brand_Quality__c;
        p.SpendDescription__c = c.GLDescription__c;
        p.ProgrammingType__c = (programTransposeMap.get(c.GLDescription__c) == null) ? null : programTransposeMap.get(c.GLDescription__c).ProgrammingType__c;
        p.ProgramFocus__c = (programTransposeMap.get(c.GLDescription__c) == null) ? null : programTransposeMap.get(c.GLDescription__c).ProgramFocus__c;
        p.Channel__c = (programTransposeMap.get(c.GLDescription__c) == null) ? null : programTransposeMap.get(c.GLDescription__c).ChannelType__c;
        system.debug('@@programTransposeMap.get(c.GLDescription__c).ChannelType__c'+programTransposeMap.get(c.GLDescription__c));
        
        p.Budget__c = c.PlannedCampaignSpend__c;
        p.Name = c.Name;
        p.Distributor__c = c.Distributor__c;
        p.EndDate__c = c.InitialEndDate__c;
        p.IOCode__c = c.IOCode__c;
        if(c.ParentMarketingPlan__c!=null){
            p.OwnerId = marketingPlanMap.get(c.ParentMarketingPlan__c).OwnerId;     
        }
        p.RecordtypeId = programRecordTypeId ;
        p.Funds__c = 'BI';
        p.Parent__c = c.Related_Priority__c;        
        p.StartDate__c = c.InitialStartDate__c;
        if(c.ParentMarketingPlan__c!=null){
            p.Territory__c = marketingPlanMap.get(c.ParentMarketingPlan__c).Territory__c;
        }
        p.SourceBICampaign__c = c.Id;
        
        //p.NationalAccount__c = c.NationalAccount__c;      //to be used later
        
        if(c.Mirrored_Program__c==null){    // if Mirrored_Program__c not populated then program will be inserted else will be updated
            programsToInsert.add(p);
        }
        else{
            p.Id = c.Mirrored_Program__c;
            programsToUpdate.add(p);
        }
    }
    
    //inserting program for campaign clone
    if(programsToInsert.size()>0){
        system.debug('inside trigger insert');
        insert programsToInsert;
    }
    
    //updating cloned program
    if(programsToUpdate.size()>0){
        system.debug('inside trigger update');
        update programsToUpdate;
    }
    
}
}