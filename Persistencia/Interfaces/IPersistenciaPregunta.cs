using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Persistencia.Interfaces
{
    public interface IPersistenciaPregunta
    {
        void AltaPregunta(Pregunta pregunta, UsuarioAdmin usuario);
        List<Pregunta> PreguntasNuncaUsadas(UsuarioAdmin usuLog);
        Pregunta BuscarPregunta(string codigo, UsuarioAdmin usuLog);        
    }
}
