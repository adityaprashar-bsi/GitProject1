<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>Account.Name + &quot; - &quot; +   BrandVariety__r.Name  + &quot; &quot; +  TEXT(Bottle_Size__c)</formula>
        <name>Change Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Opportunity_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Beam_Driven</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Opportunity Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Source_Value</fullName>
        <description>Sets value of &quot;Source&quot; field to &quot;Rep Created&quot; when converting record type</description>
        <field>Source__c</field>
        <literalValue>Rep Created</literalValue>
        <name>Set Source Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCloseDateField</fullName>
        <field>CloseDate</field>
        <formula>Today() + 90</formula>
        <name>Update Close Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateQuantityField</fullName>
        <field>TotalOpportunityQuantity</field>
        <formula>IF(ActualBottlesofFirstFulfillment__c &lt;&gt; 0,ActualBottlesofFirstFulfillment__c, ExpectedBottlesofFirstFulfillment__c)</formula>
        <name>Update Quantity Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStageLastModifiedField</fullName>
        <field>StageLastModified__c</field>
        <formula>TODAY()</formula>
        <name>Update Stage Last Modified Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Reason</fullName>
        <field>ReasonWonorLost__c</field>
        <literalValue>Aperity Driven</literalValue>
        <name>Update Opportunity Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Stage</fullName>
        <field>StageName</field>
        <literalValue>Closed - Won Opportunity</literalValue>
        <name>Update Opportunity Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Size_Field</fullName>
        <field>SizeDescription__c</field>
        <formula>TEXT(Bottle_Size__c)</formula>
        <name>Update Size Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CloseOpportunityWhenFulfilled</fullName>
        <actions>
            <name>Update_Opportunity_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Opportunity_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow is meant to update stage to &quot;Closed - Won Opportunity&quot; &amp; reason to &quot;Aperity Driven&quot; when Aperity considers an opportunity as fulfilled and it has not yet been updated by a rep.</description>
        <formula>ISChanged( Fulfilled__c ) &amp;&amp; Fulfilled__c &amp;&amp;   ISPICKVAL(StageName, &apos;Open - Aperity Provided&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Convert Opportunity Record Type</fullName>
        <actions>
            <name>Change_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_Opportunity_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Source_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Size_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Beam Driven - Create Only</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Stage Last Modified Date and Time</fullName>
        <actions>
            <name>UpdateStageLastModifiedField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quantity Update</fullName>
        <actions>
            <name>UpdateQuantityField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>0, then when ExpectedBottlesofFirstFulfillment__c is populate, then when ActualBottlesofFirstFulfillment__c is populated</description>
        <formula>ISBLANK(TotalOpportunityQuantity )|| ISCHANGED( ActualBottlesofFirstFulfillment__c ) || ISCHANGED( ExpectedBottlesofFirstFulfillment__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Close Date</fullName>
        <actions>
            <name>UpdateCloseDateField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
