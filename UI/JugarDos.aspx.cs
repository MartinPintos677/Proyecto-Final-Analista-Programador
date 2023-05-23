using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class JugarDos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                Juego juego = (Juego)Session["JuegoSeleccionado"];

                List<Pregunta> preguntas = juego.Preguntas.ToList();

                int position = 0;
                Session["Position"] = position;

                Pregunta pregunta = preguntas[0];                

                lblPregunta.Text = pregunta.Texto;
                List<Respuesta> respuestas = pregunta.Respuestas.ToList();
                Session["Respuestas"] = respuestas;

                grvRespuestas.DataSource = Session["Respuestas"];
                grvRespuestas.DataBind();

                int puntajeFinal = 0;
                Session["PuntajeFinal"] = puntajeFinal;
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }

    protected void grvRespuestas_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            int position = (int)Session["Position"];
            position = position + 1;
            Juego juego = (Juego)Session["JuegoSeleccionado"];
            List<Pregunta> preguntas = juego.Preguntas.ToList();
            int puntajeFinal = (int)Session["PuntajeFinal"];

            int puntaje = 0;

            Respuesta respuesta = ((List<Respuesta>)Session["Respuestas"])[grvRespuestas.SelectedIndex];

            Pregunta pregunta = null;

            if (preguntas.Count > position)
            {
                Pregunta preguntaPuntaje = preguntas[position - 1];
                pregunta = preguntas[position];
                lblPregunta.Text = pregunta.Texto;

                List<Respuesta> respuestas = pregunta.Respuestas.ToList();
                Session["Respuestas"] = respuestas;
                grvRespuestas.DataSource = Session["Respuestas"];
                grvRespuestas.DataBind();

                if (respuesta.Correcta)
                {
                    puntaje = preguntaPuntaje.PuntajePregunta;
                    puntajeFinal = puntajeFinal + puntaje;
                    lblMensaje.Text = "Puntaje actual: " + puntajeFinal;
                    lblMensaje.CssClass = "alert alert-primary";
                }
                else
                {
                    lblMensaje.Text = "Puntaje actual: " + puntajeFinal;
                    lblMensaje.CssClass = "alert alert-danger";
                }

                Session["PuntajeFinal"] = puntajeFinal;
                Session["Position"] = position;
            }
            else
            {
                pregunta = preguntas[position - 1];

                if (respuesta.Correcta)
                {
                    puntaje = pregunta.PuntajePregunta;
                    puntajeFinal = puntajeFinal + puntaje;
                }
                
                Session["PuntajeFinal"] = puntajeFinal;
                Response.Redirect("~/JugarTres.aspx");
            }
        }
        catch (Exception ex)
        {
            lblMensaje.Text = ex.Message;
        }
    }
}