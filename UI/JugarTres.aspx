<%@ Page Language="C#" AutoEventWireup="true" CodeFile="JugarTres.aspx.cs" Inherits="JugarTres" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Content/bootstrap.css" rel="stylesheet"/> 
    <script src="Scripts/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">


        * {
            box-sizing: border-box;
        }

        *,
*::before,
*::after {
  box-sizing: border-box;
}

b,
strong {
  font-weight: bolder;
}

        .auto-style5 {
            height: 34px;
            width: 374px;
            font-size: 33px;
            color: #2aca4f;
            text-shadow: 1px 1px #376f23;
            background-color: #333333;
            text-align: center;
        }
        .auto-style6 {
            color: #FFFFFF;
            font-size: 22px;
            background-color: #333333;
            margin-left: 622px;
        }
        .auto-style7 {
            background-color: #333333;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width:100%;">
                <tr>
                    <td class="auto-style5" colspan="3"><strong>Generar Jugada</strong></td>
                </tr>
                <tr>
                    <td colspan="3" class="auto-style7">
                        <asp:Menu ID="Menu1" runat="server" CssClass="auto-style6" Orientation="Horizontal">
                            <Items>
                                <asp:MenuItem Text="Volver a Inicio |" Value="Jugar!" NavigateUrl="~/Principal.aspx"></asp:MenuItem>
                                <asp:MenuItem Text="Iniciar Sessión" Value="Iniciar Sessión" NavigateUrl="~/Logueo.aspx"></asp:MenuItem>
                            </Items>
                            <StaticHoverStyle ForeColor="#00CCFF" />
                        </asp:Menu>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="text-end"><strong>Nombre del jugador:</strong></td>
                    <td>&nbsp;<asp:TextBox ID="txtJugador" runat="server" MaxLength="50"></asp:TextBox>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="text-end"><strong>Puntaje total:</strong></td>
                    <td>&nbsp;<strong><asp:Label ID="lblPuntaje" runat="server"></asp:Label>
                        </strong></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="text-end">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="text-end">&nbsp;</td>
                    <td>
                        <asp:Button ID="btnFinalizar" runat="server" CssClass="btn btn-success" OnClick="btnFinalizar_Click" Text="Finalizar" />
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="text-end">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="text-end">&nbsp;</td>
                    <td>
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
