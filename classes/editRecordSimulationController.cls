public class editRecordSimulationController {

    @AuraEnabled
    public static Account getTypeFromAccount(string recordId)
    {
        Account acc = [select Name, Type from Account Where Id = :recordId limit 1];
        return acc;
    }
}