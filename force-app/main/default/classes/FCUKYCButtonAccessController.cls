public class FCUKYCButtonAccessController{
    public String profileName{get;set;}
    public PageReference init(){
        system.debug('enetring init method');
        Id profileId=userinfo.getProfileId();
        profileName=[Select Id,Name from Profile where Id=:profileId].Name;  
        system.debug('profileName'+profileName); 
        if(profileName == 'System Administrator - No IP'){
             return new PageReference('/apex/Docugen?sessionId={!API.Session_ID}&serverUrl={!API.Partner_Server_URL_80}&id={!Account.Id}&q1=[Acc]a5a3H00000090IM&TemplateGroup=KYCLetters');
        }
        return null; 
    }
}