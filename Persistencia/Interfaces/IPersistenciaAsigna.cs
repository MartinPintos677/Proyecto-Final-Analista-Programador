using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Persistencia.Interfaces
{
    public interface IPersistenciaAsigna
    {
        void Asignar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario);
        void Quitar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario);
    }
}
