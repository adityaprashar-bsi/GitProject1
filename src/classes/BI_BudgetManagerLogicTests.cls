@isTest
private class BI_BudgetManagerLogicTests {
        
    static testmethod void testCreateTagData() {
        List<Tags__c> testTags = [SELECT Id, Name FROM Tags__c];
        System.assertEquals(testTags.size(), 0, 'No Mock Tags should exist yet.');  
        
        //Create Tags, assert they were created.
        TestDataFactory.createTags();
        
        testTags = [SELECT Id, Name FROM Tags__c];
        System.assertEquals(testTags.size(), 151, 'Mock Tags were not created successfully.'); 
    }
    
    static testmethod void testCreateTestHierarchyData() {      
            
        List<MarketingPlan__c> testPlans = [SELECT Id, Name FROM MarketingPlan__c];
        System.assertEquals(testPlans.size(), 0, 'No Marketing Plans should exist yet.');
        
        //Create marketing plans
        TestDataFactory.createMarketingPlanHierarchy();
        
        testPlans = [SELECT Name, Id, ParentMarketingPlan__c, Year__c, Brand__c, Country__c, Region__c, Division__c, Territory__c, Budget__c FROM MarketingPlan__c];
            
        System.assertEquals(testPlans.size(), 31, 'There should be 31 mock Marketing Plans.');          
    } 
    
    static testmethod void testSingleDuplicateMarketingPlan() {      
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        //Get the MP Record Types
        Map<String, ID> mpTypes = BI_UtilityLogic.getRecordTypeNamesByIds( 
            BI_Constants.OBJECT_MARKETINGPLAN, 
            new List<String> { BI_Constants.RECORDTYPE_MP_CAMPAIGNPROHIBITED }); 
        
        try {                       
            //Duplicate of 2015 top-level MP
            //Should cause an exception to be thrown, based on a Unique concatenated field in SF.           
                
            MarketingPlan__c newPlan = TestDataFactory.MapMarketingPlan('2015 $10M','2015',null,null,null,null,null,null,10000000, mpTypes.get(BI_Constants.RECORDTYPE_MP_CAMPAIGNPROHIBITED));
            insert newPlan;
            System.debug(LoggingLevel.INFO,'NewPlan.Id=' + newPlan.Id);
            System.assert(false, 'Single duplicate MarketingPlan should not have been created.');           
        }  
        catch (Exception e) {
            //If caught exception, ensure it is the Duplicate message.
            System.debug(LoggingLevel.INFO,'Exception: ' + e.getMessage());
            System.assert(true);
            //Boolean expectedExceptionThrown = e.getMessage().contains(BI_Constants.DUPLICATE_PLAN) ? true : false;
            //System.assertEquals(expectedExceptionThrown, true);           
        }   
    }
    
    
    static testmethod void testMultipleDuplicateMarketingPlan() {        
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        //Get the MP Record Types
        Map<String, ID> mpTypes = BI_UtilityLogic.getRecordTypeNamesByIds( 
            BI_Constants.OBJECT_MARKETINGPLAN, 
            new List<String> { BI_Constants.RECORDTYPE_MP_CAMPAIGNPROHIBITED });
            
        try {                       
            //Duplicate of 2015 top-level MP
            //Should cause an exception to be thrown.
            MarketingPlan__c plan1 = TestDataFactory.MapMarketingPlan('2016 $10M','2016',null,null,null,null,null,null,10000000,mpTypes.get(BI_Constants.RECORDTYPE_MP_CAMPAIGNPROHIBITED));
            MarketingPlan__c plan2 = TestDataFactory.MapMarketingPlan('2016 $10M','2016',null,null,null,null,null,null,10000000,mpTypes.get(BI_Constants.RECORDTYPE_MP_CAMPAIGNPROHIBITED));
            MarketingPlan__c plan3 = TestDataFactory.MapMarketingPlan('2016 $10M','2016',null,null,null,null,null,null,10000000,mpTypes.get(BI_Constants.RECORDTYPE_MP_CAMPAIGNPROHIBITED));
            List<MarketingPlan__c> newPlans = new List<MarketingPlan__c>();
            newPlans.Add(plan1);
            newPlans.Add(plan2);
            newPlans.Add(plan3);
            
            insert newPlans;
            
            System.assert(false, 'Multiple duplicate INSERTed MarketingPlans should not have been created.');    
            
        }  
        catch (Exception e) {
            //If caught exception, ensure it is the Duplicate message.
            System.debug(LoggingLevel.INFO,'Exception: ' + e.getMessage());
            System.assert(true);
            //Boolean expectedExceptionThrown = e.getMessage().contains(BI_Constants.DUPLICATE_PLAN) ? true : false;
            //System.assertEquals(expectedExceptionThrown, true);           
        }   
    }
    
    static testmethod void testUpdatingSingleMarketingPlan() {
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        
        Test.StartTest();
        
        //Get the plans we'll be working with.
        List<String> planNames = new List<String>();
        planNames.add('2015 US JBW American AMR SDP Heritage $30K');
        planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        
        Map<String, MarketingPlan__c> plansToUpdate = TestDataFactory.retrieveMarketingPlansByName(planNames);
        System.assertEquals(2, plansToUpdate.size(), 'Did not retrieve the desired 6 plans.');
        
        MarketingPlan__c parent = plansToUpdate.get('2015 US JBW American AMR SDP Heritage $30K');
        MarketingPlan__c child = plansToUpdate.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        
        //Initial AllocatedBudget was $25K, assert.
        System.assertEquals(25000, parent.AllocatedBudget__c, 'AllocatedBudget incorrect for plan (2015 US JBW American AMR SDP Heritage $30K). Expected $25K - got ' + parent.AllocatedBudget__c);
        
        //Update the child by 3K, so parent AllocatedBudget should equal 28K
        
        try {
            child.Budget__c += 3000;
            child.Comments__c = 'test comments';
            update child;
            System.assert(true, 'Should have successfully updated 1 plan with an additional $3K dollars.'); 
            
            //Re-retrieve the plans and assure the Allocated Budget amount is accurate.
            plansToUpdate.clear();
            plansToUpdate = TestDataFactory.retrieveMarketingPlansByName(planNames);
            parent = plansToUpdate.get('2015 US JBW American AMR SDP Heritage $30K');
            child = plansToUpdate.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
            
            //New AllocatedBudget should be $28K.
            System.assertEquals(28000, parent.AllocatedBudget__c, 'AllocatedBudget incorrect for plan ' + parent.Name);
            
            //NEGATIVE TESTING - try to add another 3K, which SHOULD FAIL because we only have 2K left of slush funds.
            try {
                child.Budget__c += 3000;
                child.Comments__c = 'test comments';
                update child;
                System.assert(false, 'Should have failed updating 1 plan with an additional $3K dollars, for a total of $31K.');    
            } catch (Exception eIn) {
                System.assert(true, 'Should have failed updating 1 plan with an additional $3K dollars, for a total of $31K.'); 
            }           
            
        } catch (Exception eOut) {
            System.assert(false, 'Should not have received an exception adding $3K to the 1 plan.');    
        }
        
        Test.StopTest();
    }   
        
    static testmethod void testUpdatingMultipleMarketingPlanLevels() {
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        
        //Get the plans we'll be updating
        List<String> planNames = new List<String>();
        planNames.add('2015 $10M');
        planNames.add('2015 US $7M');
        planNames.add('2015 US JBW $1M');
        planNames.add('2015 US JBW American $100K');
        planNames.add('2015 US JBW American AMR SDP Heritage $30K');
        planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        
        Map<String, MarketingPlan__c> plansToUpdate = TestDataFactory.retrieveMarketingPlansByName(planNames);
        System.assertEquals(6, plansToUpdate.size(), 'Did not retrieve the desired 6 plans.');          
        
        Test.StartTest();
        
        //Test - his test will simulate adding $10 Million USD to the above marketing plans (an entire branch). 
        //This should succeed.      
        for (MarketingPlan__c plan : plansToUpdate.values()) {
            plan.Budget__c = plan.Budget__c + 10000000.00;  
            plan.Comments__c = 'test comments';
        }
        try {
            update plansToUpdate.values();
            System.assert(true, 'Should have successfully updated all 6 plans with an additional $10M dollars.');
            
            //Re-retrieve the plans and assure the Allocated Budget amount is accurate.
            Map<String, MarketingPlan__c> updatedPlans = TestDataFactory.retrieveMarketingPlansByName(planNames);
            
            for (MarketingPlan__c p : updatedPlans.values()) {
                
                if (p.Name == '2015 $10M') {
                    //Initial AllocatedBudget was $9M, so should be $19M now.
                    System.assertEquals(19000000, p.AllocatedBudget__c, 'AllocatedBudget incorrect for plan (2015 $10M). Expected $19M - got ' + p.AllocatedBudget__c);
                } else if (p.Name == '2015 US $7M') {
                    //Initial AllocatedBudget was $1M, so should be $11M now.
                    System.assertEquals(11000000, p.AllocatedBudget__c, 'AllocatedBudget incorrect for plan (2015 US $7M). Expected $11M - got ' + p.AllocatedBudget__c);
                } else if (p.Name == '2015 US JBW $1M') {
                    //Initial AllocatedBudget was $900K, so should be $10.9M now.
                    System.assertEquals(10900000, p.AllocatedBudget__c, 'AllocatedBudget incorrect for plan (2015 US JBW $1M). Expected $10.9M - got ' + p.AllocatedBudget__c);
                } else if (p.Name == '2015 US JBW American $100K') {
                    //Initial AllocatedBudget was $80K, so should be $10.08M now.
                    System.assertEquals(10080000, p.AllocatedBudget__c, 'AllocatedBudget incorrect for plan (2015 US JBW American $100K). Expected $10.08M - got ' + p.AllocatedBudget__c);
                } else if (p.Name == '2015 US JBW American AMR SDP Heritage $30K') {
                    //Initial AllocatedBudget was $25K, so should be $10.025M now.
                    System.assertEquals(10025000, p.AllocatedBudget__c, 'AllocatedBudget incorrect for plan (2015 US JBW American AMR SDP Heritage $30K). Expected $10.025M - got ' + p.AllocatedBudget__c);
                }   
            }                       
        }
        catch (Exception e)     {
            System.assert(false, 'Should not have received an exception adding $10M to each of the 6 plans.');
        }   
        
        Test.StopTest();
    }
    
    static testmethod void testDeleteAndUndeleteMarketingPlans() {
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        
        //Get the plans we'll be working with.
        List<String> planNames = new List<String>();
        planNames.add('2015 US JBW American AMR SDP Heritage $30K');
        planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        planNames.add('2015 US JBW American AMR SDP Heritage Kansas $5K');
        planNames.add('2015 US JBW American AMR SDP Heritage Louisana $15K');
            
        Map<String, MarketingPlan__c> plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
        System.assertEquals(4, plans.size(), 'Did not retrieve the desired 4 plans.');          
        
        Test.StartTest();
        
        List<MarketingPlan__c> undeleteKids = new List<MarketingPlan__c>();
        undeleteKids.add(plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K'));
        undeleteKids.add(plans.get('2015 US JBW American AMR SDP Heritage Kansas $5K'));
        undeleteKids.add(plans.get('2015 US JBW American AMR SDP Heritage Louisana $15K')); 
        
        MarketingPlan__c parent = plans.get('2015 US JBW American AMR SDP Heritage $30K');
        MarketingPlan__c childToDelete = plans.get('2015 US JBW American AMR SDP Heritage Kansas $5K');
        
        System.assertEquals(25000, parent.AllocatedBudget__c, 'Parent plan expected to have 25K AllocatedBudget to start with.');
                
        try {       
                
            //Single Delete
            delete childToDelete;
            System.assert(true, 'Should have successfully deleted a single child Marketing Plan.');
            
            //Re-retrieve the plans and assure the Allocated Budget amount is accurate.
            plans.clear();
            plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
            System.assertEquals(3, plans.size(), 'Did not retrieve the desired 4-1=3 plans.');
            parent = plans.get('2015 US JBW American AMR SDP Heritage $30K');
            
            //After deleting a 5K child, Allocated should = 20K
            System.assertEquals(20000, parent.AllocatedBudget__c, 'AllocatedBudget incorrect for plan ' + parent.Name);
            
            List<MarketingPlan__c> otherKidsToDelete = new List<MarketingPlan__c>();
            otherKidsToDelete.add(plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K'));
            otherKidsToDelete.add(plans.get('2015 US JBW American AMR SDP Heritage Louisana $15K'));
            
            //Multiple delete
            delete otherKidsToDelete;
            
            //Re-retrieve the plans and assure the Allocated Budget amount is accurate.
            plans.clear();
            plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
            System.assertEquals(1, plans.size(), 'Did not retrieve the desired 4-3=1 plan.');
            parent = plans.get('2015 US JBW American AMR SDP Heritage $30K');
                        
            //After deleting all kids, Allocated should = 0
            System.assertEquals(0, parent.AllocatedBudget__c, 'AllocatedBudget incorrect for plan ' + parent.Name);
            
            //Undelete
            undelete undeleteKids;
            
            //Re-retrieve the plans and assure the Allocated Budget amount is accurate.
            plans.clear();
            plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
            System.assertEquals(4, plans.size(), 'Undeleted plans were not found.');
            parent = plans.get('2015 US JBW American AMR SDP Heritage $30K');
                        
            //After undeleting all kids, Allocated should equal the original 25K.
            System.assertEquals(25000, parent.AllocatedBudget__c, 'AllocatedBudget incorrect for plan ' + parent.Name);
                                    
        }
        catch (Exception e)     {
            System.assert(false, 'Should not have received an exception deleting/undeleting single or multiple Marketing Plans.');
        }   
        
        Test.StopTest();
    }
    
    static testmethod void testReparentMarketingPlans() {
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        
        //Get the plans we'll be updating
        List<String> planNames = new List<String>();
        planNames.add('2015 US JBW American AMR SDP Heritage $30K');
        planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        planNames.add('2015 US JBW American AMR SDP Heritage Kansas $5K');
        planNames.add('2015 US JBW American AMR SDP Heritage Louisana $15K');
        planNames.add('2015 US JBW American AMR SDP Legacy $50K');
        planNames.add('2015 US JBW American AMR SDP Legacy Massachusetts $20K');
        planNames.add('2015 US JBW American AMR SDP Legacy Missouri $20K');
        planNames.add('2015 US JBW American AMR SDP Legacy New Jersey $8K');
        
        Map<String, MarketingPlan__c> plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
        System.assertEquals(8, plans.size(), 'Did not retrieve the desired 8 plans.');          
        
        Test.StartTest();
        
        //Initial $25K
        MarketingPlan__c parentHeritage = plans.get('2015 US JBW American AMR SDP Heritage $30K');
        //Initial $48K
        MarketingPlan__c parentLegacy = plans.get('2015 US JBW American AMR SDP Legacy $50K');
        //Child to reparent
        MarketingPlan__c childArkansas = plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        
        //First, try to reparent when we know the destination parent won't have enough funds. Should bomb out.
        try {           
            childArkansas.ParentMarketingPlan__c = parentLegacy.Id;
            update childArkansas;
            System.assert(false, 'Reparenting plan should have bombed due to destination parent not having enough funds.');
        } catch (Exception e1) {
            System.assert(true, 'Reparenting plan should have bombed due to destination parent not having enough funds.');
        }
        
        //Clear values
        plans.clear();
        plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
        //Initial $25K
        parentHeritage = plans.get('2015 US JBW American AMR SDP Heritage $30K');
        //Initial $48K
        parentLegacy = plans.get('2015 US JBW American AMR SDP Legacy $50K');
        //Child to reparent
        childArkansas = plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
                
        //Second, reduce the amount of funds on child so it can be reparented. SHould succeed.
        try {           
            childArkansas.Budget__c = 1000;
            childArkansas.Comments__c = 'test comments';
            update childArkansas;
            System.assert(true, 'Should have reduced Arkansas to $1K');
        } catch (Exception e2) {
            System.assert(false, 'Should have reduced Arkansas to $1K');
        }
        
        //Clear values
        plans.clear();
        plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
        //Initial $21K
        parentHeritage = plans.get('2015 US JBW American AMR SDP Heritage $30K');
        //Initial $48K
        parentLegacy = plans.get('2015 US JBW American AMR SDP Legacy $50K');
        //Child to reparent
        childArkansas = plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        
        //Lastly, reparent the child from Heritage to Legacy.
        try {           
            childArkansas.ParentMarketingPlan__c = parentLegacy.Id;
            update childArkansas;
            System.assert(true, 'Should have reparented Arkansas to Legacy division.');         
        } catch (Exception e3) {
            System.assert(false, 'Should have reparented Arkansas to Legacy division.');
        }
        
        //Clear values and make final assertions
        plans.clear();
        plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
        //After reparenting: $20K
        parentHeritage = plans.get('2015 US JBW American AMR SDP Heritage $30K');
        //After reparenting: $49K
        parentLegacy = plans.get('2015 US JBW American AMR SDP Legacy $50K');       
        System.assertEquals(20000, parentHeritage.AllocatedBudget__c, 'AllocatedBudget not accurate on source parent: ' + parentHeritage.Name);
        System.assertEquals(49000, parentLegacy.AllocatedBudget__c, 'AllocatedBudget not accurate on destination parent: ' + parentLegacy.Name);      
        
        Test.StopTest();
    } 
    
    static testmethod void testAutoCreateCampaignForecasts() {       
        
        //Create test data
        TestDataFactory.createMarketingPlanHierarchy();
        Map<String, ID> tagsMap = TestDataFactory.GetTagsMap();
        
        //Get the Marketing Plan(s) that we'll be adding child Campaigns under.
        List<String> planNames = new List<String>();
        planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K'); 
        planNames.add('2015 US JBW American AMR SDP Heritage Louisana $15K'); 
        planNames.add('2015 US JBW American AMR SDP Legacy Missouri $20K');     
        
        Map<String, MarketingPlan__c> plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
        MarketingPlan__c plan1 = plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
        MarketingPlan__c plan2 = plans.get('2015 US JBW American AMR SDP Heritage Louisana $15K');
        MarketingPlan__c plan3 = plans.get('2015 US JBW American AMR SDP Legacy Missouri $20K');
        
        Map<Id, Map<Date, Campaign_Spend__c>> campaignForecasts = new Map<Id, Map<Date, Campaign_Spend__c>>();
                
        try {               
            
            Test.StartTest();
                    
            //TEST 1: Create a single Campaign with same Start/End date month (1 forecast should be created, with $3000)
            Campaign__c camp1 = TestDataFactory.MapCampaign(plan1.Id, 3000.00, date.newinstance(2015, 1, 5), date.newinstance(2015, 1, 27), 'USD', tagsMap.get('BQ_Jim Beam White'));
            
            try {
                insert camp1;
            } catch (Exception e1) {
                System.assert(false, 'Exception in TEST 1: ' + e1.getMessage());
            }
            
            
            campaignForecasts.clear();
            campaignForecasts = retrieveForecastsByParentCampaignIds(new List<Id>{camp1.Id});
            //Assure we found the 1 campaign.
            System.assertEquals(1, campaignForecasts.size(), 'Should only find one Campaign.');
            //Assure that campaign has only 1 forecast
            System.assertEquals(1, campaignForecasts.get(camp1.Id).size(), 'Should only find one Forecast');
            //Assure the forecast data is accurate: ForecastDate,Amount,ParentCampaignId,Currency.
            System.assertEquals(date.newinstance(2015, 1, 1), campaignForecasts.get(camp1.Id).get(date.newinstance(2015, 1, 1)).Forecast_Month_Date__c);
            System.assertEquals(3000.00, campaignForecasts.get(camp1.Id).get(date.newinstance(2015, 1, 1)).Amount__c);
            System.assertEquals(camp1.Id, campaignForecasts.get(camp1.Id).get(date.newinstance(2015, 1, 1)).ParentCampaign__c);
            System.assertEquals('USD', campaignForecasts.get(camp1.Id).get(date.newinstance(2015, 1, 1)).CurrencyIsoCode);
            
            
            //TEST 2: Create a single Campaign with Start=Feb and End=April (3 forecasts should be created)
            camp1 = TestDataFactory.MapCampaign(plan2.Id, 1000.00, date.newinstance(2015, 2, 5), date.newinstance(2015, 4, 27), 'MXN', tagsMap.get('BQ_Jim Beam White'));
            
            try {
                insert camp1;
            } catch (Exception e2) {
                System.assert(false, 'Exception in TEST 2: ' + e2.getMessage());
            }
            
            campaignForecasts.clear();
            campaignForecasts = retrieveForecastsByParentCampaignIds(new List<Id>{camp1.Id});
            //Assure we found the 1 campaign.
            System.assertEquals(1, campaignForecasts.size(), 'Should only find one Campaign.');
            //Assure that campaign has only 3 forecasts
            System.assertEquals(3, campaignForecasts.get(camp1.Id).size());
                        
            for (Integer i = 2; i <= 4; i++) {
                //Assure the forecast data is accurate: ForecastDate,Amount,ParentCampaignId,Currency.
                //1000 / 3 = 333.33 (so the last month should be 333.34 to represent the remainder.)
                System.assertEquals(date.newinstance(2015, i, 1), campaignForecasts.get(camp1.Id).get(date.newinstance(2015, i, 1)).Forecast_Month_Date__c);                            
                System.assertEquals(camp1.Id, campaignForecasts.get(camp1.Id).get(date.newinstance(2015, i, 1)).ParentCampaign__c);
                System.assertEquals('MXN', campaignForecasts.get(camp1.Id).get(date.newinstance(2015, i, 1)).CurrencyIsoCode);
                if(i != 4) {
                    System.assertEquals(333.33, campaignForecasts.get(camp1.Id).get(date.newinstance(2015, i, 1)).Amount__c);
                } else {
                    System.assertEquals(333.34, campaignForecasts.get(camp1.Id).get(date.newinstance(2015, i, 1)).Amount__c);
                }           
            }
                                                                                    
            //TEST 4: Create 200 Campaigns - $100 each, with January through December (12 forecasts - each of $8.33, one of $8.34)
            System.debug(LoggingLevel.INFO,'Starting TEST 4');
            List<Campaign__c> bulkCampaigns = new List<Campaign__c>();
            for (integer i = 1; i <= 200; i++) {
                bulkCampaigns.add(TestDataFactory.MapCampaign(plan3.Id, 100.00, date.newinstance(2015, 1, 5), date.newinstance(2015, 12, 27), 'USD', tagsMap.get('BQ_Jim Beam White')));
            }           
            
            try {
                System.debug(LoggingLevel.INFO,'Campaigns inserting: ' + bulkCampaigns.size());
                insert bulkCampaigns;
                System.debug(LoggingLevel.INFO,'Campaigns inserted: ' + bulkCampaigns.size());
            } catch (Exception e4) {
                System.debug(LoggingLevel.INFO,'Exception inserting: ' + e4.getMessage());
                System.assert(false, 'Exception in TEST 4: ' + e4.getMessage());
            }       
            
            List<Id> campaignIds = new List<Id>();
            for (Campaign__c c : bulkCampaigns) {
                System.debug(LoggingLevel.INFO,'CampaignID: ' + c.Id);
                campaignIds.add(c.Id);
            }   
            
            //System.debug(LoggingLevel.INFO,campaignIds);
            
            campaignForecasts.clear();
            campaignForecasts = retrieveForecastsByParentCampaignIds(campaignIds);
            //Assure we found the 200 campaigns.
            System.assertEquals(200, campaignForecasts.size(), 'Should find 200 campaigns.');
            
            //Assure there are 200 * 12 = 2400 total forecasts created.
            List<Campaign_Spend__c> bulkForecasts = [SELECT Name, Id, ParentCampaign__c, Forecast_Month_Date__c, Amount__c, CurrencyIsoCode, RecordTypeId 
                FROM Campaign_Spend__c 
                WHERE ParentCampaign__c IN :campaignIds];
            //System.assertEquals(2400, bulkForecasts.size(), 'There should be 2400 Forecasts when 200 Campaigns are created Jan-Dec');
            System.assertEquals(2400, bulkForecasts.size(), 'There should be 2400 Forecasts when 200 Campaigns are created Jan-Dec');
                    
            
            Test.StopTest();
                
        }  
        catch (Exception e) {
            //If caught exception, ensure it is the Duplicate message.
            System.debug(LoggingLevel.INFO,'Exception: ' + e.getMessage());
            System.assert(false, 'There was an issue with the testAutoCreateCampaignForecasts method.');        
        }   
    }
    
    static Map<Id, Map<Date, Campaign_Spend__c>> retrieveForecastsByParentCampaignIds(List<Id> campaignIds) {
        
        //Campaign Map containing each child Forecast by date.      
        Map<Id, Map<Date, Campaign_Spend__c>> campaignForecasts = new Map<Id, Map<Date, Campaign_Spend__c>>();
        ID forecastRecordTypeId = BI_UtilityLogic.getRecordTypeId(BI_Constants.OBJECT_CAMPAIGNSPEND, 
            BI_Constants.RECORDTYPE_CAMPAIGNSPEND_FORECAST);
            
        for(Campaign_Spend__c f : [SELECT Name, Id, ParentCampaign__c, Forecast_Month_Date__c, Amount__c, CurrencyIsoCode, RecordTypeId 
            FROM Campaign_Spend__c 
            WHERE RecordTypeId = :forecastRecordTypeId AND ParentCampaign__c IN :campaignIds])
        {
            if(campaignForecasts.get(f.ParentCampaign__c) == null)
            {
                campaignForecasts.put(f.ParentCampaign__c, new Map<Date, Campaign_Spend__c>{f.Forecast_Month_Date__c => f});
            }
            else
            {
                campaignForecasts.get(f.ParentCampaign__c).put(f.Forecast_Month_Date__c, f);
            }
        }   
        System.debug(LoggingLevel.INFO,'Forecast Map: ' + campaignForecasts);
        return campaignForecasts;
    }  
}