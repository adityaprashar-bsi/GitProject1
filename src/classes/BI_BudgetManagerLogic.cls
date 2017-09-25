public without sharing class BI_BudgetManagerLogic {

	/**
	* @description		: Handles before insert logic for Marketing Plans, namely converting 'Budget__c' to USD
	* @param triggerNew	: List of newly inserted Marketing Plans
	*/
	public static void handleMarketingPlanBeforeInsert(List<MarketingPlan__c> triggerNew){
        //Always calculate the budget for all marketing plans before insert
		System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleMarketingPlanBeforeInsert');
		CurrencyConversionUtility.ConversionConfiguration cfg = 
			new CurrencyConversionUtility.ConversionConfiguration('Budget__c', 'Year__c', 'Budget_USD_Hidden__c', 'MarketingPlan__c');
		//CurrencyConversionUtility.ConversionConfiguration cfg2 = 
		//	new CurrencyConversionUtility.ConversionConfiguration('AllocatedBudget__c', 'Year__c', 'AllocatedBudget_USD_Hidden__c', 'MarketingPlan__c');
		CurrencyConversionUtility.convertCurrencyTrigger(cfg, triggerNew, true);
		//CurrencyConversionUtility.convertCurrencyTrigger(cfg2, triggerNew, true);
	}

	public static void handleMarketingPlanBeforeUpdate(Map<Id, MarketingPlan__c> triggerOldMap, 
		Map<Id, MarketingPlan__c> triggerNewMap){
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleMarketingPlanBeforeUpdate');
		CurrencyConversionUtility.ConversionConfiguration cfg = 
			new CurrencyConversionUtility.ConversionConfiguration('Budget__c', 'Year__c', 'Budget_USD_Hidden__c', 'MarketingPlan__c');
		CurrencyConversionUtility.ConversionConfiguration cfg2 =
			new CurrencyConversionUtility.ConversionConfiguration('CampaignBudgetHidden__c', 'Year__c', 'CampaignBudgetNativeHidden__c', 'MarketingPlan__c');
		//CurrencyConversionUtility.ConversionConfiguration cfg3 = 
		//	new CurrencyConversionUtility.ConversionConfiguration('AllocatedBudget__c', 'Year__c', 'AllocatedBudget_USD_Hidden__c', 'MarketingPlan__c');
		List<MarketingPlan__c> changedBudgetMarketingPlans = new List<MarketingPlan__c>();
		List<MarketingPlan__c> changedCampaignBudgetMarketingPlans = new List<MarketingPlan__c>();
		//Compile list of applicable marketing plans where:
		//The budget was changed in the update or
		//The calculated budget was manually changed for some reason
		for(Id mpId: triggerNewMap.keySet()){
			if((triggerNewMap.get(mpId).Budget__c != triggerOldMap.get(mpId).Budget__c) ||
				(triggerNewMap.get(mpId).Budget_USD_Hidden__c != triggerOldMap.get(mpId).Budget_USD_Hidden__c) ||
				//(triggerNewMap.get(mpId).AllocatedBudget_USD_Hidden__c != triggerOldMap.get(mpId).AllocatedBudget_USD_Hidden__c) ||
				(triggerNewMap.get(mpId).CurrencyIsoCode != triggerOldMap.get(mpId).CurrencyIsoCode)){
				changedBudgetMarketingPlans.add(triggerNewMap.get(mpId));
			}
			//If the Campaign Budget rollup changes, it must be recalculated
			if(triggerNewMap.get(mpId).CampaignBudgetHidden__c != triggerOldMap.get(mpId).CampaignBudgetHidden__c){
				changedCampaignBudgetMarketingPlans.add(triggerNewMap.get(mpId));
			}
		}
		//Only calculate applicable marketing plans
		CurrencyConversionUtility.convertCurrencyTrigger(cfg, changedBudgetMarketingPlans, true);
		CurrencyConversionUtility.convertCurrencyTrigger(cfg2, changedCampaignBudgetMarketingPlans, false);
		//CurrencyConversionUtility.convertCurrencyTrigger(cfg3, changedBudgetMarketingPlans, true);
	}
		
	public static void handleMarketingPlanAfterInsert(List<MarketingPlan__c> triggerNew) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleMarketingPlanAfterInsert');
  		
  		//Insert event - ALWAYS calculate AllocatedBudget for the inserted records' Parents.
  		//Do Rollups
		rollupAllocatedBudget(triggerNew);  	
	}
	    
    public static void handleMarketingPlanAfterUpdate(List<MarketingPlan__c> triggerNew, 
    	Map<ID, MarketingPlan__c> triggerNewMap, 
    	List<MarketingPlan__c> triggerOld, 
    	Map<ID, MarketingPlan__c> triggerOldMap) {
    		        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleMarketingPlanAfterUpdate');
		
		List<MarketingPlan__c> childrenToProcess = new List<MarketingPlan__c>();
		List<Audit_Log__c> budgetAuditLogs = new List<Audit_Log__c>();
		
		for(ID planId : triggerNewMap.keySet() )
		{
			//Update event - CONDITIONALLY calculate AllocatedBudget for the updated records' Parents, ONLY IF Budget changed on a child.
  			if(triggerOldMap.get(planId).Budget__c != triggerNewMap.get(planId).Budget__c)
  			{
  				System.debug(LoggingLevel.INFO,'Budget has changed on MarketingPlan: ' + planId);
  				
  				MarketingPlan__c oldPlan = triggerOldMap.get(planId);
  				MarketingPlan__c newPlan = triggerNewMap.get(planId);  				
  				
     			childrenToProcess.add(newPlan);
     			
     			//Logic for creating a Budget Audit Log.
     			//Comments__c
     			//Budget_Changed_From_Transfer__c
     			System.debug(LoggingLevel.INFO,'Old Budget changed: ' + oldPlan.Budget_Changed_From_Transfer__c );
     			System.debug(LoggingLevel.INFO,'New Budget changed: ' + newPlan.Budget_Changed_From_Transfer__c);
     			if (!newPlan.Budget_Changed_From_Transfer__c) {
     				    				     				
     				//Create the Audit Log.		
					Audit_Log__c theLog = BI_BudgetTransferLogic.createBudgetAuditLog(oldPlan.Budget__c, newPlan.Budget__c, newPlan.Comments__c, newPlan.CurrencyIsoCode);
					theLog.Related_Marketing_Plan__c = planId;
					budgetAuditLogs.add(theLog);   					
     			}
  			}  	
  			
  			//Update event - CONDITIONALLY calculate AllocatedBudget for the OLD and NEW version of the updated records' Parents, ONLY IF ParentMarketingPlan__c changed on a child.
  			if(triggerOldMap.get(planId).ParentMarketingPlan__c != triggerNewMap.get(planId).ParentMarketingPlan__c)
  			{
  				System.debug(LoggingLevel.INFO,'ParentMarketingPlan has changed on MarketingPlan: ' + planId);
     			childrenToProcess.add(triggerOldMap.get(planId));
     			childrenToProcess.add(triggerNewMap.get(planId));
  			}		
		}
		
		if (!childrenToProcess.isEmpty()) {			
			//Do Rollups
			rollupAllocatedBudget(childrenToProcess);			
		}		 
		
		if(!budgetAuditLogs.isEmpty()) {
			insert budgetAuditLogs;
		}
    }
    
    public static void handleMarketingPlanAfterDelete(List<MarketingPlan__c> triggerOld) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleMarketingPlanAfterDelete');              
		//Delete event - ALWAYS calculate AllocatedBudget for the deleted records' Parents, but using Trigger.old     
		//Do Rollups
		rollupAllocatedBudget(triggerOld);     
    }
    
    public static void handleMarketingPlanAfterUndelete(List<MarketingPlan__c> triggerNew) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleMarketingPlanAfterUndelete');        
        //Undelete event - ALWAYS calculate AllocatedBudget for the undeleted records' Parents. Same as insert.
   	    //Do Rollups
		rollupAllocatedBudget(triggerNew);		            
    }
    
    public static void handleCampaignAfterInsert(List<Campaign__c> triggerNew) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleCampaignAfterInsert');
  		
  		//Auto-create Forecast records based on Start/End Date
		insertCampaignForecasts(triggerNew);  	
	}
	
	public static void handleCampaignAfterUpdate(List<Campaign__c> triggerNew, 
    	Map<ID, Campaign__c> triggerNewMap, 
    	List<Campaign__c> triggerOld, 
    	Map<ID, Campaign__c> triggerOldMap) { 
    		       
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleCampaignAfterUpdate');
  		List<Audit_Log__c> budgetAuditLogs = new List<Audit_Log__c>();
  		
  		//If Campaign Budget changed, create an Audit record.
  		for(ID campaignId : triggerNewMap.keySet())
		{
			//Update event - if Budget changed on Campaign
  			if(triggerOldMap.get(campaignId).PlannedCampaignSpend__c != triggerNewMap.get(campaignId).PlannedCampaignSpend__c)
  			{
  				System.debug(LoggingLevel.INFO,'Budget has changed on Campaign: ' + campaignId);
  				
  				Campaign__c oldCampaign = triggerOldMap.get(campaignId);
  				Campaign__c newCampaign = triggerNewMap.get(campaignId);  				
  				    					
 				//Create the Audit Log.		
				Audit_Log__c theLog = BI_BudgetTransferLogic.createBudgetAuditLog(oldCampaign.PlannedCampaignSpend__c, newCampaign.PlannedCampaignSpend__c, newCampaign.Comments__c, newCampaign.CurrencyIsoCode);
				theLog.Related_Campaign_Record__c = campaignId;
				budgetAuditLogs.add(theLog);   					
     			
  			}  		
		}		
		if(!budgetAuditLogs.isEmpty()) {
			insert budgetAuditLogs;
		}  			
	}
	
	public static void handleCampaignBeforeInsert(List<Campaign__c> triggerNew) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleCampaignBeforeInsert');
  		//Pre-populate picklist "Campaign Brand" based on Campaign's parent MP's "Brand" Tag lookup
		prePopulateCampaignFields(triggerNew);

		CurrencyConversionUtility.ConversionConfiguration cfg = 
			new CurrencyConversionUtility.ConversionConfiguration('PlannedCampaignSpend__c', 'Year__c', 'PlannedCampaignSpend_USD_Hidden__c', 'Campaign__c');
		CurrencyConversionUtility.convertCurrencyTrigger(cfg, triggerNew, true);
	}

	public static void handleCampaignBeforeUpdate(Map<Id, Campaign__c> triggerOldMap, Map<Id, Campaign__c> triggerNewMap){
		CurrencyConversionUtility.ConversionConfiguration cfg = 
			new CurrencyConversionUtility.ConversionConfiguration('PlannedCampaignSpend__c', 'Year__c', 'PlannedCampaignSpend_USD_Hidden__c', 'Campaign__c');
		List<Campaign__c> changedCampaigns = new List<Campaign__c>();
		//Compile list of applicable campaigns where:
		//The budget was changed in the update or
		//The calculated budget was manually changed for some reason
		for(Id cId: triggerNewMap.keySet()){
			if((triggerNewMap.get(cId).PlannedCampaignSpend__c != triggerOldMap.get(cId).PlannedCampaignSpend__c) ||
				(triggerNewMap.get(cId).PlannedCampaignSpend_USD_Hidden__c != triggerOldMap.get(cId).PlannedCampaignSpend_USD_Hidden__c) ||
				(triggerNewMap.get(cId).CurrencyIsoCode != triggerOldMap.get(cId).CurrencyIsoCode)){
				changedCampaigns.add(triggerNewMap.get(cId));	
			}
		}
		//Only calculate applicable marketing plans
		CurrencyConversionUtility.convertCurrencyTrigger(cfg, changedCampaigns, true);
	}

	public static void handleCampaignSpendBeforeInsert(List<Campaign_Spend__c> triggerNew) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleCampaignSpendBeforeInsert');
		CurrencyConversionUtility.ConversionConfiguration cfg = 
			new CurrencyConversionUtility.ConversionConfiguration('Amount__c', 'Posting_Date__c', 'Amount_USD__c', 'Campaign_Spend__c');
		CurrencyConversionUtility.ConversionConfiguration cfg2 = 
			new CurrencyConversionUtility.ConversionConfiguration('Amount__c', 'Forecast_Month_Date__c', 'Amount_USD__c', 'Campaign_Spend__c');
		List<Campaign_Spend__c> nonForecastCampaignSpends = new List<Campaign_Spend__c>();
		List<Campaign_Spend__c> forecastCampaignSpends = new List<Campaign_Spend__c>();
		for(Campaign_Spend__c cs: triggerNew){
			if(cs.RecordTypeId == Schema.SObjectType.Campaign_Spend__c.getRecordTypeInfosByName().get(BI_Constants.RECORDTYPE_CAMPAIGNSPEND_FORECAST).getRecordTypeId()){
				forecastCampaignSpends.add(cs);
			} else {
				nonForecastCampaignSpends.add(cs);
			}
		}
		CurrencyConversionUtility.convertCurrencyTrigger(cfg, nonForecastCampaignSpends, true);
		CurrencyConversionUtility.convertCurrencyTrigger(cfg2, forecastCampaignSpends, true);
	}

	public static void handleCampaignSpendBeforeUpdate(Map<Id, Campaign_Spend__c> triggerOldMap, Map<Id, Campaign_Spend__c> triggerNewMap) {        
        System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.handleCampaignSpendBeforeUpdate');
		CurrencyConversionUtility.ConversionConfiguration cfg = 
			new CurrencyConversionUtility.ConversionConfiguration('Amount__c', 'Posting_Date__c', 'Amount_USD__c', 'Campaign_Spend__c');
		CurrencyConversionUtility.ConversionConfiguration cfg2 = 
			new CurrencyConversionUtility.ConversionConfiguration('Amount__c', 'Forecast_Month_Date__c', 'Amount_USD__c', 'Campaign_Spend__c');
		List<Campaign_Spend__c> nonForecastCampaignSpends = new List<Campaign_Spend__c>();
		List<Campaign_Spend__c> forecastCampaignSpends = new List<Campaign_Spend__c>();
		//Compile list of applicable campaign spends where:
		//The amount was changed in the update or
		//The calculated amount was manually changed for some reason
		for(Id csId: triggerNewMap.keySet()){
			if((triggerNewMap.get(csId).Amount__c != triggerOldMap.get(csId).Amount__c) ||
				(triggerNewMap.get(csId).Amount_USD__c != triggerOldMap.get(csId).Amount_USD__c) ||
				(triggerNewMap.get(csId).CurrencyIsoCode != triggerOldMap.get(csId).CurrencyIsoCode)){
				if(triggerNewMap.get(csId).RecordTypeId == Schema.SObjectType.Campaign_Spend__c.getRecordTypeInfosByName().get(BI_Constants.RECORDTYPE_CAMPAIGNSPEND_FORECAST).getRecordTypeId()){
					forecastCampaignSpends.add(triggerNewMap.get(csId));
				} else {
					nonForecastCampaignSpends.add(triggerNewMap.get(csId));
				}
			}
		}
		//Only calculate applicable marketing plans
		CurrencyConversionUtility.convertCurrencyTrigger(cfg, nonForecastCampaignSpends, true);
		CurrencyConversionUtility.convertCurrencyTrigger(cfg2, forecastCampaignSpends, true);
	}

    private static void rollupAllocatedBudget(List<MarketingPlan__c> records) {
    	System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.rollupAllocatedBudget');
    	
    	try {
    		//Should we put a TryCatch around this?    	
	    	if (records != null && !records.isEmpty()) {
	    		  			   	
	    		list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<RollUpSummaryUtility.fieldDefinition> {
	            	new RollUpSummaryUtility.fieldDefinition('SUM', 'Budget_USD_Hidden__c', 'AllocatedBudget__c')
	        	};
	         
		        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, records, 
		        'MarketingPlan__c', 'ParentMarketingPlan__c', 'MarketingPlan__c', '', 'Year__c');    
	    	}
    	}
    	catch (Exception e) {
    		for (MarketingPlan__c plan : records) {
    			plan.addError(BI_Constants.PLAN_ALLOCATEDBUDGET_VIOLATION);	
    		}		
    	}    	    		
    }
    
    private static String getMonthString(Date theDate) {
    	if (theDate.month() == 1) {
    		return 'Jan';
    	} else if (theDate.month() == 2) {
    		return 'Feb';
    	} else if (theDate.month() == 3) {
    		return 'Mar';
    	} else if (theDate.month() == 4) {
    		return 'Apr';
    	} else if (theDate.month() == 5) {
    		return 'May';
    	} else if (theDate.month() == 6) {
    		return 'Jun';
    	} else if (theDate.month() == 7) {
    		return 'Jul';
    	} else if (theDate.month() == 8) {
    		return 'Aug';
    	} else if (theDate.month() == 9) {
    		return 'Sep';
    	} else if (theDate.month() == 10) {
    		return 'Oct';
    	} else if (theDate.month() == 11) {
    		return 'Nov';
    	} else if (theDate.month() == 12) {
    		return 'Dec';
    	} else {
    		return null;
    	}    	
    }
        
    public static void insertCampaignForecasts(List<Campaign__c> campaigns) {
		//List to hold all the Forecasts that will be inserted.
		List<Campaign_Spend__c> newForecasts = new List<Campaign_Spend__c>();
		
		//Get the Record Type ID for Forecasts
		ID forecastRecordTypeId = BI_UtilityLogic.getRecordTypeId(BI_Constants.OBJECT_CAMPAIGNSPEND, 
			BI_Constants.RECORDTYPE_CAMPAIGNSPEND_FORECAST);					
			
		//Iterate each campaign, calculate number of Forecast records for each.
		for (Campaign__c campaign : campaigns) {
			
			if (campaign.InitialStartDate__c != null && campaign.InitialEndDate__c != null && campaign.PlannedCampaignSpend__c != null) {
				Date startDate = campaign.InitialStartDate__c.toStartOfMonth();
				Date endDate = campaign.InitialEndDate__c.toStartOfMonth();
				
				//Determine how many months
				Integer countMonths = startDate.monthsBetween(endDate) + 1;
				if (countMonths <= 0) { countMonths = 1; }
				
				//Divide campaign by months, rounding down to 2 decimals. Remember the remainder.
				Decimal dividedAmount = campaign.PlannedCampaignSpend__c.divide(countMonths, 2, System.RoundingMode.DOWN); 			
				Decimal remainderForLastRecord = campaign.PlannedCampaignSpend__c - (countMonths * dividedAmount);											
								
				for (Date dt = startDate; dt <= endDate; dt = dt.addMonths(1)) {
					Campaign_Spend__c forecast = new Campaign_Spend__c();
					forecast.RecordTypeId = forecastRecordTypeId;				
					forecast.Forecast_Month__c = getMonthString(dt);
					forecast.CurrencyIsoCode = campaign.CurrencyIsoCode;
					
					//If this is the last forecasted month, add the remainder to the amount.
					if (dt.addMonths(1) > endDate) {
						forecast.Amount__c = dividedAmount + remainderForLastRecord; 	
					} else {
						forecast.Amount__c = dividedAmount;	
					}
					
					forecast.ParentCampaign__c = campaign.Id;
					newForecasts.add(forecast);				
				}
			}			
		}
		
		if (!newForecasts.isEmpty()) {
			//try
			//{
				insert newForecasts;				
			//}	
			//catch (Exception e) {
			//	System.debug(LoggingLevel.INFO,'Exception caught inserting Forecast records.' + e.getMessage());
				//Don't prevent Campaigns from being created, just ignore error.
			//}
		}	
    }    
    
    public static void prePopulateCampaignFields(List<Campaign__c> triggerNewCampaigns) {
		System.debug(LoggingLevel.INFO,'Entered BI_BudgetManagerLogic.prePopulateCampaignFields');
		
		//Unique set of parent MarketingPlan IDs
		Set<ID> parentPlanIds = new Set<ID>();
		//Map from MP ID to "CampaignBrand" picklist value
		Map<ID,String> campaignBrandValues = new Map<ID,String>();									
			
		//Iterate each campaign, add MP to set
		for (Campaign__c campaign : triggerNewCampaigns) {			
			if (campaign.ParentMarketingPlan__c != null) {				
				parentPlanIds.add(campaign.ParentMarketingPlan__c);
			}						
		}
		System.debug(LoggingLevel.INFO,'Parent MP Ids: ' + parentPlanIds);
		
		//Query MPs and retrieve the "campaign brand" lookup
		List<MarketingPlan__c> plans = [Select Id, Name, Brand__c, Brand__r.CampaignBrand__c 
			FROM MarketingPlan__c
			WHERE Id IN :parentPlanIds];
			
		//Map Plan ID to CampaignBrand__c value
		for (MarketingPlan__c p : plans) {
			if (p.Brand__r != null && p.Brand__r.CampaignBrand__c != null) {
				campaignBrandValues.put(p.Id, p.Brand__r.CampaignBrand__c);
			}			
		}
		System.debug(LoggingLevel.INFO,'Parent Plan Id to CampaignBrand mappings: ' + campaignBrandvalues);
		
		//Update all the Campaigns with the correct value.
		//NOTE: Assume that this method is called from BEFORE INSERT trigger and the
		// CampaignBrand__c value will pass-through to the platform save.
		for (Campaign__c c : triggerNewCampaigns) {
			String mappedValue = campaignBrandValues.get(c.ParentMarketingPlan__c);
			System.debug(LoggingLevel.INFO,'Mapped Value for ' + c.ParentMarketingPlan__c + ' is ' + mappedValue);
			if (mappedValue != null) {
				c.CampaignBrand__c = mappedValue;
			}
		}		
    }      
}