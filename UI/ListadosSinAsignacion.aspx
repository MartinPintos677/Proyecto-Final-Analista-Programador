<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ListadosSinAsignacion.aspx.cs" Inherits="ListadosSinAsignacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            text-align: center;
            font-size: xx-large;
            color: #009933;   
        }
    .auto-style7 {
        height: 24px;
    }
        .auto-style8 {
            width: 615px;
        }
        .auto-style9 {
            height: 24px;
            width: 615px;
        }
        .auto-style10 {
            text-align: right;
            width: 615px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table style="width:100%;">
        <tr>
            <td class="auto-style8">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6" colspan="3"><strong>Listados sin Asignación</strong></td>
        </tr>
        <tr>
            <td class="auto-style9"></td>
            <td class="auto-style7"></td>
            <td class="auto-style7"></td>
        </tr>
        <tr>
            <td class="text-center" colspan="3"><strong>Seleccione una opción:</strong>&nbsp;<asp:RadioButton ID="rbtnJnoUsados" runat="server" GroupName="cboxOpciones" Text="A. Juegos nunca usados" />
&nbsp;&nbsp;
                <asp:RadioButton ID="rbtnPregnoUsadas" runat="server" GroupName="cboxOpciones" Text="B. Preguntas nunca usadas" />
&nbsp;&nbsp;
                <asp:RadioButton ID="rbtnJuegosVacios" runat="server" GroupName="cboxOpciones" Text="C. Juegos vacíos" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnSeleccionar" runat="server" CssClass="btn btn-success" Text="Seleccionar" OnClick="btnSeleccionar_Click" BorderColor="Black" BorderWidth="2px" />
            </td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td class="text-center">
                <asp:GridView ID="grvListados" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
                    <AlternatingRowStyle BackColor="White" />
                    <EditRowStyle BackColor="#7C6F57" />
                    <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#E3EAEB" />
                    <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
                    <SortedAscendingCellStyle BackColor="#F8FAFA" />
                    <SortedAscendingHeaderStyle BackColor="#246B61" />
                    <SortedDescendingCellStyle BackColor="#D4DFE1" />
                    <SortedDescendingHeaderStyle BackColor="#15524A" />
                </asp:GridView>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td>
                &nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td>
                &nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td>
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Content>

