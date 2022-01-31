abstract class Account{
    
    String username;
    String password;
    int ID; 
    Boolean isManager; 
    //constructor that will be called by stocker and Manager instances.
    public Account(String username, String password, int ID, Boolean isManager){
        this.username = username;
        this.password = password;
        this.ID = ID; 
        this.isManager = isManager; 
    }
    //Method accepts username and passcode and compares these values with username and passcode in the database.
    public static boolean system_Log_In(String username, String passcode){
        boolean validEmployee = true;
        //returns true if username and passcode match. 
        if (validEmployee){
            return true;
        } else {
            return false;
        }
        

    }

}