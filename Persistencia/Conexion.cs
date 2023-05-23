using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Persistencia
{
    internal class Conexion
    {
        internal static string Cnn(UsuarioAdmin usuario = null)
        {
            if (usuario == null)
                return "Data Source =localhost\\SQLEXPRESS; Initial Catalog = ProyectoFinal2; Integrated Security = true";
            else
                return "Data Source =localhost\\SQLEXPRESS; Initial Catalog = ProyectoFinal2; User=" + usuario.UsuarioLogueo + "; Password='" + usuario.Contrasena + "'";
        }
    }
}
