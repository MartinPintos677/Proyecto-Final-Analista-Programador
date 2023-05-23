<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Jugar.aspx.cs" Inherits="Jugar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Content/bootstrap.css" rel="stylesheet"/> 
    <script src="Scripts/bootstrap.min.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        .auto-style1 {
            background-color: #333333;
        }
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
            margin-left: 622px;
        }
        
* {
  box-sizing: border-box;
}

        .auto-style6 {
            width: 550px;
        }
        .auto-style7 {
            font-size: 20px;
            text-align: right;
            color: #6a6a6a;
             
        }
        .auto-style8 {
            width: 471px;
        }
        .auto-style9 {
            text-align: center;
            width: 471px;
        }
        .auto-style10 {
            font-size: 20px;
            text-align: center;
            color: #6a6a6a;
            text-shadow: 1px 1px #6a6a6a;            
        }

        .auto-style13 {
            width: 550px;
            height: 27px;
        }
        .auto-style14 {
            width: 471px;
            height: 27px;
        }
        .auto-style15 {
            height: 27px;
        }

        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width:100%;">
                <tr>
                    <td class="auto-style3" colspan="3"><strong>Generar Jugada</strong></td>
                </tr>
                <tr>
                    <td class="auto-style1" colspan="3">
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
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style10" colspan="3"></td>
                </tr>
                <tr>
                    <td class="auto-style7">
                        <strong>Seleccione un juego para empezar a jugar:  </strong>  </td>
                    <td class="auto-style9">
                        <asp:GridView ID="grvListaJuegos" runat="server" CssClass="table table-striped" OnSelectedIndexChanged="grvListaJuegos_SelectedIndexChanged">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style13"></td>
                    <td class="auto-style14">
                        &nbsp;</td>
                    <td class="auto-style15"></td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style9">
                        &nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">
                        <asp:Label ID="lblMensaje" runat="server" ForeColor="Red"></asp:Label>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">&nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">
                        &nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style8">
                        &nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
