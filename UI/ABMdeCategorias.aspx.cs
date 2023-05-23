using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RefWCF;

public partial class ABMdeCategorias : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            Limpio();
    }
    private void Limpio()
    {
        txtCodigo.Text = string.Empty;
        txtNombre.Text = string.Empty;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        btnLimpiar.Enabled = false;
        btnBuscar.Enabled = true;
        btnEliminar.Enabled = false;
        btnModificar.Enabled = false;
        btnBuscar.Enabled = true;
        btnAgregar.Enabled = false;
        txtCodigo.Enabled = true;
        txtNombre.Enabled = false;
        txtCodigo.Focus();
    }

    private void BEncontrado()
    {
        btnLimpiar.Enabled = true;
        btnAgregar.Enabled = false;
        btnModificar.Enabled = true;
        btnBuscar.Enabled = false;
        btnEliminar.Enabled = true;
        txtCodigo.Enabled = false;
        txtNombre.Enabled = true;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
    }

    private void BNoEncontrado()
    {
        btnLimpiar.Enabled = true;
        txtNombre.Text = string.Empty;
        btnBuscar.Enabled = false;
        btnAgregar.Enabled = true;
        btnEliminar.Enabled = false;
        btnModificar.Enabled = false;
        txtCodigo.Enabled = true;
        txtNombre.Enabled = true;
        lblMensaje.Text = string.Empty;
        lblMensaje.CssClass = null;
        txtNombre.Focus();
    }

    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];

            if (txtCodigo.Text.Trim() == string.Empty)
            {
                lblMensaje.Text = "Debe ingresar el código de Categoria.";
                lblMensaje.CssClass = "alert alert-warning";
                txtCodigo.Focus();
            }
            else
            {
                CategoriaPregunta categoria = new ServicioClient().BuscarCategoriaActiva(txtCodigo.Text.Trim(), usuLog);

                if (categoria != null)
                {
                    Session["Categoria"] = categoria;

                    txtNombre.Text = categoria.Nombre;

                    BEncontrado();
                }
                else
                {
                    Session["Categoria"] = null;

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

    protected void btnLimpiar_Click(object sender, EventArgs e)
    {
        Limpio();
    }

    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin logueo = (UsuarioAdmin)Session["UsuarioMP"];
            CategoriaPregunta categoria = null;

            categoria = new CategoriaPregunta()
            {
                Codigo = txtCodigo.Text.Trim(),
                Nombre = txtNombre.Text.Trim()
            };

            new ServicioClient().AltaCategoria(categoria, logueo);
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
            CategoriaPregunta categoria = (CategoriaPregunta)Session["Categoria"];

            categoria.Nombre = txtNombre.Text.Trim();

            new ServicioClient().CategoriaModificar(categoria, usuLog);

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

    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        {
            UsuarioAdmin usuLog = (UsuarioAdmin)Session["UsuarioMP"];
            CategoriaPregunta categoria = (CategoriaPregunta)Session["Categoria"];

            new ServicioClient().CategoriaBaja(categoria, usuLog);

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