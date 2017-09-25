/************************************************************************************** 
 Apex Test Class Name     : CaseControllerTest
 Created Date        	  : 5/13/2016
 Function                 : Supplying test data for CaseController
*************************************************************************************/
@isTest
public class CaseControllerTest{
    
    enum PortalType { CSPLiteUser, PowerCustomerSuccess, PowerPartner, CustomerSuccess }
    
    static testmethod void usertest() {
        User pu = getPortalUser(PortalType.PowerCustomerSuccess, null, true);
        
        System.assert([select isPortalEnabled 
                         from user 
                        where id = :pu.id].isPortalEnabled,
                      'User was not flagged as portal enabled.');       
		  
        System.RunAs(pu) {
            System.assert([select isPortalEnabled 
                             from user 
                            where id = :UserInfo.getUserId()].isPortalEnabled, 
                          'User wasnt portal enabled within the runas block. ');
          List<Case> cases= CaseController.getCases();
          List<Case> closedCases= CaseController.getClosedCases();
          List<Case> openCases= CaseController.getOpenCases();
          Boolean userProf = CaseController.getUserProf();
          CaseController.getAllClosedCases();
          CaseController.getAllOpenCases();
        }
        
        
    }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
    
        System.debug('portalType is::::::::'+portalType);
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            
            if(UserInfo.getUserRoleId() == null) {

                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        Account a;
        Contact c;
        System.runAs(userWithRole) {

            a = new Account(name = 'TEST ACCOUNT');
            Database.insert(a);
            
            c = new Contact(AccountId = a.id, lastname = 'lastname');
            Database.insert(c);

        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id from profile where usertype = :portalType.name() limit 1];   
        
        String testemail = 'puser000@amamama.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
    
    
    
    }