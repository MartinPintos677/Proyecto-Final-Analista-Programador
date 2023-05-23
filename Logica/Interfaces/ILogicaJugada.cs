using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Logica.Interfaces
{
    public interface ILogicaJugada
    {
        void AltaJugada(Jugada J);
        List<Jugada> ListaJugadas();
    }
}
