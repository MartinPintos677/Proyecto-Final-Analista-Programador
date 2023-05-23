using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class ManejoPreguntasdeJuego : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            Limpio();
    }
    private void Limpio()
    {
        Session["Juego"] = null;
        Session["PreguntasdeJuego"] = null;
        btnBuscar.Enabled = true;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        lblMensaje.Text = string.Empty;
        txtAgregar.Text = string.Empty;
        lblMensaje.CssClass = null;
        txtBuscar.Enabled = true;
        txtBuscar.Text = string.Empty;
        txtBuscar.Focus();
        lblPreguntasdeJuego.Text = string.Empty;
        lblPreguntasdeJuego.CssClass = null;
        grvPreguntas.DataSource = null;
        grvPreguntas.DataBind();
        txtAgregar.Enabled = false;
    }

    private void BEncontrado()
    {
        btnBuscar.Enabled = false;
        txtAgregar.Enabled = true;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = true;
        txtBuscar.Enabled = false;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        txtAgregar.Focus();
        lblPreguntasdeJuego.Text = "Listado de preguntas del juego seleccionado";
        Juego juego = (Juego)Session["Juego"];
        List<Pregunta> preguntas = juego.Preguntas.ToList();

        Session["PreguntasdeJuego"] = preguntas;
        grvPreguntas.DataSource = Session["PreguntasdeJuego"];
        grvPreguntas.DataBind();

        if (preguntas.Count == 0)
            lblPreguntasdeJuego.Text = "El juego no tiene preguntas asociadas.";
    }

    private void BNoEncontrado()
    {
        btnBuscar.Enabled = true;
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        txtBuscar.Enabled = true;
        lblMensaje.Text = "No existe juego con el código ingresado.";
        lblMensaje.CssClass = "alert alert-warning";
        lblPreguntasdeJuego.Text = string.Empty;
        lblPreguntasdeJuego.CssClass = null;
        grvPreguntas.DataSource = null;
        grvPreguntas.DataBind();
    }
    protected void CargoGrilla()
    {
        lblPreguntasdeJuego.Text = "Listado de preguntas del juego seleccionado";
        grvPreguntas.DataSource = Session["PreguntasdeJuego"];
        grvPreguntas.DataBind();
        btnAgregar.Enabled = true;
        grvPreguntas.SelectedIndex = -1;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
    }
    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];

            if (txtBuscar.Text.Trim() == string.Empty)
            {
                lblMensaje.Text = "Debe ingresar el código de juego.";
                txtBuscar.Focus();
            }
            else
            {
                int codigo = Convert.ToInt32(txtBuscar.Text.Trim());
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
            lblMensaje.CssClass = "alert alert-warning";
        }
    }

    protected void grvPreguntas_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            Juego juego = (Juego)Session["Juego"];
            List<Pregunta> preguntas = (List<Pregunta>)Session["PreguntasdeJuego"];
            Pregunta pregunta = ((List<Pregunta>)Session["PreguntasdeJuego"])[grvPreguntas.SelectedIndex];

            new ServicioClient().Quitar(pregunta, juego, usuLog);
            preguntas.Remove(pregunta);

            CargoGrilla();

            if (preguntas.Count == 0)
                lblPreguntasdeJuego.Text = "El juego no tiene preguntas asociadas.";
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
            string codPregunta = txtAgregar.Text.Trim();

            if (codPregunta != string.Empty)
            {
                UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
                Juego juego = (Juego)Session["Juego"];
                List<Pregunta> preguntas = (List<Pregunta>)Session["PreguntasdeJuego"];
                Pregunta pregunta = new ServicioClient().BuscarPregunta(codPregunta, usuLog);

                if (pregunta != null)
                {                    
                    bool repetido = preguntas.Where(u => u.Codigo == pregunta.Codigo).Any();

                    if (repetido)
                    {
                        lblMensaje.Text = "La pregunta indicada ya fue agregada a la lista.";
                        lblMensaje.CssClass = "alert alert-warning";                        
                    }
                    else
                    {
                        new ServicioClient().Asignar(pregunta, juego, usuLog);
                        preguntas.Add(pregunta);
                        CargoGrilla();
                    }
                }
                else
                {
                    lblMensaje.Text = "No existe pregunta con el código ingresado.";
                    lblMensaje.CssClass = "alert alert-warning";
                }
            }
            else
            {
                lblMensaje.Text = "Debe ingresar el código de pregunta.";
                lblMensaje.CssClass = "alert alert-warning";
                txtAgregar.Focus();
            }
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