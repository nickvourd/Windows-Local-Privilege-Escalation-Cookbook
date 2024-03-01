using System;
using System.Diagnostics;
using System.IO;

namespace CustomDotNetApp
{
    class Program
    {
        static void Main(string[] args)
        {
            string username;
            string password;

            // Check if the provided credentials are correct
            if (Authenticate(username, password))
            {
                // Enumerate and print information about all processes
                string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                string outputFile = Path.Combine(desktopPath, "processes.txt");

                using (StreamWriter writer = new StreamWriter(outputFile))
                {
                    Process[] processes = Process.GetProcesses();
                    foreach (Process process in processes)
                    {
                        writer.WriteLine($"Process Name: {process.ProcessName}, PID: {process.Id}, Memory: {process.WorkingSet64} bytes");
                    }
                }

                Console.WriteLine($"Process list saved to {outputFile}");
            }
            else
            {
                Console.WriteLine("Authentication failed. Exiting...");
                Environment.Exit(1); // Exiting the application
            }
        }

        static bool Authenticate(string username, string password)
        {
            // Hardcoded authentication (for demonstration purposes only)
            if (username == "admin" && password == "password123")
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
