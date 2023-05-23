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
    internal class LogicaPregunta : IlogicaPregunta
    {
        private static LogicaPregunta _instancia = null;

        private LogicaPregunta() { }

        public static LogicaPregunta GetInstancia()
        {
            if (_instancia == null)
                _instancia = new LogicaPregunta();

            return _instancia;
        }
        public void AltaPregunta(Pregunta pregunta, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPPregunta().AltaPregunta(pregunta, usuario);
        }
        public List<Pregunta> PreguntasNuncaUsadas(UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPPregunta().PreguntasNuncaUsadas(usuLog);
        }
        public Pregunta BuscarPregunta(string codigo, UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPPregunta().BuscarPregunta(codigo, usuLog);
        }
    }
}
