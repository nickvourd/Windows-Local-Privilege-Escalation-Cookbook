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

namespace Service4
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            string filename = "xls_files_log.txt";
            string documentsPath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            string[] xlsFiles = Directory.GetFiles(documentsPath, "*.xls");

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
            fptr.WriteLine("\nList of .xls files in the Documents folder");
            fptr.WriteLine("Timestamp: " + now.ToString());

            // Write Excel file names to the log file
            foreach (string file in xlsFiles)
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
