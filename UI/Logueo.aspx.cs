using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class Logueo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Session["UsuarioMP"] = null;
        Session["OtrasJugadas"] = null;

        if (!IsPostBack)                    
            txtUsuario.Focus();                      
    }

    protected void btnLogueo_Click(object sender, EventArgs e)
    {
        try
        {
            string logueo = txtUsuario.Text.Trim();
            string pass = txtPass.Text.Trim();

            UsuarioAdmin usuario = new ServicioClient().Login(logueo, pass);

            if (usuario != null)
            {
                Session["UsuarioMP"] = usuario;
                Response.Redirect("~/Bienvenida.aspx"); 
            }
            else
            {
                lblMensaje.Text = "Usuario y/o contraseña incorrectos.";
                lblMensaje.CssClass = "alert alert-warning";
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;            
        }
    }
}