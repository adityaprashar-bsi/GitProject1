<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Assigned_Alert</fullName>
        <description>Case Assigned Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CS_System_Emails/CA_Changes_Escalations_International_ML</template>
    </alerts>
    <alerts>
        <fullName>Case_Closed_Order</fullName>
        <description>Case Closed (Order)</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Case_Resolved_Email_ML</template>
    </alerts>
    <alerts>
        <fullName>Change_Approved_Email</fullName>
        <description>Change Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Change_Approval_ML</template>
    </alerts>
    <alerts>
        <fullName>Change_Escalation_Email</fullName>
        <description>Change Escalation Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>dawn.masterson@beamsuntory.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Case_Escalation</template>
    </alerts>
    <alerts>
        <fullName>Changes_Case_email_alert</fullName>
        <description>Changes Case email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CS_System_Emails/Case_Assignment_Email_Changes_ML</template>
    </alerts>
    <alerts>
        <fullName>Claim_Amount_Approved_Alert</fullName>
        <description>Claim Amount Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Claim_Amount_Approved_Internal</template>
    </alerts>
    <alerts>
        <fullName>Claim_Amount_Rejected</fullName>
        <description>Claim Amount Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Claim_Amount_Rejected_Internal</template>
    </alerts>
    <alerts>
        <fullName>Claim_Approved_Letter</fullName>
        <description>Claim Approved Letter</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Approved_Claim_Response_ML</template>
    </alerts>
    <alerts>
        <fullName>Claims_Assignment_Email_Alert</fullName>
        <description>Claims Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Case_Assignment_Email_All_Claims_ML</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Case</fullName>
        <description>Email-to-Case</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Email_to_Case_ML</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Email_Notifcation</fullName>
        <description>Escalated Email Notifcation</description>
        <protected>false</protected>
        <recipients>
            <recipient>dawn.masterson@beamsuntory.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lynn.bernard@beamsuntory.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Escalated_Case_Created</template>
    </alerts>
    <alerts>
        <fullName>GBS_Case_Assigned_Notification</fullName>
        <description>GBS - Case Assigned Notification</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GBS_System_Emails/Case_Assigned</template>
    </alerts>
    <alerts>
        <fullName>GBS_Case_Closed_Notification</fullName>
        <description>GBS - Case Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GBS_System_Emails/Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Inquiry_Email_to_Case_Rule</fullName>
        <description>Inquiry Email to Case Rule</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CS_System_Emails/Case_Assignment_Email_All_Inquiries_ML</template>
    </alerts>
    <alerts>
        <fullName>Notify_New_Case_Owner_of_Case_Transfer</fullName>
        <description>Notify New Case Owner of Case Transfer</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GBS_System_Emails/Case_Assigned_Internal_Notification</template>
    </alerts>
    <alerts>
        <fullName>Order_Case_Assigned</fullName>
        <description>Order Case Assigned</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Case_Assignment_Email_Orders_ML</template>
    </alerts>
    <alerts>
        <fullName>Outlook_to_Case_Alert</fullName>
        <description>Outlook to Case Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Automated_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Email_to_Case_ML</template>
    </alerts>
    <alerts>
        <fullName>Training_Approved</fullName>
        <description>Training Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Case_Trainer_Approved_Internal</template>
    </alerts>
    <alerts>
        <fullName>Training_Rejected</fullName>
        <description>Training Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>customer.service@beamsuntory.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_System_Emails/Case_Trainer_Rejected_Internal</template>
    </alerts>
    <fieldUpdates>
        <fullName>Abandoned_Record_Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed - Abandoned</literalValue>
        <name>Abandoned Record - Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_Credit</fullName>
        <field>Status</field>
        <literalValue>Closed - Approved</literalValue>
        <name>Approve Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_Credit_Box</fullName>
        <field>Proposed_Credit_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approve Credit Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_Record_Case_Resolution_Details</fullName>
        <field>Case_Resolution_Details__c</field>
        <formula>&quot;Your case has been approved.&quot;
&amp;BR() &amp; BR() &amp;
Case_Resolution_Details__c</formula>
        <name>Approve Record - Case Resolution Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_Record_Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Approve Record - Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Claim_Amount_Approval</fullName>
        <field>Claim_Amount_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Claim Amount Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compliant_Pro_No_Updated_Within_SLA</fullName>
        <description>if the “Compliant Pro Number” field’s value is changed and the Escalated field’s value is false then the “Compliant Pro No. Updated Within SLA” field’s value will be updated to true else it will be false.</description>
        <field>Compliant_Pro_No_Updated_Within_SLA__c</field>
        <literalValue>1</literalValue>
        <name>Compliant Pro No. Updated Within SLA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject_Record_Update_Status</fullName>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>Reject Record - Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Toggle</fullName>
        <field>Toggle__c</field>
        <formula>1</formula>
        <name>Reset Toggle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Status_Working</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Set Case Status - Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Subject</fullName>
        <field>Subject</field>
        <formula>IF(OR(AND(ISPICKVAL(Type, &quot;Order to Cash / Billing&quot;), RecordType.Name &lt;&gt; &quot;OTC - Invoice Number&quot;), ISPICKVAL(Type, &quot;Global Master Data Management&quot;)), CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name,
Case( RecordType.Name, 
&quot;HR&quot;, CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name &amp;&quot; - &quot;&amp; TEXT(Category_1__c),
&quot;OTC - Invoice Number&quot;, &quot;OTC - General&quot;,
&quot;Payroll&quot;, CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name &amp;&quot; - &quot;&amp; TEXT(Category_1__c),
&quot;PTP/AP&quot;, CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name &amp;&quot; - &quot;&amp; TEXT(Category_1__c),
&quot;PTP/AP - PR/PO&quot;, CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name &amp;&quot; - &quot;&amp; TEXT(Category_1__c),
&quot;RTR&quot;, CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name &amp;&quot; - &quot;&amp; TEXT(Category_1__c),
&quot;T&amp;E&quot;, CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name &amp;&quot; - &quot;&amp; TEXT(Category_1__c),
CaseNumber&amp;&quot;: &quot;&amp; RecordType.Name&amp;&quot; - &quot;&amp; TEXT(Type))
)</formula>
        <name>Set Case Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Time_Assigned</fullName>
        <field>Date_Time_Assigned__c</field>
        <formula>NOW()</formula>
        <name>Set Date/Time Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_New_Activity_Flag</fullName>
        <field>New_Activity__c</field>
        <literalValue>1</literalValue>
        <name>Set New Activity Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Toggle_to_0</fullName>
        <field>Toggle__c</field>
        <formula>0</formula>
        <name>Set Toggle to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Changes_Within_SLA</fullName>
        <description>Create a workflow rule on Case with criteria that whenever the “Status” field’s value is changed from New to working and if Escalated field’s value is false then the “Status Changed Within SLA” field’s value will be updated to true else it will be false.</description>
        <field>Status_Changed_Within_SLA__c</field>
        <literalValue>1</literalValue>
        <name>Status Changes Within SLA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submit_Approval_Update_Status</fullName>
        <field>Status</field>
        <literalValue>Close Pending</literalValue>
        <name>Submit Approval - Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Update_SLA_Times</fullName>
        <field>Update_SLA_Times__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Update SLA Times</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Automated_Notification_Email</fullName>
        <field>Automated_Notification_Email__c</field>
        <formula>Submitter__r.Email</formula>
        <name>Update Automated Notification Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SLA_Times</fullName>
        <field>Update_SLA_Times__c</field>
        <literalValue>1</literalValue>
        <name>Update SLA Times</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Active</fullName>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>Update Status - Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Closed</fullName>
        <description>Close and keep the Case locked upon approval by trainer</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Status - Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Training_Approved_Field</fullName>
        <field>Training_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Training Approved Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_subject</fullName>
        <field>Subject</field>
        <formula>Subject &amp; &quot; &quot; &amp;  CaseNumber</formula>
        <name>Update subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Adding case no to the subject</fullName>
        <actions>
            <name>Update_subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Abandoned</fullName>
        <actions>
            <name>Abandoned_Record_Close_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Owner:Queue.DeveloperName = &quot;Abandoned_Cases&quot;  &amp;&amp;  
NOT(ISPICKVAL(Status,&quot;Closed - Abandoned&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Assigned</fullName>
        <actions>
            <name>Case_Assigned_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR (1 AND 2 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Escalated Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Assignment_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Email alert that is delivered to Case Submitter upon assignment of their Escalated case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Assigned - GBS</fullName>
        <actions>
            <name>GBS_Case_Assigned_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email alert that is delivered to Case Submitter upon assignment of their GBS case</description>
        <formula>AND(    OR(      CONTAINS(RecordType.Name, &quot;GMDM&quot;),      RecordType.Name = &quot;PTP/AP&quot;,      RecordType.Name = &quot;T&amp;E&quot;,      RecordType.Name = &quot;PTP/AP - PR/PO&quot;,          RecordType.Name = &quot;RTR&quot;,          CONTAINS(RecordType.Name, &quot;OTC&quot;),      RecordType.Name &lt;&gt; &quot;OTC - Credit Approval&quot;,         RecordType.Name = &quot;HR&quot;,          RecordType.Name = &quot;Payroll&quot;),        ISPICKVAL(Status, &quot;Active&quot;),        ISPICKVAL(PRIORVALUE(Status), &quot;Logged&quot;   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Assigned Changes</fullName>
        <actions>
            <name>Changes_Case_email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR (1 AND 2 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Changes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Assignment_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Email alert that is delivered to Case Submitter upon assignment of their CS Change case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Assignment Inquiries</fullName>
        <actions>
            <name>Inquiry_Email_to_Case_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 3 AND 4) OR (2 AND 3) OR (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry (Internal)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Assignment_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <description>Email alert that is delivered to Case Submitter upon assignment of their CS Inquiry case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed - GBS</fullName>
        <actions>
            <name>GBS_Case_Closed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email alert that is delivered to Case Submitter upon closure of their GBS case</description>
        <formula>AND(
 IsClosed = TRUE,
 NOT(OR(
   ISPICKVAL(Status, &quot;Closed - Abandoned&quot;),
   ISPICKVAL(Status, &quot;Closed - No Action&quot;))
   ),
 OR(
   CONTAINS(RecordType.Name, &quot;GMDM&quot;),
   RecordType.Name = &quot;PTP/AP&quot;,
   RecordType.Name = &quot;T&amp;E&quot;,
   RecordType.Name = &quot;PTP/AP - PR/PO&quot;,
   RecordType.Name = &quot;RTR&quot;,
   CONTAINS( RecordType.Name, &quot;OTC&quot;),     
   RecordType.Name = &quot;HR&quot;,
   RecordType.Name = &quot;Payroll&quot;)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed Order</fullName>
        <actions>
            <name>Case_Closed_Order</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR (1 AND 2 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Orders</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Closed_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Case Resolution workflow to send case closed email (All Profiles)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Ownership Transferred</fullName>
        <actions>
            <name>Notify_New_Case_Owner_of_Case_Transfer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email alert that is delivered to new Case Owner upon transfer of a Case by someone other than the new Owner</description>
        <formula>ISCHANGED( OwnerId ) &amp;&amp; OwnerId &lt;&gt; $User.Id &amp;&amp; NOT( ISBLANK( Owner:User.Id ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Approval</fullName>
        <actions>
            <name>Change_Approved_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Changes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Inco_Terms_Approved__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Changes Escalation - After 3</fullName>
        <active>true</active>
        <description>Escalate unassigned Change Cases created after 3pm at 12:00pm the following day</description>
        <formula>AND(  RecordType.Name = &quot;Changes&quot;,  CreatedDate &gt; DATETIMEVALUE(TEXT(DATEVALUE(CreatedDate)) &amp; IF( OR(AND( MONTH(DATEVALUE(CreatedDate)) &gt;= 11, DAY(DATEVALUE(CreatedDate)) &gt;= 3),AND( MONTH(DATEVALUE(CreatedDate)) &lt;= 3, DAY(DATEVALUE(CreatedDate)) &lt;= 10)),&apos; 21:00:00&apos;,&apos; 20:00:00&apos;)  ),  ISPICKVAL(Status, &quot;New&quot;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_Escalation_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Change_Escalation_Time_After_3__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Changes Escalation - Before 3</fullName>
        <active>true</active>
        <description>Escalate unassigned Change Cases created at or before 3pm at 5:30pm that day; escalate unassigned Change Cases created after 3pm by noon the following day</description>
        <formula>AND(  RecordType.Name = &quot;Changes&quot;,  CreatedDate &lt;= DATETIMEVALUE(TEXT(DATEVALUE(CreatedDate)) &amp; IF( OR(AND( MONTH(DATEVALUE(CreatedDate)) &gt;= 11, DAY(DATEVALUE(CreatedDate)) &gt;= 3),AND( MONTH(DATEVALUE(CreatedDate)) &lt;= 3, DAY(DATEVALUE(CreatedDate)) &lt;= 10)),&apos; 21:00:00&apos;,&apos; 20:00:00&apos;)  ),  ISPICKVAL(Status, &quot;New&quot;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_Escalation_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.SLA_End_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Claim Approved</fullName>
        <actions>
            <name>Claim_Approved_Letter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) OR (5 AND 3 AND 6 AND 4) OR (1 AND 9 AND 8 AND 4) OR (1 AND 7 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Shortage Claim,Damage Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CPro_Approval__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Quality Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Financial_Disposition__c</field>
            <operation>equals</operation>
            <value>Credit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Freight Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Overage__c</field>
            <operation>equals</operation>
            <value>Purchase</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Overage Claim</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Compliant Pro No%2E Updated Within SLA</fullName>
        <actions>
            <name>Compliant_Pro_No_Updated_Within_SLA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if the “Compliant Pro Number” field’s value is changed and the Escalated field’s value is false then the “Compliant Pro No. Updated Within SLA” field’s value will be updated to true else it will be false.</description>
        <formula>AND(  NOT(ISNEW()),  ISCHANGED( Compliant_Pro_Number__c  ),  IsEscalated = false  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email to Case</fullName>
        <actions>
            <name>Email_to_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) OR (1 AND 2 AND 3 AND 5) OR (3 AND 4 AND 6 AND 7) OR (3 AND 5 AND 6 AND 7)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Orders,Inquiry,Inquiry (Internal),Quality Claim,Order Claim,Changes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Created_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Changes,EDI Order,Inquiry,Inquiry (Internal),Order Claim,Orders,Quality Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outlook</value>
        </criteriaItems>
        <description>Email for email-to-case Order submissions (All Profiles)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Form Submission Alert</fullName>
        <actions>
            <name>Escalated_Email_Notifcation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Escalated Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Order Case Assignment Email</fullName>
        <actions>
            <name>Order_Case_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 4) OR (1 AND 2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Orders</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Assignment_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Claim Case Assignment</fullName>
        <actions>
            <name>Claims_Assignment_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR (1 AND 2 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Claim,Quality Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Assignment_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Outlook to Case</fullName>
        <actions>
            <name>Outlook_to_Case_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) OR (1 AND 2 AND 3 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outlook</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Changes,EDI Order,Escalated Form,Inquiry,Inquiry (Internal),Order Claim,Orders,Quality Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Case_Created_Notifications__c</field>
            <operation>equals</operation>
            <value>On</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Email for email-to-case Order submissions (All Profiles)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SLA Workflow</fullName>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Toggle__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Toggle__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Field update that triggers the CaseServices class via time-based workflow; this class will update the SLA Start and End Time, Last Status Change, Time with Customer and Time with Support fields at end of day; candidate for scheduled batch class</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Toggle_to_0</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_SLA_Times</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.SLA_End_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Case Subject</fullName>
        <actions>
            <name>Set_Case_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Email</value>
        </criteriaItems>
        <description>Field update that sets the Case subject according to the type of Case submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Date%2FTime Assigned</fullName>
        <actions>
            <name>Set_Date_Time_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Field update that sets the Date and Time that a case is assigned</description>
        <formula>OR(ISPICKVAL(PRIORVALUE(Status),&quot;New&quot;), ISPICKVAL(PRIORVALUE(Status),&quot;Logged&quot;)) &amp;&amp; OR(ISPICKVAL(Status, &quot;Working&quot;), ISPICKVAL(Status, &quot;Active&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Status Change Updates Activity Flag</fullName>
        <actions>
            <name>Set_New_Activity_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; $User.Id &lt;&gt; OwnerId</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Status field%E2%80%99s value is changed from New to working</fullName>
        <actions>
            <name>Status_Changes_Within_SLA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Create a workflow rule on Case with criteria that whenever the “Status” field’s value is changed from New to working and if Escalated field’s value is false then the “Status Changed Within SLA” field’s value will be updated to true else it will be false.</description>
        <formula>AND(     NOT(ISNEW()),     ISCHANGED(Status),     ISPICKVAL(PRIORVALUE(Status),&quot;New&quot;),     ISPICKVAL(Status, &quot;Working&quot;),     IsEscalated = false  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck Toggle</fullName>
        <actions>
            <name>Reset_Toggle</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Update_SLA_Times</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Update_SLA_Times__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Toggle__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Toggle__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Field update that works in tandem with the SLA Workflow to reset the Update SLA Times and Toggle fields</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Automated Notification Email</fullName>
        <actions>
            <name>Update_Automated_Notification_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( Submitter__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Case Status on Acceptance from Queue-GBS</fullName>
        <actions>
            <name>Update_Status_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED(OwnerId),  LEFT(OwnerId, 3) &lt;&gt; &quot;00G&quot;, OR(  CONTAINS(RecordType.Name, &quot;GMDM&quot;),  RecordType.Name = &quot;HR&quot;,  RecordType.Name = &quot;PTP/AP&quot;,  RecordType.Name = &quot;PTP/AP - PR/PO&quot;,  RecordType.Name = &quot;Bailment&quot;,  CONTAINS(RecordType.Name, &quot;OTC&quot;),  RecordType.Name = &quot;RTR&quot;,  RecordType.Name = &quot;Payroll&quot;,  RecordType.Name = &quot;T&amp;E&quot;  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
