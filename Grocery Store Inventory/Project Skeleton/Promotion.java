public class Promotion{
    String description;
    String startDate; 
    String endDate; 

    /*method validates that manager = true; when called and assigns a start date and end date.
    Also, a short description must be added to describe the special.*/
    public static boolean create_Special(Boolean isManager){
        //if user is validated as manager then create_Special can be implemented.
        if (isManager == true){
        return true;
        }
        else if(isManager) == false){
            return false;
        }

        else{
            System.out.println("User does not have a valid employee ID");
        }

        return createSpecial;
    }
}