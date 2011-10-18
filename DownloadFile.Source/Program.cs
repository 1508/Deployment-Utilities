namespace DownloadFile
{
    using System;
    using System.Net;

    /// <summary>
    /// The program.
    /// </summary>
    internal class Program
    {
        #region Constants and Fields

        /// <summary>
        /// The help text.
        /// </summary>
        private const string HelpText =
            @"Download file from web to disk.
DownloadFile.exe {urlpath} {file path} 

address - Url to file that is requested.
fileName - Location to save file.
";

        #endregion

        #region Public Methods

        /// <summary>
        /// Mains the specified args.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        public static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.Write(HelpText);
                return;
            }

            Console.Write(SaveWebFileToDisk(args[0], args[1]));
        }

        /// <summary>
        /// Download file from web to disk.
        /// </summary>
        /// <param name="address">
        /// Url to file to request.
        /// </param>
        /// <param name="fileName">
        /// Location to save file.
        /// </param>
        /// <returns>
        /// The result of the operation.
        /// </returns>
        public static string SaveWebFileToDisk(string address, string fileName)
        {
            try
            {
                var webClient = new WebClient();
                webClient.DownloadFile(address, fileName);
            }
            catch (WebException webException)
            {
                return string.Format("{0}", webException.Message);
            }
            catch (Exception exception)
            {
                return string.Format("Exception occurred: {0}", exception.Message);
            }

            return string.Format("Downloaded url\n{0} to \n{1}", address, fileName);
        }

        #endregion
    }
}