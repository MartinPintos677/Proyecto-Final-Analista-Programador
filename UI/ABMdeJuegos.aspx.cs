using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class ABMdeJuegos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            Limpio();
    }
    private void Limpio()
    {
        Session["Juego"] = null;
        btnBuscar.Enabled = true;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        btnModificar.Enabled = false;
        btnEliminar.Enabled = false;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        ddlDificultad.Enabled = false;
        txtCodigo.Enabled = true;
        txtCodigo.Text = string.Empty;
        txtCodigo.Focus();
        ddlDificultad.SelectedIndex = 0;        
        lblUsuario1.Text = string.Empty;
        lblUsuario.Text = string.Empty;
        lblFecha.Text = string.Empty;
        lblFecha1.Text = string.Empty;
    }

    private void BEncontrado()
    {
        btnBuscar.Enabled = false;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        btnEliminar.Enabled = true;
        btnModificar.Enabled = true;
        txtCodigo.Enabled = false;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        ddlDificultad.Enabled = true;
        Juego juego = (Juego)Session["Juego"];
        ddlDificultad.SelectedValue = juego.Dificultad;        
        lblFecha1.Text = "Fecha de creación:";
        lblUsuario1.Text = "Usuario:";
        lblFecha.Text = juego.FechaHora.ToString();
        lblUsuario.Text = juego.UsuarioAdmin.Nombre + " " + juego.UsuarioAdmin.Apellido;        
    }

    private void BNoEncontrado()
    {
        btnBuscar.Enabled = false;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = true;
        btnEliminar.Enabled = false;
        btnModificar.Enabled = false;
        txtCodigo.Enabled = true;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        ddlDificultad.Enabled = true;        
    }

    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];

            if (txtCodigo.Text.Trim() == string.Empty)
            {
                lblMensaje.Text = "Debe ingresar el código.";
                lblMensaje.CssClass = "alert alert-warning";
                txtCodigo.Focus();
            }
            else
            {
                int codigo = Convert.ToInt32(txtCodigo.Text.Trim());
                Juego juego = new ServicioClient().BuscarJuego(codigo, usuLog);

                if (juego != null)
                {
                    Session["Juego"] = juego;                    

                    BEncontrado();
                }
                else
                {
                    Session["Juego"] = null;

                    BNoEncontrado();
                }
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;            
        }
    }

    protected void btnLimpiar_Click(object sender, EventArgs e)
    {
        Limpio();
    }

    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin logueo = (UsuarioAdmin)Session["UsuarioMP"];
            Juego juego = null;
            List<Pregunta> preguntas = new List<Pregunta>();


            juego = new Juego()
            {
                Dificultad = ddlDificultad.SelectedValue,
                UsuarioAdmin = logueo,
                FechaHora = DateTime.Now,
                Preguntas = preguntas.ToArray()
            };

            new ServicioClient().AltaJuego(juego, logueo);
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

    protected void btnModificar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            Juego juego = (Juego)Session["Juego"];

            juego.Dificultad = ddlDificultad.SelectedValue;
            juego.UsuarioAdmin = usuLog;
            juego.FechaHora = DateTime.Now;

            new ServicioClient().ModificarJuego(juego, usuLog);

            Limpio();
            lblMensaje.Text = "Modificación exitosa.";
            lblMensaje.CssClass = "alert alert-success";
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;            
        }
    }

    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            Juego juego = (Juego)Session["Juego"];

            new ServicioClient().JuegoBaja(juego, usuLog);

            Limpio();
            lblMensaje.Text = "Eliminación exitosa.";
            lblMensaje.CssClass = "alert alert-success";
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
            lblMensaje.CssClass = "alert alert-warning";
        }
    }
}