using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class Jugar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    { 
        try
        {
            Session["UsuarioMP"] = null;
            Session["OtrasJugadas"] = null;

            if (!IsPostBack)
            {
                List<Juego> listaJuegos = new ServicioClient().JuegosconPreguntas().ToList();

                List<object> juegos = (from unJ in listaJuegos
                                       select new
                                       {
                                           Fecha = unJ.FechaHora,
                                           Preguntas = unJ.Preguntas.Count(),
                                           Dificultad = unJ.Dificultad
                                       }).ToList<object>();

                Session["ListaJuegos"] = listaJuegos;

                grvListaJuegos.DataSource = juegos;
                grvListaJuegos.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }

    protected void grvListaJuegos_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {           
            Juego juego = ((List<Juego>)Session["ListaJuegos"])[grvListaJuegos.SelectedIndex];

            Session["JuegoSeleccionado"] = juego;

            Response.Redirect("~/JugarDos.aspx");            
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }    
}