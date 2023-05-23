using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Logica.Interfaces
{
    public interface IlogicaUsuarioAdmin
    {
        void UsuarioAlta(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        void UsuarioModificar(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        void UsuarioBaja(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        UsuarioAdmin BuscarUsuarioActivo(string logueo, UsuarioAdmin usuLog);
        UsuarioAdmin Login(string logueo, string password);
    }
}
