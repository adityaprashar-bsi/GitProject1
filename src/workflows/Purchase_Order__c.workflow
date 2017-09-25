<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SAP_Number_Time_Stamp</fullName>
        <field>SAP_No_Timestamp__c</field>
        <formula>Now()</formula>
        <name>SAP Number Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SAP_No_Within_SLA</fullName>
        <field>SAP_No_Updated_Within_SLA__c</field>
        <literalValue>1</literalValue>
        <name>Update SAP No Within SLA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PO SAP No Updated Within SLA</fullName>
        <actions>
            <name>Update_SAP_No_Within_SLA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if the “SAP Number” field’s value is changed and the Escalated field’s value is false then the “SAP No. Updated Within SLA” field’s value will be updated to true else it will be false.</description>
        <formula>AND( ISCHANGED( SAP_Number__c  ),  Case__r.IsEscalated = false   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Timestamp for SAP Number</fullName>
        <actions>
            <name>SAP_Number_Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( And(ISNEW(), NOT(ISBLANK(SAP_Number__c ))) ,ISCHANGED( SAP_Number__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
