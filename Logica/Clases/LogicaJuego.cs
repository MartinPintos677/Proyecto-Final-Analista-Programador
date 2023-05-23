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
    internal class LogicaJuego : ILogicaJuego
    {
        private static LogicaJuego _instancia = null;

        private LogicaJuego() { }

        public static LogicaJuego GetInstancia()
        {
            if (_instancia == null)
                _instancia = new LogicaJuego();

            return _instancia;
        }
        public void AltaJuego(Juego juego, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPJuego().AltaJuego(juego, usuario);
        }
        public void ModificarJuego(Juego juego, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPJuego().ModificarJuego(juego, usuario);
        }
        public Juego BuscarJuego(int codigo, UsuarioAdmin usu = null)
        {
            return FabricaPersistencia.IPJuego().BuscarJuego(codigo, usu);
        }
        public void JuegoBaja(Juego juego, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPJuego().JuegoBaja(juego, usuario);
        }
        public List<Juego> ListaJuegosinJugadaperoconPregunta(UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPJuego().ListaJuegosinJugadaperoconPregunta(usuLog);
        }
        public List<Juego> JuegosconPreguntas()
        {
            return FabricaPersistencia.IPJuego().JuegosconPreguntas();
        }
        public List<Juego> JuegossinPreguntas(UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPJuego().JuegossinPreguntas(usuLog);
        }
    }
}
