<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Principal.aspx.cs" Inherits="Principal" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Content/bootstrap.css" rel="stylesheet"/> 
    <script src="Scripts/bootstrap.min.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Default</title>
    <style type="text/css">


strong {
  font-weight: bolder;
}

* {
  box-sizing: border-box;
}

body{
            background-color: white;
        }

        .auto-style1 {
            height: 34px;
            width: 374px;
            font-size: 33px;
            color: #2aca4f;
            text-shadow: 1px 1px #376f23;
            background-color: #333333;
        }
        .auto-style2 {
            width: 400px;
            height: 222px;
        }
        .auto-style3 {
            text-align: center;
            font-size: xx-large;
            color: #309c41;            
        }
        .auto-style4 {
            font-size: x-large;
            color: #333333;
        }
        .auto-style5 {
            color: #FFFFFF;
            font-size: 22px;
            background-color: #333333;
            margin-left: 660px;
        }
        .auto-style6 {
            margin-top: 0px;
        }
        .auto-style7 {
            height: 34px;
            width: 374px;
            font-size: 33px;
            color: #2aca4f;
            text-shadow: 1px 1px #376f23;
            background-color: #333333;
            text-align: center;            
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width:100%;">
                <tr>
                    <td class="auto-style1" colspan="3">
                        <div class="text-center">
                            <strong>¡Bienvenidos a Game Show!</strong>
                        </div>
                        </td>
                </tr>
                <tr>
                    <td class="auto-style7" colspan="3">
                        <asp:Menu ID="Menu1" runat="server" CssClass="auto-style5" Orientation="Horizontal">
                            <Items>
                                <asp:MenuItem Text="Jugar! |" Value="Jugar!" NavigateUrl="~/Jugar.aspx"></asp:MenuItem>
                                <asp:MenuItem Text="Iniciar Sessión" Value="Iniciar Sessión" NavigateUrl="~/Logueo.aspx"></asp:MenuItem>
                            </Items>
                            <StaticHoverStyle ForeColor="#00CCFF" />
                        </asp:Menu>
                        </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:Panel ID="Panel1" runat="server" BackColor="WhiteSmoke" BorderColor="Black" BorderWidth="2px" Height="170px" CssClass="auto-style6">
                            <div class="text-center">
                                <strong><span><span class="auto-style4">Filtrar jugadas por nombre de jugador, dificultad de juego o ambos</span></span><span class="auto-style21"><br /> </span>
                        <br />
                                </strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Jugador: </strong>
                                <asp:TextBox ID="txtJugador" runat="server" MaxLength="50"></asp:TextBox>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Dificultad de juego: </strong>
                                <asp:DropDownList ID="ddlDificultad" runat="server" CssClass="btn btn-dark">
                                    <asp:ListItem Value="0">&lt;Seleccione&gt;</asp:ListItem>
                                    <asp:ListItem Value="Facil">Fácil</asp:ListItem>
                                    <asp:ListItem Value="Medio">Medio</asp:ListItem>
                                    <asp:ListItem Value="Dificil">Difícil</asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnFiltrar" runat="server" CssClass="btn btn-success" Text="Filtrar" BorderColor="Black" BorderStyle="Groove" BorderWidth="2px" OnClick="btnFiltrar_Click" /> <br /><br />
                                <strong>&nbsp;&nbsp;&nbsp;Ordenar listado por dificultad y puntaje: <asp:Button ID="btnOrdenar" runat="server" BorderColor="Black" BorderStyle="Groove" BorderWidth="2px" CssClass="btn btn-primary" OnClick="btnOrdenar_Click" Text="Ordenar" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong><asp:Button ID="btnListaInicial" runat="server" BorderColor="Black" BorderStyle="Groove" BorderWidth="2px" CssClass="btn btn-info" OnClick="btnListaInicial_Click" Text="Listado Inicial" />
                                <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td class="text-center">
        <asp:Label ID="lblMensaje" runat="server" ForeColor="Red"></asp:Label>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td class="text-center">
                        <img alt="logo" class="auto-style2" longdesc="logo" src="img/Logo.png" /></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>        
                 
                <tr>                   
                    <td class="auto-style3" colspan="3"><strong>Listado de Jugadas   </strong>  </td>
                </tr>
                <tr>
                    <td colspan="3" class="text-center">
                        <asp:GridView ID="grvListaJugadas" runat="server" AutoGenerateColumns="False" CssClass="table table-hover">
                            <Columns>
                                <asp:BoundField DataField="FechaHora" HeaderText="Fecha" />
                                <asp:BoundField DataField="Jugador" HeaderText="Jugador" />
                                <asp:BoundField DataField="PuntajeFinal" HeaderText="Puntaje" />
                                <asp:BoundField DataField="Juego.Dificultad" HeaderText="Dificultad" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <p>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </p>
    </form>
</body>
</html>
