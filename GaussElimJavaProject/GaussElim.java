import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

/**
 * Michael Hessler
 * CS 3010.02
 * 10/8/2021
 * Programming Project #1
 *
 * This program that will ask the user for the number of linear equations to solve
 *  using the the Gaussian elimination with Scaled Partial Pivoting method.
 * The user can choose to read the coefficients of the linear equations from a file
 * or enter them manually. They will also enter the b values for each equation.
 * The program will output the scaled ratios, the pivot row, and the intermediate matrix '
 * at each step. Then it will output the solutions to the linear equations
*/

public class GaussElim {

    /**
     * This is the main function that asks for user input and then runs the functions for
     * Gaussian Elimination
     * @param args none
     * @throws FileNotFoundException
     */
    public static void main(String[] args) throws FileNotFoundException {
        int row = 0;
        do {
            Scanner sc = new Scanner(System.in);
            System.out.print("Number of linear Equations to Solve: ");
            row = sc.nextInt();

            if (row < 0 || row > 10)
                System.out.println("Pick a number from 0-10");

        } while (row > 10 || row < 0);

        int col = row + 1;
        float[][] matrix = new float[0][0];

        System.out.print("Options:\n\t1. Enter Coefficients through command line" +
                "\n\t2. Enter name of file containing augmented coefficient matrix " +
                "\nSelect Option: ");


        boolean invalidInput = false;
        do {
            Scanner scan = new Scanner(System.in);
            String choice = scan.nextLine();

            if (choice.equals("1")) {
                matrix = enterCoef(row, col);
            } else if (choice.equals("2")) {
                matrix = readFromFile(row, col);
            } else {
                invalidInput = true;
                System.out.print("Invalid Menu Option. \nSelect Option: ");
            }

        } while (invalidInput);

        displayMatrix(matrix);
        gaussElimination(matrix, row, col);
        backSub(matrix, row, col);

    }

    /**
     * This function solves the system of linear equations using the steps
     * in gaussian elimination. This is where the intermediate matrices are printed.
     * @param matrix
     * @param row
     * @param col
     */
    private static void gaussElimination(float[][] matrix, int row, int col) {
        float mult;
        int pivotRow;
        for (int p = 0; p < row - 1; p++) {
            float[] maxVal = findMaxVal(matrix, p, row, col);

            pivotRow = findPivotRow(matrix, p, row, maxVal);
            System.out.println("\nPivot Row: " + (pivotRow + 1));
            swapRows(matrix, pivotRow, p, col);

            for (int i = p +1; i < row; i++) {
                mult = matrix[i][p] / matrix[p][p];
                matrix[i][col-1] -= (mult * matrix[p][col-1]);
                for (int j = p; j < row; j++) {
                    matrix[i][j] -= (mult * matrix[p][j]);
                }
            }
            displayMatrix(matrix);
        }
            System.out.println();
    }

    /**
     * This is where backsubstitution happens and the solutions for the linear equations is found
     * @param matrix
     * @param row
     * @param col
     */
    public static void backSub(float[][] matrix, int row, int col){
        float total;
        float [] sol = new float[row];
        for (int i = row - 1; i >= 0; i--){
            total = 0;
            for (int j = i + 1; j < row; j++){
                total+= matrix[i][j] * sol[j];
            }
            sol[i] = (matrix[i][col-1] - total) / matrix[i][i];
            System.out.println("x" + (i+1) + " = " + (Math.round(sol[i])));
        }
    }

    /**
     * This is used to find the largest value of each row to determine the pivot row.
     * @param matrix
     * @param p
     * @param row
     * @param col
     * @return maxVal - the maximum values at each ro
     */
    private static float[] findMaxVal(float[][] matrix, int p, int row, int col) {
        float maxVal [] = new float[row];
        for(int i = p; i < row; i++) {
            for(int j = p; j < col -1; j++) {
                maxVal[i] = (Math.abs(matrix[i][j]) > Math.abs(maxVal[i])) ? Math.abs(matrix[i][j]) : maxVal[i];
            }
        }
        return maxVal;
    }

    /**
     * This function finds the row that is going to be the next pivot equation
     * @param matrix
     * @param p
     * @param row
     * @param maxVal
     * @return pivotRow- this the row value that was select based on the scaled ratio to pivot the matrix.
     */
    private static int findPivotRow (float[][] matrix, int p, int row, float [] maxVal) {
        int pivotRow = p;
        System.out.print("Scaled Ratios: ");
        for (int i = p; i < row; i++) {
            System.out.print(Math.abs(matrix[i][p]) + "/" + Math.abs(maxVal[i]) + ", ");
            pivotRow = (Math.abs(matrix[i][p] / maxVal[i]) > Math.abs(matrix[pivotRow][p] / maxVal[pivotRow])) ? i : pivotRow;
        }
        return pivotRow;
    }

    /**
     * This function swaps the rows based on the selected pivot row
     * @param matrix
     * @param pivotRow
     * @param p
     * @param col
     */
    private static void swapRows(float[][] matrix, int pivotRow, int p, int col) {
        float temp;
        for(int i = p; i < col; i++) {
            temp = matrix[p][i];
            matrix[p][i] = matrix[pivotRow][i];
            matrix[pivotRow][i] = temp;
        }
    }

    /**
     * This function allos the user to enter the coefficients and b values for their linear equations
     * @param row
     * @param col
     * @return matrix
     */
    public static float[][] enterCoef(int row, int col) {
        Scanner sc = new Scanner(System.in);
        float matrix[][] = new float[row][col];

        System.out.println("Enter the coefficients of the linear equations with the last element being the b value.\n" +
                            "Separate the values with spaces: ");

        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                matrix[i][j] = sc.nextFloat();
            }
        }

        return matrix;
    }

    /**
     * This function reads the matrix from the file given by the user and stores it in matrix[][]
     * @param row
     * @param col
     * @return matrix
     * @throws FileNotFoundException
     */
    public static float[][] readFromFile(int row, int col) throws FileNotFoundException {
        Scanner sc = new Scanner(System.in);

        float [][] matrix = new float[row][col];

        System.out.println("Enter the filepath for the file containing the augmented coefficient matrix: ");
        String filePath = sc.nextLine();

        File file = new File(filePath);
        Scanner in = new Scanner(file);
        while(in.hasNextLine()) {
            for (int i=0; i<matrix.length; i++) {
                String[] line = in.nextLine().trim().split(" ");
                for (int j=0; j<line.length; j++) {
                    matrix[i][j] = Integer.parseInt(line[j]);
                }
            }
        }

        return matrix;
    }

    /**
     * This function displays the matrix using the Arrays class
     * @param matrix
     */
    public static void displayMatrix(float [][] matrix) {
        System.out.println("Elements of the matrix are");
        for(float[] rowVals: matrix) {
            System.out.println(Arrays.toString(rowVals));
        }
        System.out.println();
    }
}




