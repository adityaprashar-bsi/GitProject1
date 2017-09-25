<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assign_to_International_Queue</fullName>
        <description>Assign to International Queue</description>
        <field>OwnerId</field>
        <lookupValue>International_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to International Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>International_Queue_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>International_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>International Queue Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reopen_Case</fullName>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>Reopen Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reopen_Case_CS</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Reopen Case_CS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Rebate_Case_1st_Cat</fullName>
        <field>Primary_Category__c</field>
        <formula>&quot;Pricing&quot;</formula>
        <name>Set Rebate Case - 1st Cat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Rebate_Case_2nd_Cat</fullName>
        <field>Secondary_Category__c</field>
        <formula>&quot;Rebates&quot;</formula>
        <name>Set Rebate Case - 2nd Cat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Primary_Category</fullName>
        <description>Update Primary Category to &quot;Pricing&quot;</description>
        <field>Category_1__c</field>
        <literalValue>Pricing</literalValue>
        <name>Update Primary Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Secondary_Category</fullName>
        <field>Category_2__c</field>
        <literalValue>Rebates</literalValue>
        <name>Update Secondary Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Germany Rebate Agreements</fullName>
        <actions>
            <name>Set_Rebate_Case_1st_Cat</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Rebate_Case_2nd_Cat</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Primary_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Secondary_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.FromName</field>
            <operation>equals</operation>
            <value>Germany Rebate Agreements</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>International Case Received</fullName>
        <actions>
            <name>International_Queue_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.ToAddress</field>
            <operation>contains</operation>
            <value>cs_international@beamsuntory.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.CcAddress</field>
            <operation>contains</operation>
            <value>cs_international@beamsuntory.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule to assign all the cases to International queue which are sent to cs_international inbox.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Reopen CS Case</fullName>
        <actions>
            <name>Reopen_Case_CS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Incoming = TRUE, Parent.IsClosed = TRUE,OR(FromName!=&quot;Customer Service&quot;, FromName!=&quot;Mail Delivery System&quot;), OR( Parent.RecordType.Name = &quot;Inquiry&quot;, Parent.RecordType.Name = &quot;Inquiry Internal&quot;,Parent.RecordType.Name = &quot;EDI Order&quot;, Parent.RecordType.Name = &quot;Order Claim&quot;, Parent.RecordType.Name = &quot;Orders&quot;, Parent.RecordType.Name = &quot;Quality Claim&quot;, Parent.RecordType.Name = &quot;Escalated Form&quot;, Parent.RecordType.Name = &quot;Changes&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reopen GBS Case</fullName>
        <actions>
            <name>Reopen_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Field update that sets the Case status to Active whenever someone responds to a closed GBS Case email alert with &quot;REOPEN&quot; in the subject line</description>
        <formula>AND(      Incoming = TRUE,      Parent.IsClosed = TRUE,      OR(          CONTAINS( UPPER(Subject), &quot;REOPEN&quot; ),          CONTAINS( UPPER(Subject), &quot;RE-OPEN&quot; ),          CONTAINS( UPPER(Subject), &quot;RE OPEN&quot; )      ),      OR(          CONTAINS(Parent.RecordType.Name, &quot;GMDM&quot;),          Parent.RecordType.Name = &quot;HR&quot;,          Parent.RecordType.Name = &quot;PTP/AP&quot;,     Parent.RecordType.Name = &quot;PTP/AP - PR/PO&quot;,           Parent.RecordType.Name = &quot;Bailment&quot;,          CONTAINS(Parent.RecordType.Name, &quot;OTC&quot;),          Parent.RecordType.Name = &quot;RTR&quot;,          Parent.RecordType.Name = &quot;Payroll&quot;,     Parent.RecordType.Name = &quot;T&amp;E&quot;   )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
