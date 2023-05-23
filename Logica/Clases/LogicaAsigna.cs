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
    internal class LogicaAsigna : ILogicaAsigna
    {
        private static LogicaAsigna _instancia = null;

        private LogicaAsigna() { }

        public static LogicaAsigna GetInstancia()
        {
            if (_instancia == null)
                _instancia = new LogicaAsigna();

            return _instancia;
        }
        public void Asignar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPAsigna().Asignar(pregunta, juego, usuario);
        }
        public void Quitar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPAsigna().Quitar(pregunta, juego, usuario);
        }
    }
}
