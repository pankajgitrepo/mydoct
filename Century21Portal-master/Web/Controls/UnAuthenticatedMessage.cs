
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using Resources;

namespace mojoPortal.Web.UI
{
    public partial class UnAuthenticatedMessage : WebControl
    {
        
        private bool useRightSeparator = false;
        /// <summary>
        /// This property is deprecated. Instead to use mojoPortal.Web.Controls.SeparatorControl
        /// </summary>
        public bool UseRightSeparator
        {
            get { return useRightSeparator; }
            set { useRightSeparator = value; }
        }

        private bool renderAsListItem = false;
        public bool RenderAsListItem
        {
            get { return renderAsListItem; }
            set { renderAsListItem = value; }
        }

        private string listItemCSS = "topnavitem";
        public string ListItemCss
        {
            get { return listItemCSS; }
            set { listItemCSS = value; }
        }

        private bool useFirstLast = false;
        public bool UseFirstLast
        {
            get { return useFirstLast; }
            set { useFirstLast = value; }
        }

        private string firstLastFormat = string.Empty;
        /// <summary>
        /// allows using first and last name in the welcome message, the default value is "Signed in as: {0} {1}"
        /// the {0} is required and will be replaced by the first name and {1} will be replaced by the last name
        /// However this is only useful if first and last name are actually populated
        /// which it may not be if you have not required it on registration and there are existing users
        /// also requires setting UseFirstLast to true
        /// </summary>
        public string FirstLastFormat
        {
            get { return firstLastFormat; }
            set { firstLastFormat = value; }
        }

         

        private string overrideFormat = string.Empty;
        /// <summary>
        /// allows overriding the welcome message, the default value is "Signed in as: {0}"
        /// the {0} is required and will be replaced by the user name
        /// </summary>
        public string OverrideFormat
        {
            get { return overrideFormat; }
            set { overrideFormat = value; }
        }

        private bool wrapInAnchor = false;
        public bool WrapInAnchor
        {
            get { return wrapInAnchor; }
            set { wrapInAnchor = value; }
        }

        private bool wrapInProfileLink = false;
        public bool WrapInProfileLink
        {
            get { return wrapInProfileLink; }
            set { wrapInProfileLink = value; }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (HttpContext.Current == null)
            {
                writer.Write("[" + this.ID + "]");
                return;
            }

            DoRender(writer);
            
            
        }

        private void DoRender(HtmlTextWriter writer)
        {
            if (HttpContext.Current.Request.IsAuthenticated) { return; }

            writer.Write(" <span>" + Resource.UnAuthenticatedMessage + "</span>");
            
        }

    }
}