<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ABMdeJuegos.aspx.cs" Inherits="ABMdeJuegos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            text-align: center;
            font-size: xx-large;
            color: #009933;    
        }
    .auto-style7 {
        width: 661px;
    }
    .auto-style8 {
        text-align: right;
        width: 661px;
    }
    .auto-style9 {
        width: 294px;
    }
        .auto-style10 {
            text-align: right;
            width: 661px;
            height: 34px;
        }
        .auto-style11 {
            width: 294px;
            height: 34px;
        }
        .auto-style12 {
            height: 34px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table style="width:100%;">
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6" colspan="3"><strong>ABM de Juegos</strong></td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Buscar juego:</strong></td>
            <td class="auto-style9">&nbsp;<asp:TextBox ID="txtCodigo" runat="server" Width="139px" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-dark" Text="Buscar" OnClick="btnBuscar_Click" />
            </td>
        </tr>
        <tr>
            <td class="auto-style10"><strong>Dificultad:</strong></td>
            <td class="auto-style11">
                                <asp:DropDownList ID="ddlDificultad" runat="server" CssClass="btn btn-success">
                                    <asp:ListItem Value="0">&lt;Seleccione&gt;</asp:ListItem>
                                    <asp:ListItem Value="Facil">Fácil</asp:ListItem>
                                    <asp:ListItem Value="Medio">Medio</asp:ListItem>
                                    <asp:ListItem Value="Dificil">Difícil</asp:ListItem>
                                </asp:DropDownList>
                                </td>
            <td class="auto-style12">
                <asp:Button ID="btnLimpiar" runat="server" BorderColor="Black" BorderWidth="1px" CssClass="btn btn-light" Text="Limpiar" OnClick="btnLimpiar_Click" />
            </td>
        </tr>
        <tr>
            <td class="auto-style10"><strong>
                <asp:Label ID="lblFecha1" runat="server"></asp:Label>
                </strong></td>
            <td class="auto-style11">
                                &nbsp;<strong><asp:Label ID="lblFecha" runat="server" ForeColor="#1C5E55"></asp:Label>
                                </strong>
                                </td>
            <td class="auto-style12">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>
                <asp:Label ID="lblUsuario1" runat="server"></asp:Label>
                </strong></td>
            <td class="auto-style9">&nbsp;<strong><asp:Label ID="lblUsuario" runat="server" ForeColor="#1C5E55"></asp:Label>
                </strong></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td class="auto-style9">
                <asp:Button ID="btnAgregar" runat="server" CssClass="btn btn-primary" Text="Agregar" OnClick="btnAgregar_Click" />
                <asp:Button ID="btnModificar" runat="server" CssClass="btn btn-secondary" Text="Modificar" OnClick="btnModificar_Click" />
                <asp:Button ID="btnEliminar" runat="server" CssClass="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td colspan="2">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Content>

