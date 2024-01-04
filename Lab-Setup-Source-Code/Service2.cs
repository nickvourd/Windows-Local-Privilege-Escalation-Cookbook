using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Service2
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            string filename = "process_log.txt";
            string tempfilename = "temp_process_log.txt";

            // Open file for appending
            StreamWriter fptr;
            try
            {
                fptr = File.AppendText(filename);
            }
            catch (Exception e)
            {
                Console.WriteLine("Cannot open file: " + e.Message);
                return;
            }

            // Get current time
            DateTime now = DateTime.Now;

            // Write timestamp to the file
            fptr.WriteLine("\nList of processes on the system");
            fptr.WriteLine("Timestamp: " + now.ToString());

            // Run system command to get all processes and save in a temporary file
            System.Diagnostics.Process.Start("CMD.exe", "/C tasklist > temp_process_log.txt").WaitForExit();

            // Append contents of temporary file to the log file
            try
            {
                using (StreamReader tempfptr = new StreamReader(tempfilename))
                {
                    string line;
                    while ((line = tempfptr.ReadLine()) != null)
                    {
                        fptr.WriteLine(line);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Cannot open temporary file: " + e.Message);
                return;
            }

            File.Delete(tempfilename);

            // Close file
            fptr.Close();

            Console.WriteLine("Data appended to " + filename);
        }

        protected override void OnStop()
        {

        }
    }
}
