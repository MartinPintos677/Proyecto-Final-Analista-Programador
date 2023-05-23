using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class Principal : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session["UsuarioMP"] = null;
            btnListaInicial.Enabled = false;

            if (!IsPostBack)
            {
                Session["ListaJugadas"] = new ServicioClient().ListaJugadas().ToList();

                grvListaJugadas.DataSource = Session["ListaJugadas"];
                grvListaJugadas.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }

    private void CargoGrilla()
    {
        grvListaJugadas.DataSource = Session["OtrasJugadas"];
        grvListaJugadas.DataBind();
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        btnListaInicial.Enabled = true;
    }

    protected void btnFiltrar_Click(object sender, EventArgs e)
    {
        try
        {
            string dificultad = "";
            string jugador = "";

            if (ddlDificultad.SelectedIndex > 0)
                dificultad = ddlDificultad.SelectedValue;

            if (txtJugador.Text.Trim() != string.Empty)
                jugador = txtJugador.Text.Trim();

            List<Jugada> jugadas = (List<Jugada>)Session["ListaJugadas"];

            if (txtJugador.Text.Trim() != string.Empty && ddlDificultad.SelectedIndex > 0)
            {
                List<Jugada> listaDosFiltros = (from unJ in jugadas
                                              where unJ.Jugador == jugador &&
                                              unJ.Juego.Dificultad == dificultad
                                              select unJ).ToList<Jugada>();

                Session["OtrasJugadas"] = listaDosFiltros;
                CargoGrilla();
            }
            else if (txtJugador.Text.Trim() != string.Empty && ddlDificultad.SelectedIndex == 0)
            {
                List<Jugada> porJugador = (from unJ in jugadas
                                           where unJ.Jugador == jugador
                                           select unJ).ToList<Jugada>();

                Session["OtrasJugadas"] = porJugador;
                CargoGrilla();
            }
            else if (txtJugador.Text.Trim() == string.Empty && ddlDificultad.SelectedIndex > 0)
            {
                List<Jugada> porDificultad = (from unJ in jugadas
                                              where unJ.Juego.Dificultad == dificultad
                                              select unJ).ToList<Jugada>();

                Session["OtrasJugadas"] = porDificultad;
                CargoGrilla();
            }
            else
            {
                Session["OtrasJugadas"] = null;
                grvListaJugadas.DataSource = Session["ListaJugadas"];
                grvListaJugadas.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }

    protected void btnOrdenar_Click(object sender, EventArgs e)
    {
        try
        {
            List<Jugada> jugadas = (List<Jugada>)Session["OtrasJugadas"];

            if (jugadas == null)
                jugadas = (List<Jugada>)Session["ListaJugadas"];

            List<Jugada> lista = (from unJ in jugadas
                                  orderby unJ.Juego.Dificultad,
                                  unJ.PuntajeFinal
                                  select unJ).ToList<Jugada>();

            Session["OtrasJugadas"] = lista;
            CargoGrilla();
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }

    protected void btnListaInicial_Click(object sender, EventArgs e)
    {
        Session["OtrasJugadas"] = null;
        grvListaJugadas.DataSource = Session["ListaJugadas"];
        grvListaJugadas.DataBind();
        btnListaInicial.Enabled = false;
    }
}