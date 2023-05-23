<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AltaPreguntas.aspx.cs" Inherits="AltaPreguntas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            text-align: center;
            font-size: xx-large;
            color: #009933;   
        }
        .auto-style7 {
            width: 312px;
        }
        .auto-style8 {
            text-align: right;
            width: 312px;
        }
        .auto-style9 {
            text-align: right;
            width: 312px;
            height: 53px;
        }
        .auto-style10 {
            height: 53px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table style="width:100%;">
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6" colspan="3"><strong>Alta de Preguntas</strong></td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="text-center" colspan="3"><strong>Código (5 caracteres):</strong>&nbsp;<asp:TextBox ID="txtCodigo" runat="server" MaxLength="5" Width="100px"></asp:TextBox>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong>Categoría:</strong> <asp:DropDownList ID="ddlCategorias" runat="server" CssClass="btn btn-dark">
                </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong>Puntaje (del 1 al 10): </strong><asp:TextBox ID="txtPuntaje" runat="server" Width="100px" MaxLength="2"></asp:TextBox>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnLimpiar" runat="server" BorderColor="Black" BorderWidth="2px" CssClass="btn btn-info" Text="Limpiar" OnClick="btnLimpiar_Click" />
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Pregunta:</strong></td>
            <td colspan="2">&nbsp;<asp:TextBox ID="txtTextoPreg" runat="server" Height="80px" TextMode="MultiLine" Width="1000px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Respuesta 1:</strong></td>
            <td colspan="2">
                &nbsp;<asp:TextBox ID="txtRespuesta1" runat="server" MaxLength="100" Width="1000px"></asp:TextBox>
                <asp:RadioButton ID="rbtnCorrecta" runat="server" GroupName="Correctas" SkinID="rbtnCorrectas" Text="Correcta" />
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style9"><strong>Respuesta 2:</strong></td>
            <td colspan="2" class="auto-style10">
                &nbsp;<asp:TextBox ID="txtRespuesta2" runat="server" MaxLength="100" Width="1000px"></asp:TextBox>
                <asp:RadioButton ID="rbtnCorrecta2" runat="server" GroupName="Correctas" SkinID="rbtnCorrectas" Text="Correcta" />
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Respuesta 3:</strong></td>
            <td colspan="2">
                &nbsp;<asp:TextBox ID="txtRespuesta3" runat="server" MaxLength="100" Width="1000px"></asp:TextBox>
                <asp:RadioButton ID="rbtnCorrecta3" runat="server" GroupName="Correctas" SkinID="rbtnCorrectas" Text="Correcta" />
            </td>
        </tr>
        <tr>
            <td class="auto-style7">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8"><strong>Respuesta 4:</strong></td>
            <td colspan="2">
                &nbsp;<asp:TextBox ID="txtRespuesta4" runat="server" MaxLength="100" Width="1000px"></asp:TextBox>
                <asp:RadioButton ID="rbtnCorrecta4" runat="server" GroupName="Correctas" SkinID="rbtnCorrectas" Text="Correcta" />
            </td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td colspan="2">
                <asp:Button ID="btnAlta" runat="server" CssClass="btn btn-success" Text="Alta de Pregunta" BorderColor="Black" BorderWidth="2px" OnClick="btnAlta_Click" />
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td colspan="2">
                &nbsp;</td>
        </tr>
    </table>
</asp:Content>

