package com.example.loginform;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;

import java.io.IOException;

/**
 * This class is where the MENU GUI is displayed and the user
 * chooses which use case for the system they would like to run.
 */
public class Menu {

    @FXML
    private Button logout;
    @FXML
    private Button inventory;
    @FXML
    private Button product;
    @FXML
    private Button promo;
    @FXML
    private Label userfirstNameLabel;
    @FXML
    private Label sessionIDLabel;

    public void initialize() {
        userfirstNameLabel.setText(Login.userFirstName);
        sessionIDLabel.setText(Login.sessionID);
    }
    public void runInventory(ActionEvent event ) throws IOException {
        GroceryApp m = new GroceryApp();
        m.changeScene("inventoryPage.fxml");
    }

    public void userLogOut(ActionEvent event) throws IOException {
        GroceryApp m = new GroceryApp();
        m.changeScene("loginPage.fxml");
    }

    public void viewProductInfo(ActionEvent event) throws IOException {
        GroceryApp m = new GroceryApp();
        m.changeScene("ProductView.fxml");
    }

    public void runPromo(ActionEvent event) throws IOException {
        GroceryApp m = new GroceryApp();
        m.changeScene("promotionPage.fxml");
    }

}