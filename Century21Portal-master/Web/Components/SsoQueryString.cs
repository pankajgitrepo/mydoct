using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;

namespace mojoPortal.Web.Components
{
    public class SsoQueryString
    {
        public string TimeStamp { get; set; }
        public string PersonKey { get; set; }
        public string AccountId { get; set; }
        public string AssistantAccountId { get; set; }
        public string UserId { get; set; }
        public string OfficeKey { get; set; }
        public string CompanyId { get; set; }
        public string FirstName { get; set; }
        public string OfficeId { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string Country { get; set; }
        public string FullName { get; set; }
        public string OfficeName { get; set; }
        public string Access { get; set; }
        public string Md5Hash { get; set; }
        public string SessionId { get; set; }

        public SsoQueryString(NameValueCollection queryString)
        {
            if (!string.IsNullOrEmpty(queryString.Get("t")))
            {
                TimeStamp = queryString.Get("t");
            }
            if (!string.IsNullOrEmpty(queryString.Get("w")))
            {
                PersonKey = queryString.Get("w");
            }
            if (!string.IsNullOrEmpty(queryString.Get("a")))
            {
                AccountId = queryString.Get("a");
            }
            if (!string.IsNullOrEmpty(queryString.Get("aa")))
            {
                AssistantAccountId = queryString.Get("aa");
            }
            if (!string.IsNullOrEmpty(queryString.Get("x")))
            {
                UserId = queryString.Get("x");
            }
            if (!string.IsNullOrEmpty(queryString.Get("o")))
            {
                OfficeKey = queryString.Get("o");
            }
            if (!string.IsNullOrEmpty(queryString.Get("c")))
            {
                CompanyId = queryString.Get("c");
            }
            if (!string.IsNullOrEmpty(queryString.Get("f")))
            {
                FirstName = queryString.Get("f");
            }
            if (!string.IsNullOrEmpty(queryString.Get("s")))
            {
                OfficeId = queryString.Get("s");
            }
            if (!string.IsNullOrEmpty(queryString.Get("r1")))
            {
                Address1 = queryString.Get("r1");
            }
            if (!string.IsNullOrEmpty(queryString.Get("r2")))
            {
                Address2 = queryString.Get("r2");
            }
            if (!string.IsNullOrEmpty(queryString.Get("k")))
            {
                City = queryString.Get("k");
            }
            if (!string.IsNullOrEmpty(queryString.Get("p")))
            {
                State = queryString.Get("p");
            }
            if (!string.IsNullOrEmpty(queryString.Get("l")))
            {
                Zip = queryString.Get("l");
            }
            if (!string.IsNullOrEmpty(queryString.Get("m")))
            {
                Country = queryString.Get("m");
            }
            if (!string.IsNullOrEmpty(queryString.Get("n")))
            {
                FullName = queryString.Get("n");
            }
            if (!string.IsNullOrEmpty(queryString.Get("u")))
            {
                OfficeName = queryString.Get("u");
            }
            if (!string.IsNullOrEmpty(queryString.Get("y")))
            {
                Access = queryString.Get("y");
            }
            if (!string.IsNullOrEmpty(queryString.Get("z")))
            {
                Md5Hash = queryString.Get("z");
            }
            if (!string.IsNullOrEmpty(queryString.Get("sid")))
            {
                SessionId = queryString.Get("sid");
            }
        }
    }
}