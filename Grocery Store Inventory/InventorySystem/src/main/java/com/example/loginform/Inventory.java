package com.example.loginform;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.sql.*;
import java.io.IOException;

/**
 * This class is where users  view inventory status and the quantity.
 * They also can change inventory by adding positive or negative values.
 */
public class Inventory {

    @FXML
    private Button button;
    @FXML
    private Label inventoryStatusLabel;
    @FXML
    private Label quantityLabel;
    @FXML
    private Label itemNotFoundlabel;
    @FXML
    private Label productNameLabel;
    @FXML
    private Label invalidFormat;
    @FXML
    private Label lastUpdatedBy;
    @FXML
    private TextField itemUPC;
    @FXML
    private TextField changeQuantity;

    @FXML
    public void onEnter(ActionEvent event) {
        try {
            Integer.parseInt(itemUPC.getText());
            if (connectButton(event))
                changeQuantity.requestFocus();
        }
        catch (NumberFormatException e) {
            itemNotFoundlabel.setText("Not a valid UPC format");
        }
    }

    @FXML
    public void onEnter1(ActionEvent event) {
        try {
            Integer.parseInt(itemUPC.getText());
            updateQuantity(event);
            itemUPC.requestFocus();
        }
        catch (NumberFormatException e) {
            invalidFormat.setText("Not a valid quantity type ");
        }
    }

    public boolean connectButton(ActionEvent event) {

        boolean itemExists = true;

        String upc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.inventory WHERE upc=" + upc;
        String connectQuery1 = "SELECT * FROM grocery_store_inventory_subsystem.product WHERE upc =" + upc;
        try {

            Statement statement = connectDB.createStatement();
            Statement statement1 = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            if (queryOutput.next()) {
                ResultSet queryOutput1 = statement1.executeQuery(connectQuery1);

                if (queryOutput1.next())
                    productNameLabel.setText(queryOutput1.getString("name"));

                inventoryStatusLabel.setText(queryOutput.getString("inventory_status"));
                quantityLabel.setText(queryOutput.getString("quantity"));
                itemNotFoundlabel.setText("");
                //String userWhoUpdated = getUsername(upc);
                lastUpdatedBy.setText(queryOutput.getString("session_id"));
                itemExists = true;
            } else if (!(queryOutput.next())) {
                itemNotFoundlabel.setText("Item Not Found");
                itemExists = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return itemExists;
    }

    public void updateQuantity(ActionEvent event) {

        String upc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();
        String stockStatus= "";

        try {
            int modifyQuantity = Integer.valueOf(changeQuantity.getText());
            int currentInventory = currentInventory(event);
            PreparedStatement updatedStatement = null;

            if((currentInventory + modifyQuantity < 0)) {
                updatedStatement = connectDB.prepareStatement("update grocery_store_inventory_subsystem.inventory"
                        + " set quantity=?, inventory_status=?, session_id =?"
                        + "where upc =" + upc);
                String zero = "0";
                updatedStatement.setString(1, zero);
            }
            else {
                updatedStatement = connectDB.prepareStatement("update grocery_store_inventory_subsystem.inventory"
                        + " set quantity=quantity+?, inventory_status=?, session_id =?"
                        + "where upc =" + upc);

                updatedStatement.setString(1, String.valueOf(modifyQuantity));
            }

            if ( (currentInventory + modifyQuantity) > 0) {
                stockStatus = "in stock";
            }
            else
                stockStatus = "out of stock";

            updatedStatement.setString(2, stockStatus);
            updatedStatement.setString(3, getSessionID());
            updatedStatement.executeUpdate();

           String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.inventory WHERE upc=" + upc;
            Statement statement = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            while (queryOutput.next()) {

                quantityLabel.setText(queryOutput.getString("quantity"));
                inventoryStatusLabel.setText(queryOutput.getString("inventory_status"));
                lastUpdatedBy.setText(queryOutput.getString("session_id"));
            }
            changeQuantity.clear();
            invalidFormat.setText("");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        getSessionID();
    }

    public int currentInventory(ActionEvent event) {

        int itemQuantity = 0;
        String upc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        try {
            String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.inventory WHERE upc=" + upc;
            Statement statement = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            while (queryOutput.next()) {
                itemQuantity = queryOutput.getInt("quantity");

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itemQuantity;
    }

    private String getSessionID() {
        String sessionID = null;
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        try {
            String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.last_update WHERE session_id=" + Login.sessionID;
            Statement statement = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            while (queryOutput.next()) {
                sessionID = queryOutput.getString("session_id");
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessionID;
    }


    public void returnToMenu(ActionEvent event) throws IOException {
        GroceryApp m = new GroceryApp();
        if(Login.positionID == 11) {
            m.changeScene("mainMenu.fxml");
        } else {
            m.changeScene("mainEmployeeMenu.fxml");
        }
    }
}