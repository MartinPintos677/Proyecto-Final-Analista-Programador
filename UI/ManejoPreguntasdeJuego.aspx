<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ManejoPreguntasdeJuego.aspx.cs" Inherits="ManejoPreguntasdeJuego" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            height: 24px;
        }
        .auto-style7 {
            text-align: center;
            font-size: xx-large;
            color: #009933;    
        }
    .auto-style8 {
        height: 24px;
        width: 662px;
    }
    .auto-style9 {
            width: 662px;
        }
    .auto-style10 {
            text-align: right;
            width: 662px;
        }
        .auto-style11 {
            font-size: x-large;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table style="width:100%;">
        <tr>
            <td class="auto-style8"></td>
            <td class="auto-style6"></td>
            <td class="auto-style6"></td>
        </tr>
        <tr>
            <td class="auto-style7" colspan="3"><strong>Manejo de preguntas de un juego</strong></td>
        </tr>
        <tr>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style9">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10"><strong>Buscar juego:</strong></td>
            <td>&nbsp;<asp:TextBox ID="txtBuscar" runat="server" Width="139px" MaxLength="4"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-dark" Text="Buscar" OnClick="btnBuscar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" BorderColor="Black" BorderWidth="1px" CssClass="btn btn-light" Text="Limpiar" OnClick="btnLimpiar_Click" />
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td><strong>
                <asp:Label ID="lblPreguntasdeJuego" runat="server" ForeColor="#1C5E55" CssClass="auto-style11"></asp:Label>
                </strong></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10">&nbsp;</td>
            <td class="text-center">
                <asp:GridView ID="grvPreguntas" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" OnSelectedIndexChanged="grvPreguntas_SelectedIndexChanged">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:CommandField SelectText="Quitar" ShowSelectButton="True" />
                        <asp:BoundField DataField="PuntajePregunta" HeaderText="Puntaje" />
                        <asp:BoundField DataField="Texto" HeaderText="Texto" />
                    </Columns>
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
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style10"><strong>Agregar pregunta:</strong></td>
            <td>
                &nbsp;<asp:TextBox ID="txtAgregar" runat="server" Width="139px" MaxLength="5"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnAgregar" runat="server" CssClass="btn btn-success" Text="Agregar" OnClick="btnAgregar_Click" BorderColor="Black" BorderWidth="2px" />
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
            <td colspan="2">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Content>

