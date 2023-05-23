<%@ Page Language="C#" AutoEventWireup="true" CodeFile="JugarDos.aspx.cs" Inherits="JugarDos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Content/bootstrap.css" rel="stylesheet"/> 
    <script src="Scripts/bootstrap.min.js"></script>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        .auto-style4 {
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
            margin-left: 622px;
        }

        * {
            box-sizing: border-box;
        }

        .auto-style6 {
            background-color: #333333;
        }

        .auto-style12 {
            color: #6a6a6a;
            font-size: large;
        }
        .auto-style13 {
            width: 594px;
        }
        .auto-style14 {
            width: 430px;
        }
        .auto-style15 {
            width: 430px;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width: 100%;">
                <tr>
                    <td class="auto-style4" colspan="3"><strong>Generar Jugada</strong></td>
                </tr>
                <tr>
                    <td colspan="3" class="auto-style6">
                        <asp:Menu ID="Menu1" runat="server" CssClass="auto-style5" Orientation="Horizontal">
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
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style14">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style14">
                        <strong>
                            <asp:Label ID="lblPregunta" runat="server" CssClass="auto-style12"></asp:Label>
                        </strong>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style15">
                        <asp:GridView ID="grvRespuestas" runat="server" AutoGenerateColumns="False" CssClass="table table-sm" OnSelectedIndexChanged="grvRespuestas_SelectedIndexChanged">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:BoundField DataField="Texto" HeaderText="Respuestas" />
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style14">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style14">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style14">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
