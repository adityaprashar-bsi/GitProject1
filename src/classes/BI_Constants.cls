public without sharing class BI_Constants {
	//Error Messages
    public static final String DUPLICATE_PLAN = 'This Marketing Plan is a duplicate. Please correct the issue and try again.';
	public static final String PLAN_ALLOCATEDBUDGET_VIOLATION = 'This change would cause the parent Marketing Plan\'s Allocated Budget to exceed Budget. Please correct the issue and try again.';
	public static final String TRANSFERREQUEST_MULTIPLEAPPROVALS = 'Error: Multiple Marketing Plan Transfers got approved at the same time which is unsupported. Please try your approval again shortly.';
	public static final String TRANSFERREQUEST_CAMPAIGNSLUSH_TOOLOW = 'The Sender Marketing Plan (From) does not have enough Campaign Unallocated Budget available to complete the transfer. Please contact your administrator.';
	public static final String TRANSFERREQUEST_PLANSLUSH_TOOLOW = 'The Sender Marketing Plan (From) does not have enough MP Unallocated Budget available to complete the transfer. Please contact your administrator.';
	public static final String TRANSFERREQUEST_UNKNOWN = 'We were unable to automate the Transfer Request. Please send the following error to your administrator: ';
	public static final String IO_ALREADYHASIO = 'This Campaign already has an IO Code generated.';
	public static final String IO_YEAR_MISSING = 'This Campaign is missing Year which is required to generate an IO Code.';
	public static final String IO_SAP_CONTROLLINGAREA = 'This Campaign is missing SAP Controlling Area which is required to generate an IO Code.';
	public static final String IO_SAP_COMPANYCODE = 'This Campaign is missing SAP Company Code which is required to generate an IO Code.';
	public static final String IO_SAP_COSTCENTER = 'This Campaign is missing SAP Cost Center which is required to generate an IO Code.';
	public static final String IO_BRANDQUALITY = 'This Campaign is either missing a Brand Quality, the Brand Quality is missing an IO Code Segment, or the IO Code Segment is not 5 characters long.';
	public static final String IO_TERRITORY = 'This Campaign\'s parent Marketing Plan is either missing a Territory, the Territory is missing an IO Code Segment, or the IO Code Segment is not 2 characters long.';
	public static final String IO_DUPLICATE = 'A duplicate IO Code was found on another Campaign. Please contact your administrator.';
	public static final String MISSING_CONVERSION_RATE = 'There is no conversion rate available for the specified date. Please contact your administrator to check the configuration of the currency conversion rates.';
	public static final String INCORRECT_DATE_FORMAT = 'The date field used for conversion was not formatted properly. Please have your administrator inspect the following field: ';
	public static final String UNEXPECTED_ERROR = 'An unexpected error occurred. Please contact an administrator to confirm that the conversion rates are configured properly.';
	//Record Types
	public static final String RECORDTYPE_CAMPAIGNSPEND_FORECAST = 'Forecast';
	public static final String RECORDTYPE_CAMPAIGNSPEND_ACTUAL = 'Actual';
	public static final String RECORDTYPE_CAMPAIGNSPEND_COMMITTED = 'Committed';	
	//DEPRECATED public static final String RECORDTYPE_MP_CAMPAIGNALLOWED_EDIT = 'Campaigns_Allowed_Editable';
	public static final String RECORDTYPE_MP_CAMPAIGNALLOWED = 'Campaigns_Allowed_Not_Editable';
	//public static final String RECORDTYPE_MP_CAMPAIGNPROHIBITED_EDIT = 'Campaigns_Prohibited_Editable';
	public static final String RECORDTYPE_MP_CAMPAIGNPROHIBITED = 'Campaigns_Prohibited_Not_Editable';
	
	//Object Names
	public static final String OBJECT_CAMPAIGNSPEND = 'Campaign_Spend__c';
	public static final String OBJECT_MARKETINGPLAN = 'MarketingPlan__c';
	
	//MISC
	public static final String TRANSFERREQUEST_STATUS_APPROVED = 'Approved';

}