using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Logica.Interfaces
{
    public interface ILogicaAsigna
    {
        void Asignar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario);
        void Quitar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario);
    }
}
