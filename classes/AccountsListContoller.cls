public with sharing class AccountsListContoller {
    public List<wrapAccount> wrapAccountList {get; set;}
    public List<Account> selectedAccounts{get;set;}
    public boolean displayPopup {get; set;}
    public boolean displayPopUpContact{get;set;}
    public Boolean isEdit {set; get{ if(isEdit==null){ isEdit=false;  }return isEdit;}}
    
    public AccountsListContoller(){
        if(wrapAccountList == null && CheckAccessRight.getwrapAccountListCRUDAccessAccessible() && CheckAccessRight.getwrapAccountListFLSAccessAccessible() && true) {
            wrapAccountList = new List<wrapAccount>();
            for(Account a: [SELECT Id, Name, Phone FROM Account LIMIT 1000]) {
                wrapAccountList.add(new wrapAccount(a));
                //system.debug(wrapAccountList);
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for view account'));     
        }
    } 
    
    public void deleteSelected() {
        if(!CheckAccessRight.getwrapAccountListCRUDAccessDeletable()){
            //object is not deletable
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for delete account'));
            return;
        }
        
        selectedAccounts = new List<Account>();
        
        for(wrapAccount wrapAccountObj : wrapAccountList) {
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
            //System.debug(wrapAccountList);
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error delete operation')); 
            //System.debug('Error delete operation');
        }
    }
    
    public void saveAccount() {
        if(CheckAccessRight.getwrapAccountListCRUDAccessCreateable() && CheckAccessRight.getwrapAccountListFLSAccessCreateable() && true){
            try {
                if (acct != null){
                    if(!isEdit){
                        insert acct; // inserts the new record into the database
                        wrapAccountList.add(new wrapAccount(acct));
                    }else{
                        update acct;
                        for(Integer i=0; i<wrapAccountList.size(); i++) {
                            if(wrapAccountList[i].acc.Id == acct.Id) {
                                wrapAccountList[i].acc = acct;
                            }
                        }
                        isEdit = false;
                    }
                    acct = null;  
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
    
    public void editAccount() {
        if(CheckAccessRight.getwrapAccountListCRUDAccessCreateable() && CheckAccessRight.getwrapAccountListFLSAccessCreateable() && true){
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
    
    
    public void addContact(){
        displayPopUpContact = true;    
        Id accountId = ApexPages.currentPage().getParameters().get('accIdForContact');
        cont.accountId = accountId;
    }
    
    public void saveContact(){
        if(CheckAccessRight.getwrapContactListCRUDAccessCreateable() && CheckAccessRight.getwrapContactListFLSAccessCreateable() && true){
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
    public class wrapAccount {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        public List<Contact> contactsList {get; set;}
        public Boolean isContacts{get; set;}
        
        
        public wrapAccount(Account a) {
            acc = a;
            selected = false;
            contactsList = new List<Contact>();
            if(CheckAccessRight.getwrapContactListCRUDAccessAccessible() && CheckAccessRight.getwrapContactListFLSAccessAccessible() && true){
                contactsList = [SELECT Id, Name, Phone, Title FROM Contact WHERE accountId =: a.Id LIMIT 1000];
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not permission for view contacts'));     
            }
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