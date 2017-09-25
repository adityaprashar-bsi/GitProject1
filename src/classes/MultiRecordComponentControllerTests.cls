@isTest
private class MultiRecordComponentControllerTests {

	static testmethod void testMarketingPlanGrid() {
		
		//Create test data
    	TestDataFactory.createMarketingPlanHierarchy();
    	Map<String, ID> tagsMap = TestDataFactory.GetTagsMap();
    	
    	//2015 US JBW American AMR SDP Heritage $30K
		//  2015 US JBW American AMR SDP Heritage Arkansas $5K
		//  2015 US JBW American AMR SDP Heritage Kansas $5K
		//  2015 US JBW American AMR SDP Heritage Louisana $15K
		
		List<String> planNames = new List<String>();
		planNames.add('2015 US JBW American AMR SDP Heritage $30K');
    	planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K'); 
    	planNames.add('2015 US JBW American AMR SDP Heritage Kansas $5K'); 
    	planNames.add('2015 US JBW American AMR SDP Heritage Louisana $15K');
    	Map<String, MarketingPlan__c> plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
    	
    	MarketingPlan__c parentRec = plans.get('2015 US JBW American AMR SDP Heritage $30K');
    	ID parentId = parentRec.Id;
    	
		//Test the Page controller extension and the Component Controller.
    	MarketingPlanMultiRecordEditor pageCont = new MarketingPlanMultiRecordEditor(new ApexPages.StandardController(parentRec));
    	
    	//Simulate Component Attributes being set via binding to PageControllerExt properties.
    	MultiRecordComponentController cont = new MultiRecordComponentController();
    	cont.pageController = pageCont; 
    	pageCont.setComponentController(cont);
    	pageCont.RefreshPage();
    	    	
    	cont.sObjectType = pageCont.MysObj;    	
  		cont.ParentRecId = pageCont.MyRecId;
     	cont.RelationField = pageCont.MyRelationField;
     	cont.FieldList = pageCont.MyFieldList;
		cont.LabelOverrideFieldList = pageCont.MyLabelOverrideFieldList;
		cont.LabelOverrideTextList = pageCont.MyLabelOverrideTextList;
		cont.DefaultValueFieldList = pageCont.MyDefaultValueFieldList;
		cont.DefaultValueTextList = pageCont.MyDefaultValueTextList;
		cont.AllowAdd = pageCont.MyAllowAdd;
		cont.AllowEdit = pageCont.MyAllowEdit;
		cont.AllowDelete = pageCont.MyAllowDelete;
		cont.ShowCreateIOButton = false;
		cont.SearchFieldList = pageCont.MySearchFieldList;
		
		Test.startTest();
			
    	//Initiate the querying
    	List<MultiRecordComponentController.ColumnWrapper> tmpColumnList = cont.ColumnList;
    	List<MultiRecordComponentController.QueryWhereFilter> tmpFilterList = cont.FilterList;
    	List<MultiRecordComponentController.ObjectWrapper> tmpObjectList = cont.ObjectList;
    	
    	
    	system.assertEquals(3, tmpObjectList.size());
    	system.assertEquals(14, tmpColumnlist.size());
    	system.assertEquals(3, tmpFilterList.size());
    	system.assertEquals(true, cont.IsFilterable);
    	system.assertEquals(1, cont.TotalPages, 'Total Pages should be 1');
    	
    	//Test DoNext and DoPrevious, even though we expect them to do nothing because there's one page.
    	cont.DoPrevious();
    	system.assertEquals(3, tmpObjectList.size());
    	cont.DoNext();
    	system.assertEquals(3, tmpObjectList.size());
    	
    	//Test Toggle Filters
    	system.assertEquals(false, cont.FilterVisible, 'Filters should be hidden by default');
    	cont.DoFilterToggle();
    	system.assertEquals(true, cont.FilterVisible, 'Filters should be visible after toggle.');
    	cont.DoFilterToggle();
    	system.assertEquals(false, cont.FilterVisible, 'Filters should be hidden after second toggle.');
    	
    	//Test EDIT ALL
    	cont.ActionId = null;
    	cont.DoEditAll();
    	system.assertEquals(3, cont.ObjectList.size(), 'Should be 3 rows.');
    	for (MultiRecordComponentController.ObjectWrapper w : cont.ObjectList) {
    		system.assertEquals(true, w.IsEditMode, 'Every row should be in Edit Mode after DoEditAll()');
    	}
    	
    	//Test CANCEL
    	cont.DoCancel();
    	system.assertEquals(3, cont.ObjectList.size(), 'Should be back to 3 rows.');
    	for (MultiRecordComponentController.ObjectWrapper w : cont.ObjectList) {
    		system.assertEquals(false, w.IsEditMode, 'No rows should be in Edit mode after Cancel');
    	}
    	
    	//Test EDIT
    	cont.ActionId = null;
    	cont.DoEdit();
    	for (MultiRecordComponentController.ObjectWrapper w : cont.ObjectList) {
    		system.assertEquals(false, w.IsEditMode, 'No rows should be in Edit mode after DoEdit without an ActionId');
    	}
    	cont.ActionId = cont.ObjectList.get(1).obj.Id;
    	cont.DoEdit();
    	decimal tempBudget = (decimal)cont.ObjectList.get(1).obj.get('Budget__c') - 100.00;
    	cont.ObjectList.get(1).obj.put('Budget__c', tempBudget);
    	cont.ObjectList.get(1).obj.put('Comments__c', 'Test Comments'); 
    	system.assertEquals(true, cont.ObjectList.get(1).IsEditMode, 'Second row should be in Edit Mode.');
    	cont.DoSave();
    	system.assertEquals(tempBudget, cont.ObjectList.get(1).obj.get('Budget__c'));
    	  	
    	//Test ADD 
    	//ADDed rows get inserted above existing rows, but below other new rows. So the first
    	//2 added rows should be in index 0 and 1, respectively.
    	cont.DoAdd();
    	system.assertEquals(4, cont.ObjectList.size(), 'Should now be 4 rows.');
    	cont.DoAdd();
    	system.assertEquals(5, cont.ObjectList.size(), 'Should now be 5 rows.');
    	system.assertEquals('1', cont.ObjectList.get(0).AddedRowNumber);
    	system.assertEquals('2', cont.ObjectList.get(1).AddedRowNumber);   	
    	
    	//Test REMOVE
    	cont.ActionRowNumber = '1';
    	cont.DoRemove();
    	cont.ActionRowNumber = '2';
    	cont.DoRemove();
    	system.assertEquals(3, cont.ObjectList.size(), 'Should now be 3 rows after Removes.');  
    	
    	cont.DoAdd();
    	cont.DoCancel();
    	system.assertEquals(3, cont.ObjectList.size(), 'Should now be 3 rows after Removes.');  
    	  	
    	cont.DoAdd();
    	system.assertEquals(4, cont.ObjectList.size(), 'Should now be 4 rows.');
    	system.assertEquals(true, cont.ObjectList.get(0).IsEditMode, 'Added row should be in Edit mode in the first row index.');
    	cont.ObjectList.get(0).obj.put('Name', 'ZZZ TEST MP'); 	
    	cont.ObjectList.get(0).obj.put('ParentMarketingPlan__c',parentId);
    	cont.ObjectList.get(0).obj.put('Territory__c', tagsMap.get('Georgia'));
    	cont.ObjectList.get(0).obj.put('Year__c','2015');
    	cont.ObjectList.get(0).obj.put('Brand__c', cont.ObjectList.get(1).obj.get('Brand__c'));
    	cont.ObjectList.get(0).obj.put('Country__c', 'US');
    	cont.ObjectList.get(0).obj.put('Region__c', 'American');
    	cont.ObjectList.get(0).obj.put('Division__c', 'AMR SDP Heritage Division');    	
    	cont.ObjectList.get(0).obj.put('Budget__c', 0.0);
    	//cont.ObjectList.get(0).obj.put('RecordTypeId', cont.ObjectList.get(1).obj.get('RecordTypeId'));
    	
    	//Test SAVE ALL
    	cont.DoSave();
    	system.assertEquals(4, cont.ObjectList.size(), 'Should now be 4 fully saved MPs.');
    	for (MultiRecordComponentController.ObjectWrapper w : cont.ObjectList) {
    		system.assertEquals(false, w.IsEditMode, 'No rows should be in Edit mode after SaveAll');
    	}
    	
    	//Test SAVE that should fail. (Changing Budget without adding Comments should fail.)
    	cont.ActionId = cont.ObjectList.get(1).obj.Id;
    	cont.DoEdit();
    	cont.ObjectList.get(1).obj.put('Budget__c', 100000000000.0);
    	cont.DoSave();
    	system.assertEquals(4, cont.ObjectList.size());
    	//Make sure an Error message was added to the page.
    	List<Apexpages.Message> msgs = ApexPages.getMessages();
    	system.assert(msgs.size() > 0, 'Should have found an error message updating the Budget with no comments.');
    	
    	cont.DoCancel();
    	
    	//Test DELETE - none should delete when ActionId is null
    	cont.ActionId = null;
    	cont.DoDelete();
    	system.assertEquals(4, cont.ObjectList.size(), 'Should still be 4 records after a bad delete.');
    	for (MultiRecordComponentController.ObjectWrapper w : cont.ObjectList) {
    		
    		if (w.obj.get('Name') == 'ZZZ TEST MP') {
    			cont.ActionId = w.obj.Id;
    			break;	
    		}
    	}
    	cont.DoDelete();
    	system.assertEquals(3, cont.ObjectList.size(), 'Should be 3 records after a successful delete.');
    	
    	//Test Sorting
    	system.assertEquals('Name', cont.SortField, 'MarketingPlan should be initially sorted by Name');
    	system.assertEquals('asc', cont.SortDirection, 'asc should be initial sort direction.');    	
    	cont.SortToggle();
    	system.assertEquals('Name', cont.SortField, 'Should still be sorted by Name');
    	system.assertEquals('desc NULLS LAST', cont.SortDirection, 'Sort Direction should now be desc NULL LAST');
    	cont.SortField = 'Territory__c';
    	cont.SortToggle();
    	system.assertEquals('Territory__c', cont.SortField, 'Should now be sorted by Territory');
    	system.assertEquals('asc', cont.SortDirection, 'Sort Direction should now be reset to asc');
    	cont.SortField = 'Name';
    	cont.SortToggle();
    	system.assertEquals('Name', cont.SortField, 'Finally sorted back on Name.');
    	system.assertEquals('asc', cont.SortDirection, 'Sort Direction should be reset to asc');
    	
    	Test.stopTest();
    		
	}
	
	/*
	*********************************** TESTING CAMPAIGNS **************************************
	*/
	
	static testmethod void testCampaignGrid() {
		
		//Create test data
    	TestDataFactory.createMarketingPlanHierarchy();
    	Map<String, ID> tagsMap = TestDataFactory.GetTagsMap();
    	
		//  2015 US JBW American AMR SDP Heritage Arkansas $5K				
		List<String> planNames = new List<String>();
    	planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K'); 
    	Map<String, MarketingPlan__c> plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
    	
    	MarketingPlan__c parentRec = plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
    	parentRec.SAP_Controlling_Area__c = '2000';
    	parentRec.SAP_Company_Code__c = 'US30';
    	parentRec.SAP_Cost_Center__c = 'US30NA33';
    	update parentRec;
    	
    	ID parentId = parentRec.Id;
    	
    	//Create 100 test Campaigns
	 	List<Campaign__c> bulkCampaigns = new List<Campaign__c>();
 		for (Integer i = 1; i <= 200; i++) {
 			Campaign__c theTempCamp = TestDataFactory.MapCampaign(parentId, 1.00, date.newinstance(2015, 1, 5), date.newinstance(2015, 1, 27), 'USD', tagsMap.get('BQ_Jim Beam White'));
 			theTempCamp.Name = 'test' + i + 'test';
 			bulkCampaigns.add(theTempCamp);
 		}	
 		insert bulkCampaigns;
    	 	
    	Test.startTest();
    	
		//Test the Page controller extension and the Component Controller.
    	CampaignMultiRecordEditor pageCont = new CampaignMultiRecordEditor(new ApexPages.StandardController(parentRec));
    	
    	//Simulate Component Attributes being set via binding to PageControllerExt properties.
    	MultiRecordComponentController cont = new MultiRecordComponentController();   
    	cont.pageController = pageCont; 
    	pageCont.setComponentController(cont);
    	pageCont.RefreshPage();
    	system.assertEquals(pageCont.getMyComponentController(), cont);
    		
    	cont.sObjectType = pageCont.MysObj;    	
  		cont.ParentRecId = pageCont.MyRecId;
     	cont.RelationField = pageCont.MyRelationField;
     	cont.FieldList = pageCont.MyFieldList;
		cont.LabelOverrideFieldList = pageCont.MyLabelOverrideFieldList;
		cont.LabelOverrideTextList = pageCont.MyLabelOverrideTextList;
		cont.DefaultValueFieldList = pageCont.MyDefaultValueFieldList;
		cont.DefaultValueTextList = pageCont.MyDefaultValueTextList;
		
		cont.AllowAdd = pageCont.MyAllowAdd;
		cont.AllowEdit = pageCont.MyAllowEdit;
		cont.AllowDelete = pageCont.MyAllowDelete;
		cont.ShowCreateIOButton = pageCont.MyAllowCreateIO;
		cont.SearchFieldList = pageCont.MySearchFieldList;
			
    	//Initiate the querying
    	List<MultiRecordComponentController.ColumnWrapper> tmpColumnList = cont.ColumnList;
    	List<MultiRecordComponentController.ObjectWrapper> tmpObjectList = cont.ObjectList;
    	List<MultiRecordComponentController.QueryWhereFilter> tmpFilterList = cont.FilterList;
    	
    	system.assertEquals(25, tmpObjectList.size(), 'Should be 200 Campaigns for this MP, but only 25 at a time.');
    	system.assertEquals(5, tmpFilterList.size());
    	system.assertEquals(8, cont.TotalPages, 'Total Pages should be 8 because 200 / 25 = 8');
    	
    	//Test DoNext and DoPrevious, even though we expect them to do nothing because there's one page.
    	system.assertEquals(25, cont.ObjectList.size());
    	
    	system.assertEquals(1, cont.StdSetController.getPageNumber(), 'Should be on Page 1.');
    	cont.DoNext(); //to Page 2
    	system.assertEquals(2, cont.StdSetController.getPageNumber(), 'Should be on Page 2.');
    	cont.DoNext(); //to Page 3
    	system.assertEquals(3, cont.StdSetController.getPageNumber(), 'Should be on Page 3.');
    	cont.DoNext(); //to Page 4
    	system.assertEquals(4, cont.StdSetController.getPageNumber(), 'Should be on Page 4.');
    	cont.DoNext(); //to Page 5
    	system.assertEquals(5, cont.StdSetController.getPageNumber(), 'Should be on Page 5.');
    	cont.DoNext(); //to Page 6
    	system.assertEquals(6, cont.StdSetController.getPageNumber(), 'Should be on Page 6.');
    	cont.DoNext(); //to Page 7
    	system.assertEquals(7, cont.StdSetController.getPageNumber(), 'Should be on Page 7.');
    	cont.DoNext(); //to Page 8
    	system.assertEquals(8, cont.StdSetController.getPageNumber(), 'Should be on Page 8.');
    	cont.DoNext(); //stay on page 8
    	system.assertEquals(8, cont.StdSetController.getPageNumber(), 'Should still be on Page 8.');
    	system.assertEquals(25, tmpObjectList.size());
    	cont.DoPrevious(); // Page 7
    	cont.DoPrevious(); // Page 6
    	cont.DoPrevious(); // Page 5
    	cont.DoPrevious(); // Page 4
    	cont.DoPrevious(); // Page 3
    	cont.DoPrevious(); // Page 2
    	cont.DoPrevious(); // Page 1
    	system.assertEquals(1, cont.StdSetController.getPageNumber(), 'Should be back on page 1.');
    	cont.DoPrevious(); // Page 1 still
    	system.assertEquals(1, cont.StdSetController.getPageNumber(), 'Should remain on page 1.');
    	
    	//Test IO Creation
    	for (Integer i = 0; i < 5; i++) {
    		cont.ObjectList.get(i).IsSelected = true;
    	}
    	cont.UpdateSelectedSet();
    	cont.DoCreateIOs();
    	for (Integer i = 0; i < 5; i++) {
    		system.assertNotEquals(null, cont.ObjectList.get(i).obj.get('IOCode__c'), 'IO Code should exist');
    	}
    	//Test IO Creation exceptions.
    	cont.ObjectList.get(0).IsSelected = true;
    	cont.UpdateSelectedSet();
    	cont.DoCreateIOs();
    	List<Apexpages.Message> msgs = ApexPages.getMessages();
    	system.assert(msgs.size() > 0, 'Should have found an error creating an IO for a campaign that has one already.');
    	//Test IO with no checkboxes checked.
    	for (Integer i = 0; i < cont.ObjectList.size(); i++) {
    		cont.ObjectList.get(i).IsSelected = false;
    	}
    	cont.DoCancel();
    	cont.UpdateSelectedSet();
    	cont.DoCreateIOs();
    	msgs = ApexPages.getMessages();
    	system.assert(msgs.size() > 0, 'Should have found message: Please select at least one row using checkboxes before Creating IOs.');
    	cont.DoCancel();
    		
    	//Test Toggle Filters
    	system.assertEquals(false, cont.FilterVisible, 'Filters should be hidden by default');
    	cont.DoFilterToggle();
    	system.assertEquals(true, cont.FilterVisible, 'Filters should be visible after toggle.');
    	cont.DoFilterToggle();
    	system.assertEquals(false, cont.FilterVisible, 'Filters should be hidden after second toggle.');
    	    	  	   	
    	//Test Filtering
    	//List<MultiRecordComponentController.QueryWhereFilter> tmpFilterList = cont.FilterList;
    	system.assertEquals(5, cont.FilterList.size());
    	for (MultiRecordComponentController.QueryWhereFilter q : cont.FilterList) {    	
			if (q.FieldName == 'Name') {
				q.FilterText = 'test5test';
			}	
    	}
    	
    	cont.DoSearch();
    	system.assertEquals(1, cont.TotalPages, 'Total Pages should be 1 filtered Name to only a single campaign');
    	system.assertEquals(1, cont.ObjectList.size(), 'Only one record should be found');
    	
    	cont.ClearAllFilters();
    	system.assertEquals(8, cont.TotalPages, 'Removed all filters, should be back to 8 pages.');
    	
    	//Checkbox example CampaignType__c
    	MultiRecordComponentController.QueryWhereFilter campaignTypeFilter = cont.FilterList.get(2);
    	system.assertEquals(campaignTypeFilter.Options.size(), campaignTypeFilter.SelectedOptions.size());   	
    	//Simulate deselecting a checkbox
    	campaignTypeFilter.SelectedOptions.remove(0);
    	system.assertEquals(campaignTypeFilter.Options.size() - 1, campaignTypeFilter.SelectedOptions.size());
    	//Simualte do toggle all, which should check them all 
    	cont.ActionFilterFieldName = 'CampaignType__c';
    	cont.DoToggleCheckboxFilter();
    	system.assertEquals(campaignTypeFilter.Options.size(), campaignTypeFilter.SelectedOptions.size());
    	//Simulate deselect all
    	cont.ActionFilterFieldName = 'CampaignType__c';
    	cont.DoToggleCheckboxFilter();
    	system.assertEquals(0, campaignTypeFilter.SelectedOptions.size());
    	//Simulate check all
    	cont.ActionFilterFieldName = 'CampaignType__c';
    	cont.DoToggleCheckboxFilter();
    	system.assertEquals(campaignTypeFilter.Options.size(), campaignTypeFilter.SelectedOptions.size());
    	
    	Test.stopTest();
    		
	}
	
	/*
	*********************************** TESTING FORECASTS and SPEND **************************************
	*/
	
	static testmethod void testForecastGrid() {
		
		//Create test data
    	TestDataFactory.createMarketingPlanHierarchy();
    	Map<String, ID> tagsMap = TestDataFactory.GetTagsMap();
    	
		//  2015 US JBW American AMR SDP Heritage Arkansas $5K				
		List<String> planNames = new List<String>();
    	planNames.add('2015 US JBW American AMR SDP Heritage Arkansas $5K'); 
    	Map<String, MarketingPlan__c> plans = TestDataFactory.retrieveMarketingPlansByName(planNames);
    	
    	MarketingPlan__c parentRec = plans.get('2015 US JBW American AMR SDP Heritage Arkansas $5K');
    	ID parentId = parentRec.Id;
    	
    	//Create a test Campaign, with 12 forecast months
 		Campaign__c theTempCamp = TestDataFactory.MapCampaign(parentId, 1.20, date.newinstance(2015, 1, 5), date.newinstance(2015, 12, 27), 'USD', tagsMap.get('BQ_Jim Beam White'));
 		theTempCamp.Name = 'test forecasts and spend';
 		insert theTempCamp;
 		 		   	 	
    	Test.startTest();
    	
		//Test the Page controller extension and the Component Controller.
    	ForecastMultiRecordEditor pageCont = new ForecastMultiRecordEditor(new ApexPages.StandardController(theTempCamp));
    	CampaignSpendMultiRecordEditor pageCont2 = new CampaignSpendMultiRecordEditor(new ApexPages.StandardController(theTempCamp));
    	
    	
    	//Simulate Component Attributes being set via binding to PageControllerExt properties.
    	MultiRecordComponentController cont = new MultiRecordComponentController(); 
    	cont.pageController = pageCont; 
    	pageCont.setComponentController(cont);
    	pageCont.RefreshPage();
    	pageCont2.RefreshPage();
    	   	
    	cont.sObjectType = pageCont.MysObj;    	
  		cont.ParentRecId = pageCont.MyRecId;
     	cont.RelationField = pageCont.MyRelationField;
     	cont.FieldList = pageCont.MyFieldList;
		cont.LabelOverrideFieldList = pageCont.MyLabelOverrideFieldList;
		cont.LabelOverrideTextList = pageCont.MyLabelOverrideTextList;
		cont.DefaultValueFieldList = pageCont.MyDefaultValueFieldList;
		cont.DefaultValueTextList = pageCont.MyDefaultValueTextList;
		cont.AllowAdd = pageCont.MyAllowAdd;
		cont.AllowEdit = pageCont.MyAllowEdit;
		cont.AllowDelete = pageCont.MyAllowDelete;
		cont.ShowCreateIOButton = false;
		cont.SearchFieldList = pageCont.MySearchFieldList;
		cont.DefaultRelatedListFilter = pageCont.MyFilter;
			
    	//Initiate the querying
    	List<MultiRecordComponentController.ColumnWrapper> tmpColumnList = cont.ColumnList;
    	List<MultiRecordComponentController.ObjectWrapper> tmpObjectList = cont.ObjectList;
    	List<MultiRecordComponentController.QueryWhereFilter> tmpFilterList = cont.FilterList;
    	
    	system.assertEquals(12, cont.ObjectList.size(), 'Should be 12 Forecast records.');
    	system.assertEquals(1, cont.FilterList.size());
    	system.assertEquals(1, cont.TotalPages, 'Total Pages should be 1');
    	  	
    	//Test Picklist Filtering
    	for (MultiRecordComponentController.QueryWhereFilter q : cont.FilterList) {    	
			if (q.FieldName == 'Forecast_Month__c' && q.FieldType == 'Picklist') {				
				q.SelectedOptions = new List<String> { 'Jan', 'Feb', 'Mar' };
			}	
    	}
    	
    	cont.DoSearch();
    	system.assertEquals(1, cont.TotalPages, 'Total Pages should be 1 filtered Name to only a single campaign');
    	system.assertEquals(3, cont.ObjectList.size(), '3 Forecasts should be found, Jan, Feb and Mar.');
    	    	
    	cont.ClearAllFilters();
    	system.assertEquals(1, cont.TotalPages, 'Removed all filters, should be back to 1 pages.');
    	system.assertEquals(12, cont.ObjectList.size(), '12 forecasts should be found after Clear All Filters.');
    	
        
        unForecastedBudgetCampaignController unForecast = new unForecastedBudgetCampaignController(new ApexPages.StandardController(theTempCamp));
        unForecast.updateCampaign();
        
    	Test.stopTest();
    		
	}
	
}