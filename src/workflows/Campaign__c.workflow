<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AmericanFieldUpdate</fullName>
        <description>If Region is American, update Region_Hidden Picklist value.</description>
        <field>Region_Hidden__c</field>
        <literalValue>American</literalValue>
        <name>AmericanFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CampaignRequestIOFieldUpdate</fullName>
        <field>RequestStatus__c</field>
        <literalValue>IO Not Requested</literalValue>
        <name>CampaignRequestIOFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_IsBudgetChange</fullName>
        <field>Is_Budget_Change__c</field>
        <literalValue>1</literalValue>
        <name>Check IsBudgetChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FieldUpdatetoNA</fullName>
        <description>If NA Division is chosen, update Region_Hidden field.</description>
        <field>Region_Hidden__c</field>
        <literalValue>National Accounts</literalValue>
        <name>FieldUpdatetoNA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NationalAccountsFieldUpdate</fullName>
        <description>If Region is National Accounts, update Region_Hidden Picklist value.</description>
        <field>Region_Hidden__c</field>
        <literalValue>National Accounts</literalValue>
        <name>NationalAccountsFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test</fullName>
        <field>Description__c</field>
        <formula>ParentMarketingPlan__r.Territory__r.IOCodeSegment__c</formula>
        <name>Test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign Budget change</fullName>
        <actions>
            <name>Check_IsBudgetChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(PlannedCampaignSpend__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Request Status Populated</fullName>
        <actions>
            <name>CampaignRequestIOFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign__c.RequestStatus__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Request Status field is null, then &apos;IO Not Requested&apos; will populate.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>National Accounts - Participating States</fullName>
        <actions>
            <name>FieldUpdatetoNA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign__c.Division__c</field>
            <operation>equals</operation>
            <value>National Accounts</value>
        </criteriaItems>
        <description>If a Campaign is created under National Accounts Division, the Participating States field will be editable.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
