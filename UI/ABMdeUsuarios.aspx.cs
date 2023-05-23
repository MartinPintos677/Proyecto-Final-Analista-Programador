using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class ABMdeUsuarios : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            Limpio();
    }
    private void Limpio()
    {
        Session["UsuarioABM"] = null;
        btnBuscar.Enabled = true;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        btnModificar.Enabled = false;
        btnEliminar.Enabled = false;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        txtPass.Enabled = false;
        txtNombre.Enabled = false;
        txtApellido.Enabled = false;
        txtUsuLogueo.Enabled = true;
        txtNombre.Text = string.Empty;
        txtApellido.Text = string.Empty;
        txtPass.Text = string.Empty;
        txtUsuLogueo.Text = string.Empty;
        txtUsuLogueo.Focus();
    }

    private void BEncontrado()
    {
        btnBuscar.Enabled = false;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        btnEliminar.Enabled = true;
        btnModificar.Enabled = true;
        txtNombre.Enabled = true;
        txtApellido.Enabled = true;
        txtUsuLogueo.Enabled = false;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
    }

    private void BNoEncontrado()
    {
        btnBuscar.Enabled = false;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = true;
        btnEliminar.Enabled = false;
        btnModificar.Enabled = false;
        txtNombre.Enabled = true;
        txtApellido.Enabled = true;
        txtPass.Enabled = true;
        txtUsuLogueo.Enabled = true;
        txtNombre.Text = string.Empty;
        txtApellido.Text = string.Empty;
        txtPass.Text = string.Empty;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        txtPass.Focus();
    }

    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];

            if (txtUsuLogueo.Text.Trim() == string.Empty)
            {
                lblMensaje.Text = "Debe ingresar usuario de logueo.";
                lblMensaje.CssClass = "alert alert-warning";
                txtUsuLogueo.Focus();
            }
            else
            {
                UsuarioAdmin usuario = new ServicioClient().BuscarUsuarioActivo(txtUsuLogueo.Text.Trim(), usuLog);

                if (usuario != null)
                {
                    Session["UsuarioABM"] = usuario;

                    txtNombre.Text = usuario.Nombre;
                    txtApellido.Text = usuario.Apellido;

                    BEncontrado();

                    if (usuario.UsuarioLogueo == usuLog.UsuarioLogueo)
                        txtPass.Enabled = true;
                    else
                        txtPass.Enabled = false;
                }
                else
                {
                    Session["UsuarioABM"] = null;

                    BNoEncontrado();
                }
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
            lblMensaje.CssClass = "alert alert-warning";
        }
    }

    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            UsuarioAdmin usuario = null;

            usuario = new UsuarioAdmin()
            {
                UsuarioLogueo = txtUsuLogueo.Text.Trim(),
                Nombre = txtNombre.Text.Trim(),
                Apellido = txtApellido.Text.Trim(),
                Contrasena = txtPass.Text.Trim()
            };

            new ServicioClient().UsuarioAlta(usuario, usuLog);
            Limpio();
            lblMensaje.Text = "Alta exitosa.";
            lblMensaje.CssClass = "alert alert-success";
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
            lblMensaje.CssClass = "alert alert-warning";
        }
    }

    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            UsuarioAdmin usuario = (UsuarioAdmin)Session["UsuarioABM"];

            if (usuario.UsuarioLogueo == usuLog.UsuarioLogueo)
            {
                new ServicioClient().UsuarioBaja(usuario, usuLog);
                Response.Redirect("~/Principal.aspx");
            }
            else
            {
                new ServicioClient().UsuarioBaja(usuario, usuLog);
                Limpio();

                lblMensaje.Text = "Usuario eliminado.";
                lblMensaje.CssClass = "alert alert-success";
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
            lblMensaje.CssClass = "alert alert-warning";            
        }
    }

    protected void btnModificar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            UsuarioAdmin usuario = (UsuarioAdmin)Session["UsuarioABM"];

            usuario.Nombre = txtNombre.Text.Trim();
            usuario.Apellido = txtApellido.Text.Trim();

            if (usuario.UsuarioLogueo == usuLog.UsuarioLogueo)
                usuario.Contrasena = txtPass.Text.Trim();

            new ServicioClient().UsuarioModificar(usuario, usuLog);
            Limpio();

            lblMensaje.Text = "Modificación exitosa.";
            lblMensaje.CssClass = "alert alert-success";
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
            lblMensaje.CssClass = "alert alert-warning";
        }
    }

    protected void btnLimpiar_Click(object sender, EventArgs e)
    {
        Limpio();
    }
}