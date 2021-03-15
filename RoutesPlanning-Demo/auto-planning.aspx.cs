using Ext.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RoutesPlanning_Demo
{
    public partial class auto_planning : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (pm.Checked == true)
            {
                X.Call("planificationOptimise");
            }
            else if (pm.Checked == false)
            {
                X.Call("planificationManuelle");
            }
        }
    }
}