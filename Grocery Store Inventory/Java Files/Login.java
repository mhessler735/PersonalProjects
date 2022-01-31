package com.example.loginform;

import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.event.ActionEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.paint.Color;
import java.util.Random;

import java.io.IOException;
import java.sql.*;

/**
 * This class is used to login to the inventory app.
 */

public class  Login {
    public static String sessionID = null;
    public static int positionID = 0;
    public static String userFirstName = null;

    @FXML
    private Button button;
    @FXML
    private TextField username;
    @FXML
    private PasswordField password;
    @FXML
    private PasswordField employeeID;

    @FXML
    public void onEnter(ActionEvent ae) {
        password.requestFocus();
    }

    @FXML
    public void onEnter1(ActionEvent ae) throws IOException {
        userLogin(ae);
    }
    @FXML
    public void userLogin(ActionEvent event) throws IOException {
        checkLogin();
    }
    @FXML
    private AnchorPane anchorPane;



    private void checkLogin() throws IOException {
        GroceryApp m = new GroceryApp();

        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        String employeeUsername = username.getText();
        String employeePassword = password.getText();
        // String employeePositionID = employeeID.getText();

        try {
            PreparedStatement loginVerify = connectDB.prepareStatement("SELECT * FROM grocery_store_inventory_subsystem.employee WHERE username=?");

            loginVerify.setString(1, employeeUsername);


            loginVerify.setString(1, employeeUsername);

            ResultSet resultSet = loginVerify.executeQuery();

            if (!resultSet.isBeforeFirst()) {
                button.setText("User not found");
                button.setTextFill(Color.RED);

            } else {
                while (resultSet.next()) {
                    String retrievedPassword = resultSet.getString("password");
                    if (retrievedPassword.equals(employeePassword)) {

                        int employee_id = resultSet.getInt("employee_id");
                        recordLoginSession(employee_id);


                        positionID = resultSet.getInt("position_id");
                        userFirstName = resultSet.getString("first_name");
                        //String retrievedPositionID = resultSet.getString("position_id");
                        if (positionID == 11) {
                            m.changeScene("mainMenu.fxml");
                        } else if (positionID == 22){
                            m.changeScene("mainEmployeeMenu.fxml");
                        }

                        //m.changeScene("mainMenu.fxml");

                    } else {
                        button.setText("Incorrect Password");
                        button.setTextFill(Color.RED);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void recordLoginSession(int employee_id) throws SQLException {
        InventoryDataAccessor connectNow = new InventoryDataAccessor();
        Connection connectDB = connectNow.getConnection();

        PreparedStatement recordSessionInfo = null;
        String query = "INSERT INTO grocery_store_inventory_subsystem.last_update(session_id, employee_id)"
                + "VALUES (?, ?)";

        recordSessionInfo = connectDB.prepareStatement(query);
        Random rnd = new Random();

        sessionID = String.format("%06d", rnd.nextInt(999999));
        String query2 = "SELECT * FROM grocery_store_inventory_subsystem.last_update WHERE session_id=" + sessionID;
        Statement statement = connectDB.createStatement();
        ResultSet queryOutput = statement.executeQuery(query2);

        while(queryOutput.next()) {
            sessionID = String.format("%06d", rnd.nextInt(999999));
        }

        recordSessionInfo.setString (1, sessionID);
        recordSessionInfo.setInt (2, employee_id);
        recordSessionInfo.executeUpdate();
    }

}