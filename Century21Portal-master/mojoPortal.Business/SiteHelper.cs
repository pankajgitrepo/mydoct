using System;
using System.Collections.Specialized;
using System.IO;
using System.Text;

namespace mojoPortal.Business
{
    public class SiteHelper
    {
        public static string CalculateMd5Hash(string input)
        {
            // step 1, calculate MD5 hash from input
            var md5 = System.Security.Cryptography.MD5.Create();
            var inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
            var hash = md5.ComputeHash(inputBytes);

            // step 2, convert byte array to hex string
            var sb = new StringBuilder();
            foreach (byte h in hash)
            {
                sb.Append(h.ToString("x2"));
            }
            return sb.ToString();
        }

        public static void LogQueryStringParameters(string fileNameWithPath, NameValueCollection queryString, string addtionalParam = null) 
        {
            using (StreamWriter sw = File.AppendText(fileNameWithPath))
            {
                sw.WriteLine("----------------------" + "New record saved at: " + DateTime.Now + "----------------------" + Environment.NewLine);
                foreach (var key in queryString)
                {
                    string line = key + ":" + queryString[key.ToString()];
                    sw.WriteLine(line);
                }
                if (addtionalParam != null)
                {
                    sw.WriteLine(addtionalParam);
                }
            }
        }
    }
}
