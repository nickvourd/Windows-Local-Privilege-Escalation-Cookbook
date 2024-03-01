import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class CustomJavaApp {

    public static void main(String[] args) {
        String username;
        String password;

        // Check if the provided credentials are correct
        if (authenticate(username, password)) {
            // Enumerate and print information about all processes
            String desktopPath = System.getProperty("user.home") + "/Desktop";
            String outputFile = desktopPath + "/processes.txt";

            try (PrintWriter writer = new PrintWriter(new FileWriter(new File(outputFile)))) {
                ProcessHandle.allProcesses().forEach(process -> {
                    writer.println("Process ID: " + process.pid() + ", Process Name: " + process.info().command().orElse("N/A"));
                });
                System.out.println("Process list saved to " + outputFile);
            } catch (IOException e) {
                System.err.println("Error writing to file: " + e.getMessage());
            }
        } else {
            System.out.println("Authentication failed. Exiting...");
            System.exit(1); // Exiting the application
        }
    }

    static boolean authenticate(String username, String password) {
        // Hardcoded authentication (for demonstration purposes only)
        return username.equals("admin") && password.equals("password123");
    }
}
