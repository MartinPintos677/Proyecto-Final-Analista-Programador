using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Persistencia.Interfaces
{
    public interface IPersistenciaJugada
    {
        void AltaJugada(Jugada J);
        List<Jugada> ListaJugadas();
    }
}
