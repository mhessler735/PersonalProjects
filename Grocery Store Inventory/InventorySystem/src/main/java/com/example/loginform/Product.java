package com.example.loginform;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

import javax.xml.transform.Result;
import java.sql.*;
import java.io.IOException;

public class Product {

    @FXML
    private TextField itemUPC;
    @FXML
    private Label itemNotFound, nameLabel, regularPriceLabel, effectivePriceLabel,  departmentLabel, sizeLabel;
    @FXML
    private Button Menu;

    @FXML
    public void onEnter(ActionEvent event){
        try{
            Integer.parseInt(itemUPC.getText());
            connectButton(event);
            itemUPC.requestFocus();

        } catch(Exception e){
            e.printStackTrace();
        }

    }

    public void connectButton(ActionEvent event){
       InventoryDataAccessor connectNow = new InventoryDataAccessor();
       Connection connectDB = connectNow.getConnection();
       String upc = itemUPC.getText();
       String connectQuery = "SELECT * FROM grocery_store_inventory_subsystem.product WHERE upc = " + upc;
       try {
           Statement statement = connectDB.createStatement();
           ResultSet queryOutput = statement.executeQuery(connectQuery);
           if(queryOutput.next()){
               nameLabel.setText(queryOutput.getString("name"));
               regularPriceLabel.setText(queryOutput.getString("regularPrice"));
               double regularPrice = Double.parseDouble(regularPriceLabel.getText());
               effectivePriceLabel.setText(queryOutput.getString("effectivePrice"));
               double effectivePrice = Double.parseDouble(effectivePriceLabel.getText());
               if (!(regularPrice == effectivePrice))
                   effectivePriceLabel.setTextFill(Color.web("#a40000"));
               else
                   effectivePriceLabel.setTextFill(Color.WHITE);
               departmentLabel.setText(queryOutput.getString("department"));
               sizeLabel.setText(queryOutput.getString("weight"));
               itemNotFound.setText("");
           } else{
               itemNotFound.setText("Item not found!");
           }
       } catch(Exception e) {
           e.printStackTrace();

       }
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