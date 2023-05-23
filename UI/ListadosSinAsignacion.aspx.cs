using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class ListadosSinAsignacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];

            Session["A"] = new ServicioClient().ListaJuegosinJugadaperoconPregunta(usuLog);
            Session["B"] = new ServicioClient().PreguntasNuncaUsadas(usuLog);
            Session["C"] = new ServicioClient().JuegossinPreguntas(usuLog);
        }
    }
    private void Limpio()
    {
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
    }
    protected void btnSeleccionar_Click(object sender, EventArgs e)
    {
        try
        {
            if (rbtnJnoUsados.Checked)
            {
                grvListados.DataSource = Session["A"];
                grvListados.DataBind();
                Limpio();
            }
            else if (rbtnPregnoUsadas.Checked)
            {
                grvListados.DataSource = Session["B"];
                grvListados.DataBind();
                Limpio();
            }
            else if (rbtnJuegosVacios.Checked)
            {
                grvListados.DataSource = Session["C"];
                grvListados.DataBind();
                Limpio();
            }
            else
            {
                lblMensaje.Text = "Debe seleccionar una de las opciones.";
                lblMensaje.CssClass = "alert alert-warning";
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }
}