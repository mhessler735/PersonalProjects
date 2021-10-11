import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

public class GaussElim {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner sc = new Scanner(System.in);

        System.out.print("Number of linear Equations to Solve: ");
        int row = sc.nextInt();
        int col = row + 1;
        float[][] matrix = new float[0][0];

        System.out.print("Options:\n\t1. Enter Coefficients through command line" +
                "\n\t2. Enter name of file containing augmented coefficient matrix " +
                "\nSelect Option: ");


        boolean invalidInput = false;
        do {
            int choice = sc.nextInt();

            if (choice == 1) {
                matrix = enterCoef(row, col);
                invalidInput = false;
            } else if (choice == 2) {
                matrix = readFromFile(row, col);
                invalidInput = false;
            } else {
                invalidInput = true;
                System.out.print("Invalid Menu Option. \nSelect Option: ");
            }

        } while (invalidInput);

        displayMatrix(matrix, row, col);
        //getBvalues(matrix, row, col);
        gaussElim(matrix, row, col);
        backSub(matrix, row, col);


       /* int start = 0;
        float [] maxVal = findMaxVal(matrix, start,  row,  col);
        int pivotRow = findPivotRow(matrix,start, row, maxVal);
        System.out.println(Arrays.toString(maxVal));
        System.out.println(pivotRow);

        swapRows(matrix,pivotRow, start, col);
        for(float[] rowVals: matrix) {
            System.out.println(Arrays.toString(rowVals));
        }

        gaussElim(matrix, row, col);
        displayMatrix(sol, row, col); */
    }
    private static void getBvalues(float [][] matrix, int row, int col) {
        float b[] = new float[row];
        for (int i = 0; i < row; i++) {
            b[i] = matrix[i][col-1];

        }
        System.out.print(Arrays.toString(b) + " ");
    }
    private static void gaussElim(float[][] matrix, int row, int col) {
        float multiplier;
        int pivotRow;
        for (int start = 0; start < row - 1; start++) {
            float[] maxVal = findMaxVal(matrix, start, row, col);

            pivotRow = findPivotRow(matrix, start, row, maxVal);
            swapRows(matrix, pivotRow, start, col);

            for (int i = start +1; i < row; i++) {
                multiplier = matrix[i][start] / matrix[start][start];
                matrix[i][col-1] -= (multiplier * matrix[start][col-1]);
                for (int j = start; j < row; j++) {
                    matrix[i][j] -= (multiplier * matrix[start][j]);
                }
            }

            for (float[] rowVals : matrix) {
                System.out.println(Arrays.toString(rowVals));
            }
            System.out.println();
        }
    }
    public static void backSub(float[][] matrix, int row, int col){
        float total;
        float [] sol = new float[row];
        for (int i = row - 1; i >= 0; i--){
            total = 0;
            for (int j = i + 1; j < row; j++){
                total+= matrix[i][j] * sol[j];
            }
            sol[i] = (matrix[i][col-1] - total) / matrix[i][i];
            System.out.println("x" + (i+1) + " = " + sol[i]);
        }

    }

    private static float[] findMaxVal(float[][] matrix, int start, int row, int col) {
        float maxVal [] = new float[row];
        for(int i = start; i < row; i++) {
            for(int j = start; j < col -1; j++) {
                maxVal[i] = (Math.abs(matrix[i][j]) > Math.abs(maxVal[i])) ? Math.abs(matrix[i][j]) : maxVal[i];
            }
        }
        return maxVal;
    }

    private static int findPivotRow (float[][] matrix, int start, int row, float [] maxVal) {
        int pivotRow = start;
        for (int i = start; i < row; i++) {
            pivotRow = (matrix[i][start] / maxVal[i] > matrix[pivotRow][start] / maxVal[pivotRow]) ? i : pivotRow;
        }
        return pivotRow;
    }

    private static void swapRows(float[][] matrix, int pivotRow, int start, int col) {
        float temp;
        for(int i = start; i < col; i++) {
            temp = matrix[start][i];
            matrix[start][i] = matrix[pivotRow][i];
            matrix[pivotRow][i] = temp;
        }
    }

    public static float[][] enterCoef(int row, int col) {
        Scanner sc = new Scanner(System.in);
        float matrix[][] = new float[row][col];

        // Read the matrix values
        System.out.println("Enter the coefficients of the linear equations with the last element being b" +
                            "Separate the values with spaces: ");

        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                matrix[i][j] = sc.nextFloat();
            }
        }
        return matrix;
    }

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

    public static void displayMatrix(float [][] matrix, int row, int col) {
        System.out.println("Elements of the matrix are");
        for(float[] rowVals: matrix) {
            System.out.println(Arrays.toString(rowVals));
        }
        System.out.println();
    }
}




