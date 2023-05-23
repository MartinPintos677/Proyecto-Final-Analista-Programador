using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;
using Persistencia;
using Logica.Interfaces;

namespace Logica.Clases
{
    internal class LogicaUsuarioAdmin : IlogicaUsuarioAdmin
    {
        private static LogicaUsuarioAdmin _instancia = null;

        private LogicaUsuarioAdmin() { }

        public static LogicaUsuarioAdmin GetInstancia()
        {
            if (_instancia == null)
                _instancia = new LogicaUsuarioAdmin();

            return _instancia;
        }
        public void UsuarioAlta(UsuarioAdmin usuario,  UsuarioAdmin usuLog) // void UsuarioAlta(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        {
            FabricaPersistencia.IPUsuarioAdmin().UsuarioAlta(usuario, usuLog);
        }
        public void UsuarioBaja(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            FabricaPersistencia.IPUsuarioAdmin().UsuarioBaja(usuario, usuLog);
        }
        public void UsuarioModificar(UsuarioAdmin usuario, UsuarioAdmin UsuLog)
        {
            FabricaPersistencia.IPUsuarioAdmin().UsuarioModificar(usuario, UsuLog);
        }
        public UsuarioAdmin BuscarUsuarioActivo(string logueo, UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPUsuarioAdmin().BuscarUsuarioActivo(logueo, usuLog);
        }
        public UsuarioAdmin Login(string logueo, string password)
        {
            return FabricaPersistencia.IPUsuarioAdmin().Login(logueo, password);
        }
    }
}
