public class AccountFlowService {
    
    // Input wrapper
    public class AccountInput{
        @InvocableVariable(label='Account Name' description='Name of the account')
        public String accountName;
    }
    
    
    // Output wrapper
    public class AccountOutput{
        
        @InvocableVariable(label='Account Id' description='Account Id of the account')
        public Id accountId;
        
        @InvocableVariable(label='Account Name' description='Name of the account')
        public String accountName;
        
        @InvocableVariable(label='Account Phone' description='Phone of the account')
        public String phone;
        
        @InvocableVariable(label='Account Industry' description='Industry of the account')
        public String industry;
        
        @InvocableVariable(label='Contacts Summary' description='List of contacts')
        public String contactsSummary;
        
        @InvocableVariable(label='Opportunities Summary' description='List of opportunities')
        public String opportunitiesSummary;
        
        @InvocableVariable(label='Cases Summary' description='List of cases')
        public String casesSummary;
    }
    
    @InvocableMethod(label='Find Account' description='Find account by name and account info.')
    public static List<AccountOutput> findAccount(List<AccountInput> inputs){
        List<AccountOutput> outputs = new List<AccountOutput>();
        
        for(AccountInput input:inputs){
            Account acc = [
                SELECT Id, Name, Phone, Industry,
                	(SELECT Id, Name, Email FROM Contacts),
                	(SELECT Id, Name, StageName, Amount FROM Opportunities),
                (SELECT Id, CaseNumber, Status, Subject FROM Cases)
                FROM Account
                WHERE Name = :input.accountName
                LIMIT 1
            ];
            
            AccountOutput out = new AccountOutput();
            out.accountId = acc.Id;
            out.accountName = acc.Name;
            out.phone = acc.Phone;
            out.industry = acc.Industry;
            
            // Flatten contacts into a summary string
            List<String> contactSummaries = new List<String>();
            for (Contact c : acc.Contacts) {
                contactSummaries.add(c.Name + ' (' + c.Email + ')');
            }
            out.contactsSummary = contactSummaries.isEmpty() ? 'No contacts found' : String.join(contactSummaries, '; ');
            
             // Flatten opportunities into a summary string
            List<String> opportunitySummaries = new List<String>();
            for (Opportunity o : acc.Opportunities) {
                opportunitySummaries.add(o.Name + ' - ' +o.StageName +' - '+String.valueOf(o.Amount));
            }
            out.opportunitiesSummary = opportunitySummaries.isEmpty() ? 'No Opportunities found' : String.join(opportunitySummaries, '; ');
            
               // Flatten cases into a summary string
            List<String> caseSummaries = new List<String>();
            for (Case cs : acc.Cases) {
                caseSummaries.add(cs.CaseNumber + ' - ' + cs.Status + ' - '+cs.Subject);
            }
            out.casesSummary = caseSummaries.isEmpty() ? 'No cases found' : String.join(caseSummaries, '; ');
            
            outputs.add(out);
        }
        return outputs;
    }
}