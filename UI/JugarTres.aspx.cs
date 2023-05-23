using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class JugarTres : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtJugador.Focus();
            lblPuntaje.Text = Session["PuntajeFinal"].ToString();
        }
    }

    protected void btnFinalizar_Click(object sender, EventArgs e)
    {
        try
        {
            Juego juego = (Juego)Session["JuegoSeleccionado"];
            int puntajeFinal = (int)Session["PuntajeFinal"];
            string jugador = txtJugador.Text.Trim();
            Jugada jugada = null;

            jugada = new Jugada()
            {
                Jugador = jugador,
                PuntajeFinal = puntajeFinal,
                Juego = juego
            };

            new ServicioClient().AltaJugada(jugada);
            lblMensaje.Text = "Alta de jugada exitosa.";
            lblMensaje.CssClass = "alert alert-success";
            btnFinalizar.Enabled = false;
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
            lblMensaje.CssClass = "alert alert-warning";
        }
    }
}