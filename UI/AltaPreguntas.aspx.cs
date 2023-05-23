using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class AltaPreguntas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
                Session["ListCategorias"] = new ServicioClient().ListaCategorias(usuLog).ToList();
                ddlCategorias.DataSource = Session["ListCategorias"];
                ddlCategorias.DataValueField = "Codigo";
                ddlCategorias.DataTextField = "Nombre";
                ddlCategorias.DataBind();
                Limpiar();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = ex.Message;
            }
        }
    }
    private void Limpiar()
    {
        txtCodigo.Text = string.Empty;
        txtCodigo.Focus();
        txtPuntaje.Text = string.Empty;
        txtRespuesta1.Text = string.Empty;
        txtRespuesta2.Text = string.Empty;
        txtRespuesta3.Text = string.Empty;
        txtRespuesta4.Text = string.Empty;
        txtTextoPreg.Text = string.Empty;
        rbtnCorrecta.Checked = false;
        rbtnCorrecta2.Checked = false;
        rbtnCorrecta3.Checked = false;
        rbtnCorrecta4.Checked = false;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
    }

    protected void btnAlta_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            string codPregunta = txtCodigo.Text.Trim();
            int puntaje = Convert.ToInt32(txtPuntaje.Text.Trim());
            string textoPreg = txtTextoPreg.Text.Trim();
            CategoriaPregunta categoria = ((List<CategoriaPregunta>)Session["ListCategorias"])[ddlCategorias.SelectedIndex];
            List<Respuesta> respuestas = new List<Respuesta>();
            Pregunta pregunta = null;

            if (txtRespuesta1.Text != string.Empty)
            {
                bool correcta1 = false;
                if (rbtnCorrecta.Checked)
                    correcta1 = true;

                Respuesta respuesta1 = new Respuesta()
                {
                    Texto = txtRespuesta1.Text.Trim(),
                    Correcta = correcta1
                };
                respuestas.Add(respuesta1);
            }
            if (txtRespuesta2.Text != string.Empty)
            {
                bool correcta2 = false;
                if (rbtnCorrecta2.Checked)
                    correcta2 = true;

                Respuesta respuesta2 = new Respuesta()
                {
                    Texto = txtRespuesta2.Text.Trim(),
                    Correcta = correcta2
                };
                respuestas.Add(respuesta2);
            }
            if (txtRespuesta3.Text != string.Empty)
            {
                bool correcta3 = false;
                if (rbtnCorrecta3.Checked)
                    correcta3 = true;

                Respuesta respuesta3 = new Respuesta()
                {
                    Texto = txtRespuesta3.Text.Trim(),
                    Correcta = correcta3
                };
                respuestas.Add(respuesta3);
            }
            if (txtRespuesta4.Text != string.Empty)
            {
                bool correcta4 = false;
                if (rbtnCorrecta4.Checked)
                    correcta4 = true;

                Respuesta respuesta4 = new Respuesta()
                {
                    Texto = txtRespuesta4.Text.Trim(),
                    Correcta = correcta4
                };
                respuestas.Add(respuesta4);
            }

            bool correcto = respuestas.Where(r => r.Correcta).Any();

            if (correcto)
            {
                pregunta = new Pregunta()
                {
                    Codigo = codPregunta,
                    PuntajePregunta = puntaje,
                    Texto = textoPreg,
                    CategoriaPregunta = categoria,
                    Respuestas = respuestas.ToArray()
                };

                new ServicioClient().AltaPregunta(pregunta, usuLog);
                Limpiar();
                lblMensaje.Text = "Alta exitosa.";
                lblMensaje.CssClass = "alert alert-success";
            }
            else
            {
                lblMensaje.Text = "Debe seleccionar cual es la respuesta correcta.";
                lblMensaje.CssClass = "alert alert-warning";
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
        Limpiar();
    }
}