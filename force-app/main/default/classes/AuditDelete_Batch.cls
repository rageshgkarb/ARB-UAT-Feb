global class AuditDelete_Batch implements Database.Batchable<sObject>,Database.Stateful{
    global integer count ;
    global integer failCount ;
    
    
    public AuditDelete_Batch(){
        count = 0;
        failCount = 0;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        date twoYearBeforeDate = date.today().addYears(-2);    
        String query = 'SELECT id  FROM audit__c WHERE CreatedDate <=:twoYearBeforeDate'; 
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<audit__c > auditList) {
        if(!auditList.isEmpty()){
            
            
            List<Database.DeleteResult> results = Database.delete(auditList);
            for (Database.DeleteResult result: results)
            {
              if (!result.isSuccess())
              {                
                failCount++;
              }else{
                  count++;
              }
            }
        }  
    }
    global void finish(Database.BatchableContext BC){
        string theSubject = 'Audit Deletion Batch - Update';
        string theHtmlBody = 'Hi,<br/> <p>The monthly audit deletion is completed, Number of records deleted sucessfully:'+count+'</p>';
        theHtmlBody += failCount>0?'<br/> <p>The monthly audit deletion is completed, Number of records deleted sucessfully:'+failCount+'</p>':'';
        theHtmlBody += '<br/>Thank You';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = system.label.AuditEmail.split(','); 
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('noreply@alrayanbank.co.uk');
        mail.setSenderDisplayName('');        
        mail.setSubject(theSubject);
        mail.setHtmlBody(theHtmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}