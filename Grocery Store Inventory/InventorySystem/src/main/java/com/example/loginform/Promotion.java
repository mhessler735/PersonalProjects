
package com.example.loginform;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

import java.sql.*;
import java.io.IOException;
import java.text.DecimalFormat;

public class Promotion {

    @FXML
    private Button priceButton;
    @FXML
    private Button revertPriceButton;
    @FXML
    private Label regularPriceLabel;
    @FXML
    private Label effectivePriceLabel;
    @FXML
    private Label itemNotFoundlabel;
    @FXML
    private Label productNameLabel;
    @FXML
    private TextField itemUPC;
    @FXML
    private TextField promoPrice;
    @FXML
    private Label invalidPrice;
    @FXML
    private Label priceUpdated;

    public void initialize() {
        priceButton.setDisable(true);
        revertPriceButton.setDisable(true);
    }

    @FXML
    public void onEnter(ActionEvent event) {
        try {
            Integer.parseInt(itemUPC.getText());
           if (checkIfUPCExists(event)) {
               priceUpdated.setText("");
               priceButton.setDisable(false);
               if (checkIfSpecialExists())
                   revertPriceButton.setDisable(false);
               promoPrice.requestFocus();
           }
        }
        catch (NumberFormatException e) {
            itemNotFoundlabel.setText("Not a valid UPC format");
        }
    }

    @FXML
    public void onEnter1(ActionEvent event) {
        priceButton.requestFocus();
    }

    @FXML
    public void onPress(ActionEvent event) {
        try {

            Integer.parseInt(itemUPC.getText());
            if (checkIfUPCExists(event)) {
                Double.parseDouble(promoPrice.getText());
                changePrice();
                itemUPC.requestFocus();
            }
            else if (!checkIfUPCExists(event))
                itemNotFoundlabel.setText("Item Not found");

        }
        catch (NumberFormatException e) {
            invalidPrice.setText("Not a valid price type ");
        }

    }
    @FXML
    public void revert(ActionEvent event) {
        try {
            Integer.parseInt(itemUPC.getText());
            if (checkIfUPCExists(event))
                revertPrice();
            itemUPC.requestFocus();
        }
        catch (NumberFormatException e) {
            invalidPrice.setText("Not a valid UPC format");
        }

    }


    public boolean checkIfUPCExists(ActionEvent event) {
        boolean itemExists = true;

        String upc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.product WHERE upc =" + upc;
        try {

            Statement statement = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            if (queryOutput.next()) {
                ResultSet queryOutput1 = statement.executeQuery(connectQuery);

                if (queryOutput1.next())
                    productNameLabel.setText(queryOutput1.getString("name"));

                regularPriceLabel.setText(queryOutput1.getString("regularPrice"));
                double regularPrice = Double.parseDouble(regularPriceLabel.getText());
                effectivePriceLabel.setText(queryOutput1.getString("effectivePrice"));
                double effectivePrice = Double.parseDouble(effectivePriceLabel.getText());
                if (!(regularPrice == effectivePrice))
                    effectivePriceLabel.setTextFill(Color.web("#a40000"));
                else
                    effectivePriceLabel.setTextFill(Color.WHITE);
                itemNotFoundlabel.setText("");
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

    public boolean checkIfSpecialExists() {

        boolean specialExists = true;

        String upc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();


        String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.managerpromo WHERE productUpc =" + upc;
        try {

            Statement statement = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            if (queryOutput.next()) {
                specialExists = true;
            } else if (!(queryOutput.next())) {
                specialExists = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return specialExists;
    }

    public void changePrice() {
        String productUpc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();


        String inputpromoPrice = promoPrice.getText();
        double promoPriceDouble = Double.parseDouble(inputpromoPrice);
        inputpromoPrice = String.format("%.2f", promoPriceDouble);
        PreparedStatement changeManagerPromo = null;
        try {
            if (checkIfSpecialExists()) {
                changeManagerPromo = connectDB.prepareStatement("update grocery_store_inventory_subsystem.managerpromo"
                        + " set promoPrice=?"
                        + "where productUpc =" + productUpc);
                changeManagerPromo.setString(1, (inputpromoPrice));

            }
            else if(!checkIfSpecialExists()) {
                changeManagerPromo = connectDB.prepareStatement("INSERT INTO grocery_store_inventory_subsystem.managerpromo(productUpc, promoPrice)"
                        + "VALUES (?, ?)");

                changeManagerPromo.setString(1, String.valueOf(productUpc));
                changeManagerPromo.setString(2, String.valueOf(inputpromoPrice));
            }

            changeManagerPromo.executeUpdate();
            PreparedStatement changeEffectivePrice = null;

            changeEffectivePrice = connectDB.prepareStatement("update grocery_store_inventory_subsystem.product"
                    + " set effectivePrice=?"
                    + "where upc =" + productUpc);
            changeEffectivePrice.setString(1, (inputpromoPrice));
            changeEffectivePrice.executeUpdate();

            promoPrice.clear();
            productNameLabel.setText("");
            regularPriceLabel.setText("");
            effectivePriceLabel.setText("");
            invalidPrice.setText("");
            priceUpdated.setText("Price Updated");
            itemUPC.requestFocus();
            initialize();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public void revertPrice() {
        String productUpc = itemUPC.getText();
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        String regPrice = null;
        PreparedStatement removeManagerPromo = null;
        try {
            String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.product WHERE upc=" + productUpc;
            Statement statement = connectDB.createStatement();
            ResultSet queryOutput = statement.executeQuery(connectQuery);

            while (queryOutput.next()) {
                regPrice = queryOutput.getString("regularPrice");
            }

            if (checkIfSpecialExists()) {
                String deleteRow = "DELETE FROM grocery_store_inventory_subsystem.managerpromo where productUpc =?" ;
                removeManagerPromo = connectDB.prepareStatement(deleteRow);
                removeManagerPromo.setString(1, productUpc);
                removeManagerPromo.execute();

            }

            PreparedStatement changeEffectivePrice = null;
            changeEffectivePrice = connectDB.prepareStatement("update grocery_store_inventory_subsystem.product"
                    + " set effectivePrice=?"
                    + "where upc =" + productUpc);
            changeEffectivePrice.setString(1, (regPrice));
            changeEffectivePrice.executeUpdate();
            
            promoPrice.clear();
            productNameLabel.setText("");
            regularPriceLabel.setText("");
            effectivePriceLabel.setText("");
            invalidPrice.setText("");
            priceUpdated.setText("Price Updated");
            itemUPC.requestFocus();
            initialize();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void returnToMenu(ActionEvent event) throws IOException {
        GroceryApp m = new GroceryApp();
        m.changeScene("mainMenu.fxml");
    }

}
