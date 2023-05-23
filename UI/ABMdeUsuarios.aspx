<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ABMdeUsuarios.aspx.cs" Inherits="ABMdeUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            text-align: center;
            font-size: xx-large;
            color: #009933;    
        }
        .auto-style7 {
            width: 670px;
        }
        .auto-style8 {
            text-align: right;
            width: 670px;
        }
        .auto-style9 {
            width: 316px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6" colspan="3"><strong>ABM de Usuarios</strong></td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Logueo:</strong></td>
            <td class="auto-style9">&nbsp;<asp:TextBox ID="txtUsuLogueo" runat="server" MaxLength="20"></asp:TextBox>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Contraseña:</strong></td>
            <td class="auto-style9">&nbsp;<asp:TextBox ID="txtPass" runat="server" TextMode="Password" MaxLength="15"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-dark" OnClick="btnBuscar_Click" Text="Buscar" />
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Nombre:</strong></td>
            <td class="auto-style9">&nbsp;<asp:TextBox ID="txtNombre" runat="server" MaxLength="50"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="btnLimpiar" runat="server" BorderColor="Black" BorderWidth="1px" CssClass="btn btn-light" Text="Limpiar" OnClick="btnLimpiar_Click" />
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Apellido:</strong></td>
            <td class="auto-style9">&nbsp;<asp:TextBox ID="txtApellido" runat="server" MaxLength="50"></asp:TextBox>
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
            <td class="auto-style9">
                <asp:Button ID="btnAgregar" runat="server" CssClass="btn btn-primary" OnClick="btnAgregar_Click" Text="Agregar" />
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
            <td class="auto-style9">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Content>

