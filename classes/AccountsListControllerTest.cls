/**
 * Created by annaMahovskaya on 3/4/18.
 */
@isTest
private class AccountsListControllerTest {
	@isTest 
    static void addAccountTest() {
         Account testAccount = new Account(Name='TestNameAccount');
     	 AccountsListContoller contr = new AccountsListContoller();
         contr.acct = new Account(Name = testAccount.Name);
    	 Integer sizeBefore = contr.wrapAccountList.size();
         Test.startTest();
    	 	contr.addAccount();
         Test.stopTest();
     	 Integer sizeAfter = contr.wrapAccountList.size();
    	 System.assertEquals(1, sizeAfter - sizeBefore);
    }
    
    
    @isTest 
    static void editAccountTest() {
        Account testAccount = new Account(Name='TestNameAccount',  Phone='123456');
        insert testAccount;
        AccountsListContoller contr = new AccountsListContoller();
        contr.acct = testAccount;
        contr.isEdit = true;
        AccountsListContoller.WrapAccount wac = new AccountsListContoller.WrapAccount(contr.acct);
        contr.wrapAccountList.add(wac);
        contr.acct.Phone = '555555';
        Id updId = contr.acct.Id;
        Test.startTest();
        	contr.editAccount();
        Test.stopTest();
        String phone ='';
        for(AccountsListContoller.WrapAccount wa:contr.wrapAccountList){
            if(wa.acc.Id == updId){
                phone = wa.acc.Phone;
            }
        }
        System.assertEquals('555555', testAccount.Phone);
        System.assertEquals('555555', phone);
        System.assertEquals(false, contr.isEdit);
    }
    
    @isTest 
    static void deleteSelectedTest() {
        Account testAccount1 = new Account(Name='TestNameAccount1');
        Account testAccount2 = new Account(Name='TestNameAccount2');
        insert testAccount1;
        insert testAccount2;
        AccountsListContoller contr = new AccountsListContoller();
        contr.isEdit = true;
        AccountsListContoller.WrapAccount wac1 = new AccountsListContoller.WrapAccount(testAccount1);
        wac1.selected = true;
        AccountsListContoller.WrapAccount wac2 = new AccountsListContoller.WrapAccount(testAccount2);
        wac2.selected = true;
        contr.wrapAccountList.add(wac1);
        contr.wrapAccountList.add(wac2);
        Integer sizeBefore = contr.wrapAccountList.size();
        Test.startTest();
        	contr.deleteSelected();
        Test.stopTest();
        Integer sizeAfter = contr.wrapAccountList.size();
        System.assertEquals(2, sizeBefore - sizeAfter);
    }
    
    @isTest
    static void openPopupEditAccountTest(){
        Account testAccount = new Account(Name='TestNameAccount');
        insert testAccount;
        ApexPages.currentPage().getParameters().put('accId',testAccount.Id);
        AccountsListContoller contr = new AccountsListContoller();
        Test.startTest();
        	contr.openPopupEditAccount();
        Test.stopTest();
        System.assertEquals(true, contr.displayPopup);
        System.assertEquals(true, contr.isEdit);
    }
    
     @isTest
    static void openPopupAddContactTest(){
        Account testAccount = new Account(Name='TestNameAccount');
        insert testAccount;
        Contact testContact = new Contact(accountId = testAccount.Id, LastName = 'Test');
        insert testContact;
        ApexPages.currentPage().getParameters().put('accIdForContact',testAccount.Id);
        AccountsListContoller contr = new AccountsListContoller();
        contr.cont = testContact;
        Test.startTest();
    	 	contr.openPopupAddContact();
        Test.stopTest();
        System.assertEquals(testAccount.Id,  contr.cont.accountId);
        System.assertEquals(true, contr.displayPopUpContact);
    }
    
    @isTest
    static void saveContactTest(){
        Account testAccount = new Account(Name='TestNameAccount');
        insert testAccount;
        Contact testContact = new Contact(accountId = testAccount.Id, LastName = 'TestLN', FirstName = 'TestFN', Title='title', Phone='555');
        AccountsListContoller contr = new AccountsListContoller();
        AccountsListContoller.WrapAccount wac = new AccountsListContoller.WrapAccount(testAccount);
        contr.wrapAccountList.add(wac);
        
        contr.cont = testContact;
        Integer sizeContactListBefore = 0;
        for(AccountsListContoller.WrapAccount wa:contr.wrapAccountList){
            if(wa.acc.Id == testAccount.Id){
                sizeContactListBefore = wa.contactsList.size();
            }
        }
        Test.startTest();
        	contr.saveContact();
        Test.stopTest();
        Integer sizeContactListAfter = 0;
        for(AccountsListContoller.WrapAccount wa:contr.wrapAccountList){
            if(wa.acc.Id == testAccount.Id){
                sizeContactListAfter = wa.contactsList.size();
            }
        }
        System.assertEquals(1,  sizeContactListAfter-sizeContactListBefore);

    }
    
    
    @isTest
    static void closePopupTest(){
        AccountsListContoller contr = new AccountsListContoller();
        Test.startTest();
        	contr.closePopup();
        Test.stopTest();
        System.assertEquals(false,  contr.displayPopup);
    }
    
    @isTest
    static void showPopupTest(){
        AccountsListContoller contr = new AccountsListContoller();
        Test.startTest();
        	contr.showPopup();
        Test.stopTest();
        System.assertEquals(true,  contr.displayPopup);
    }
    
    @isTest
    static void closePopupContactTest(){
        AccountsListContoller contr = new AccountsListContoller();
        Test.startTest();
        	contr.closePopupContact();
        Test.stopTest();
        System.assertEquals(false,  contr.displayPopUpContact);
    }
    
    @isTest
    static void showPopupContactTest(){
        AccountsListContoller contr = new AccountsListContoller();
        Test.startTest();
        	contr.showPopupContact();
        Test.stopTest();
        System.assertEquals(true,  contr.displayPopUpContact);
    }
    
    @isTest
    static void isEditTest(){
        AccountsListContoller contr = new AccountsListContoller();
        System.assertEquals(false,  contr.isEdit);
    }
    
}