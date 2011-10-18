using System;
using System.IO;
using System.Text.RegularExpressions;

namespace ReplaceInFileUtility
{
    class Program
    {
        static string HelpText = @"Replaces text in a file.
ReplaceUtil.exe {filepath} {searchtext} {replacetext}

filePath - Path of the text file.
searchText - Text to search for.
replaceText - Text to replace the search text.
";

        static void Main(string[] args)
        {
            if (args.Length != 3)
            {
                Console.Write(HelpText);
				return;
            }
            Console.Write(ReplaceInFile(args[0], args[1], args[2]));
        }

        /// <summary>
        /// Replaces text in a file.
        /// </summary>
        /// <param name="filePath">Path of the text file.</param>
        /// <param name="searchText">Text to search for.</param>
        /// <param name="replaceText">Text to replace the search text.</param>
        static string ReplaceInFile(string filePath, string searchText, string replaceText)
        {
            string content;

            try
            {
                StreamReader reader = new StreamReader(filePath);
                content = reader.ReadToEnd();
                reader.Close();
            }
            catch (System.IO.FileNotFoundException)
            {
                return string.Format("File not found {0}", filePath);
            }
			catch (System.IO.DirectoryNotFoundException)
            {
                return string.Format("Directory not found {0}", filePath);
            }

            MatchCollection matches;
            try
            {
                matches = Regex.Matches(content, searchText);
                content = Regex.Replace(content, searchText, replaceText);
            }
            catch (System.ArgumentException)
            {
                return string.Format("Illegal character in arguments: {0} {1} \n", searchText, replaceText);
            }

            StreamWriter writer = new StreamWriter(filePath);
            writer.Write(content);
            writer.Close();

            if (matches.Count > 0)
                return string.Format("Found {0} occurences\n", matches.Count);
            else
                return string.Format("Found {0} occurences, search pattern was {1}\n", matches.Count, searchText);
        }
    }
}