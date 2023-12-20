using System;
using System.IO;

namespace NCV
{
    class Program
    {
        static void Main()
        {
            string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);

            // Get all files (including shortcuts) from the desktop
            string[] filesOnDesktop = Directory.GetFiles(desktopPath, "*.*", SearchOption.TopDirectoryOnly);

            // Collect files and shortcuts information into a StringBuilder
            var fileInformation = new System.Text.StringBuilder();

            foreach (string file in filesOnDesktop)
            {
                string fileName = Path.GetFileName(file);
                fileInformation.AppendLine(fileName);
            }

            // You can also filter out specific file types or extensions if needed
            // For example, to get only shortcuts (.lnk files)
            string[] shortcutsOnDesktop = Directory.GetFiles(desktopPath, "*.lnk", SearchOption.TopDirectoryOnly);

            foreach (string shortcut in shortcutsOnDesktop)
            {
                string shortcutName = Path.GetFileName(shortcut);
                fileInformation.AppendLine(shortcutName);
            }

            // Save the collected information to a file
            string outputPath = Path.Combine(desktopPath, "DesktopFilesInfo.txt");

            try
            {
                File.WriteAllText(outputPath, fileInformation.ToString());
                //Console.WriteLine($"File information saved to: {outputPath}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error saving file information: {ex.Message}");
            }
        }
    }
}