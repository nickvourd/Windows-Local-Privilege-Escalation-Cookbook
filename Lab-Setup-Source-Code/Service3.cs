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
            string filename = "exe_files_log.txt";
            string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            string[] exeFiles = Directory.GetFiles(desktopPath, "*.exe");

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
            fptr.WriteLine("\nList of .exe files on the desktop");
            fptr.WriteLine("Timestamp: " + now.ToString());

            // Write executable file names to the log file
            foreach (string file in exeFiles)
            {
                fptr.WriteLine(file);
            }

            // Close file
            fptr.Close();

            Console.WriteLine("Data appended to " + filename);
        }

        protected override void OnStop()
        {

        }
    }
}
