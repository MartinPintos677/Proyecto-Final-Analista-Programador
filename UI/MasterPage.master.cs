using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!(Session["UsuarioMP"] is UsuarioAdmin))
        {
            Response.Redirect("~/Principal.aspx");
        }
    }
}
