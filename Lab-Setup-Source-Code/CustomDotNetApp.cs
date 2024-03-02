using System;
using System.IO;
using System.ServiceProcess;

namespace CustomDotNetApp
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            string username = "Adminstrator"; // Set your username
            string password = "Asa31904#!"; // Set your password

            // Check if the provided credentials are correct
            if (Authenticate(username, password))
            {
                // Enumerate and print information about all processes
                string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                string outputFile = Path.Combine(desktopPath, "processes.txt");

                using (StreamWriter writer = new StreamWriter(outputFile))
                {
                    System.Diagnostics.Process[] processes = System.Diagnostics.Process.GetProcesses();
                    foreach (System.Diagnostics.Process process in processes)
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

        protected override void OnStop()
        {
            // Clean up any resources if needed
        }

        private bool Authenticate(string username, string password)
        {
            // Hardcoded authentication (for demonstration purposes only)
            if (username == "Adminstrator" && password == "Asa31904#!")
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
