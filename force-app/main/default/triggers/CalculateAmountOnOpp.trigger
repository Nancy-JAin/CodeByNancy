/**description -- INFOSYS INTERVIEW QUESTION 2025
 * Write a trigger that calculates the total Amount of related Opportunity records and updates the Total_Amount__c field on the parent Account record. 
 * Make sure it works in insert, update, and delete scenarios.
*/

trigger CalculateAmountOnOpp on Opportunity (after insert, after update, after delete, after undelete) {

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
            CalculateAmountOnOppHandler.calculateAmt(Trigger.new);
        }
        if(trigger.isDelete){
            CalculateAmountOnOppHandler.deleteAmt(Trigger.old);
        }
    }

}