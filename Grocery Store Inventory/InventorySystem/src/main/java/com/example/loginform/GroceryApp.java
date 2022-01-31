package com.example.loginform;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import java.io.IOException;

/**
 * This is the main file where the application is started and the primary stage for the GUI
 * is initialized.
 */
public class GroceryApp extends Application {

    private static Stage stg;

    @Override
    public void start(Stage primaryStage) throws Exception{
        stg = primaryStage;
        primaryStage.setResizable(false);
        Parent root = FXMLLoader.load(getClass().getResource("loginPage.fxml"));
        //Parent root = FXMLLoader.load(getClass().getResource("mainMenu.fxml"));


        Scene scene = new Scene(root, 600, 400);
        primaryStage.setTitle("Inventory");

        root.requestFocus();
        primaryStage.setScene(scene);
        primaryStage.show();

    }

    public void changeScene(String fxml) throws IOException {
        Parent pane = FXMLLoader.load(getClass().getResource(fxml));
        stg.getScene().setRoot(pane);
    }

    public static void main(String[] args) {
        launch(args);
    }
}