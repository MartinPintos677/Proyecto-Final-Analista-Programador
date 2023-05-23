using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Persistencia.Interfaces
{
    public interface IPersistenciaUsuarioAdmin
    {
        void UsuarioAlta(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        void UsuarioModificar(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        void UsuarioBaja(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        UsuarioAdmin BuscarUsuarioActivo(string logueo, UsuarioAdmin usuLog);
        UsuarioAdmin Login(string logueo, string password);
    }
}
