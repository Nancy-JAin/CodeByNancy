public with sharing class CalculateAmountOnOppHandler {
    
    public static void calculateAmt (List<Opportunity> newList){

        Map<Id,Decimal> accountIdToDecimal = new Map<Id,Decimal>();
    
        Set<Id> accountId = new Set<Id>();
        Decimal totalAmt = 0;
        for(Opportunity opp : newList){
            if (opp.AccountId != null) {
                accountId.add(opp.AccountId);
            }
        }

        List<Opportunity> allRelOpp = [Select Id, Amount, AccountId 
                                    FROM Opportunity
                                    WHERE AccountId IN: accountId];

        for(Opportunity opp : allRelOpp){
            if(opp.AccountId != null){
                totalAmt = totalAmt + opp.Amount;
                accountIdToDecimal.put(opp.AccountId, totalAmt);
            }
        }

        List<Account> accToUpdate = [Select Id , Total_Amount__c from Account where Id IN: accountIdToDecimal.keySet()];

        for(Account acc: accToUpdate){
            acc.Total_Amount__c = accountIdToDecimal.get(acc.Id);
        }

        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }

    }

    public static void deleteAmt (List<Opportunity> oldList){

        Set<Id> accountIds = new Set<Id>();
        Map<Id, Decimal> accountsTotalAmt = new Map<Id, Decimal>();
        Decimal totalAmt = 0;

        for(Opportunity opp: oldList){
            accountIds.add(opp.AccountId);
        }

        List<Opportunity> relatedOpp = [Select Id, Amount, AccountId from Opportunity where AccountId In: accountIds];
        
        for(Opportunity opp : relatedOpp){
            totalAmt = totalAmt + opp.Amount;
            accountsTotalAmt.put(opp.AccountId, totalAmt);
        }

        List<Account> acctsToUpdate = [Select Id, Total_Amount__c from Account where Id In: accountsTotalAmt.keySet()];

        for(Account acc: acctsToUpdate){
            acc.Total_Amount__c = accountsTotalAmt.get(acc.Id);
        }

        if(!acctsToUpdate.isEmpty()){
            update acctsToUpdate;
        }

    }
}