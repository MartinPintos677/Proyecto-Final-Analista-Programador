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
    internal class LogicaJugada : ILogicaJugada
    {
        private static LogicaJugada _instancia = null;

        private LogicaJugada() { }

        public static LogicaJugada GetInstancia()
        {
            if (_instancia == null)
                _instancia = new LogicaJugada();

            return _instancia;
        }
        public void AltaJugada(Jugada J)
        {
            FabricaPersistencia.IPJugada().AltaJugada(J);
        }
        public List<Jugada> ListaJugadas()
        {
            return FabricaPersistencia.IPJugada().ListaJugadas();
        }
    }
}
