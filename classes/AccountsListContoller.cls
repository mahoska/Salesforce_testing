/**
 * Created by annaMahovskaya on 3/4/18.
 */
public with sharing class AccountsListContoller {
    public List<WrapAccount> wrapAccountList {get; set;}
    public List<Account> selectedAccounts{get; set;}
    public Boolean displayPopup {get; set;}
    public Boolean displayPopUpContact{get; set;}
    public Boolean isEdit {
        set; 
        get{ 
            if(isEdit == null){ 
                isEdit = false;  
            }
            return isEdit;
        }
    }
    
    //account security variable
    public  Boolean isAccessibleAccount{get;set;}
    public  Boolean isDeletableAccount{get;set;}
    public  Boolean isCreateableAccount{get;set;}
    public  Boolean isUpdateableAccount{get;set;}
    //contact security variable
    public  Boolean isAccessibleContact{get;set;}
    public  Boolean isCreateableContact{get;set;}
    
     /**
       * Public construct initialize security settings 
       * and call the method of generating a list of accounts and their contacts
    */ 
    public AccountsListContoller(){
        isAccessibleAccount = CheckAccessRight.getwrapAccountListCRUDAccessAccessible() && CheckAccessRight.getwrapAccountListFLSAccessAccessible();
        isDeletableAccount = CheckAccessRight.getwrapAccountListCRUDAccessDeletable();
        isCreateableAccount = CheckAccessRight.getwrapAccountListCRUDAccessCreateable() && CheckAccessRight.getwrapAccountListFLSAccessCreateable();
        isUpdateableAccount = CheckAccessRight.getwrapAccountListCRUDAccessUpdateable() && CheckAccessRight.getwrapAccountListFLSAccessUpdateable();
        isAccessibleContact = CheckAccessRight.getwrapContactListCRUDAccessAccessible() && CheckAccessRight.getwrapContactListFLSAccessAccessible();
        isCreateableContact = CheckAccessRight.getwrapContactListCRUDAccessCreateable() && CheckAccessRight.getwrapContactListFLSAccessCreateable();
        
        getwrapAccountList();
    }
    
    /**
       * Public void method 
       * reading the accounts from the database and wrapping them
    */ 
    public void getwrapAccountList(){
        if(wrapAccountList == null && isAccessibleAccount && true) {
            wrapAccountList = new List<WrapAccount>();
            for(Account a: [SELECT Id, Name, Phone, (SELECT Id, Name, Title, Phone FROM Contacts) contacts FROM Account LIMIT 1000]) {
                wrapAccountList.add(new WrapAccount(a,  a.contacts));
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for view account'));     
        }
    }
    
    /**
       * Public void method 
       * removes selected accounts from the database 
       * and from the list of accounts displayed on the page
    */ 
    public void deleteSelected() {
        if(!isDeletableAccount){
            //object is not deletable
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for delete account'));
            return;
        }
        
        selectedAccounts = new List<Account>();
        
        for(WrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
                selectedAccounts.add(wrapAccountObj.acc);
            }
        }
        try {
            delete selectedAccounts;
            for(Integer i=0; i<wrapAccountList.size(); i++) {
                if(wrapAccountList[i].selected == true) {
                    wrapAccountList.remove(i);
                    i--;
                }
            }
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error delete operation')); 
        }
    }
    
    /**
       * Public void method 
       * a new account entry in the database and a list of displayed accounts
    */ 
    public void addAccount() {
        if(isCreateableAccount && true){
            try {
                if (acct != null){
                    insert acct; // inserts the new record into the database
                    wrapAccountList.add(new WrapAccount(acct));
                    acct = null; 
                    //close popup 
                    displayPopup = false;      
                }  
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new account.')); 
            }
        }else{
            //object is not insert
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for insert account')); 
        }  
    }
    
     /**
       * Public void method 
       * update account in database and list of displayed accounts
    */ 
    public void editAccount(){
        try {
            if (acct != null && isEdit){
                update acct;
                for(Integer i=0; i<wrapAccountList.size(); i++) {
                    if(wrapAccountList[i].acc.Id == acct.Id) {
                        wrapAccountList[i].acc = acct;
                    }
                }
                //return settings save-popup
                isEdit = false;
            }
            acct = null;  
            //close popup
            displayPopup = false;                   
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating new account.')); 
        }
    }
    
     /**
       * Public void method 
       * сall the account edit window and fill it with data for editing
    */ 
    public void openPopupEditAccount() {
        if(isUpdateableAccount && true){
            Id editAccountId = ApexPages.currentPage().getParameters().get('accId');
            try {
                acct = [SELECT Name, Phone FROM Account WHERE Id =: editAccountId];   
                displayPopup = true;   
                isEdit = true;
            } catch(Exception e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }else{
            //object is not update
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for update account')); 
        }
    }
    
    /**
       * Public void method 
       * open the window for adding a contact and transfer it to the Id account
    */ 
    public void openPopupAddContact(){
        displayPopUpContact = true;    
        Id accountId = ApexPages.currentPage().getParameters().get('accIdForContact');
        cont.accountId = accountId;
    }
    
     /**
       * Public void method 
       * save a new contact to the database and update the display list
    */ 
    public void saveContact(){
        if(isCreateableContact && true){
            try {
                if (cont != null){
                    insert cont;
                    Id contId = cont.Id;
                    Contact c = [SELECT Id, Name, Title, Phone, FirstName, LastName, accountId FROM Contact WHERE Id =: contId];
                    cont = c;
                    for(Integer i=0; i<wrapAccountList.size(); i++) {
                        if(wrapAccountList[i].acc.Id == cont.accountId) {
                            wrapAccountList[i].contactsList.add(cont);
                            wrapAccountList[i].isContacts = true;
                        }
                    }
                }
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new contact.')); 
            }
        }else{
            //object is not insert
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for insert contact')); 
        }    
        cont = null;
        displayPopupContact = false;  
    }
    
    // This is our wrapper/container class contains object Account(with Contacts) and a Boolean value
    public class WrapAccount {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        public List<Contact> contactsList {get; set;}
        public Boolean isContacts{get; set;}
        
        
        public WrapAccount(Account a,  List<Contact>  contacts) {
            acc = a;
            selected = false;
            contactsList = new List<Contact>(contacts);
            isContacts = contactsList.size() !=0 ? true : false;
        }
        
        public WrapAccount(Account a){
            acc = a;
            selected = false;
            contactsList = new List<Contact>();
            isContacts = contactsList.size() !=0 ? true : false;
        }
    }
    
    public Account acct {
        get {
            if (acct == null)
                acct = new Account();
            return acct;
        }
        set;
    }
    
    public Contact cont {
        get {
            if (cont == null)
                cont = new Contact();
            return cont;
        }
        set;
    }
    
    
    public void closePopup() {        
        displayPopup = false;    
    } 
    
    public void showPopup() {        
        displayPopup = true;    
    }  
    
    public void closePopupContact() {        
        displayPopUpContact = false;    
    }  
    
    public void showPopupContact() {        
        displayPopUpContact = true;    
    }    
}