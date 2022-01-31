package com.example.loginform;

import java.sql.Connection ;
import java.sql.DriverManager ;

/**
 * This class is used to access the SQL database that is hosted locally.
 */
public class InventoryDataAccessor {
    public Connection databaseLink;

    public Connection getConnection() {
        String databaseName = "grocery_store_inventory_subsystem";
        String databaseUser = "root";
        String databasePassword = "MYSQL3560!";
        String url = "jdbc:mysql://localhost:3306/" + databaseName;

        try{
            databaseLink = DriverManager.getConnection(url, databaseUser, databasePassword);


        } catch (Exception e) {
            System.out.println("Could not retrieve database records.");
            e.printStackTrace();
        }

        return databaseLink;
    }
}