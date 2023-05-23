<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Logueo.aspx.cs" Inherits="Logueo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Content/bootstrap.css" rel="stylesheet"/> 
    <script src="Scripts/bootstrap.min.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">

        .auto-style3 {
            height: 34px;
            width: 374px;
            font-size: 33px;
            color: #2aca4f;
            text-shadow: 1px 1px #376f23;
            background-color: #333333;
            text-align: center;
        }             

        .auto-style5 {
            color: #FFFFFF;
            font-size: 22px;
            background-color: #333333;
            margin-left: 655px;
        }
        .auto-style6 {
            width: 667px;
            margin-left: 300px;
        }
        .auto-style7 {
            text-align: right;
            width: 667px;
            color: #6a6a6a;
        }
        .auto-style8 {
            width: 246px;
        }
        .auto-style9 {
            text-align: center;
            color: #6a6a6a;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width:100%;">
                <tr>
                    <td class="auto-style3" colspan="3"><strong>Inicio de Sessión</strong></td>
                </tr>
                <tr>
                    <td colspan="3" class="auto-style5">
                        <asp:Menu ID="Menu1" runat="server" CssClass="auto-style5" Orientation="Horizontal">
                            <Items>
                                <asp:MenuItem Text="Jugar! |" Value="Jugar!" NavigateUrl="~/Jugar.aspx"></asp:MenuItem>
                                <asp:MenuItem Text="Volver a Inicio" Value="Iniciar Sessión" NavigateUrl="~/Principal.aspx"></asp:MenuItem>
                            </Items>
                            <StaticHoverStyle ForeColor="#00CCFF" />
                        </asp:Menu>
                        </td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style7"><strong>Usuario:</strong></td>
                    <td class="auto-style8">
                        &nbsp;<asp:TextBox ID="txtUsuario" runat="server" MaxLength="20"></asp:TextBox>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">
                        &nbsp;</td>
                    <td>
                        <asp:Button ID="btnLogueo" runat="server" CssClass="btn btn-success" Text="Entrar" OnClick="btnLogueo_Click" BorderColor="Black" BorderWidth="2px" />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style7"><strong>Contraseña:</strong></td>
                    <td class="auto-style8">
                        &nbsp;<asp:TextBox ID="txtPass" runat="server" TextMode="Password" MaxLength="15"></asp:TextBox>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style7">&nbsp;</td>
                    <td class="auto-style8">
                        &nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style9" colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style9" colspan="3">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
