using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;

namespace Persistencia.Interfaces
{
    public interface IPersistenciaJuego
    {
        void AltaJuego(Juego juego, UsuarioAdmin usuario);
        void ModificarJuego(Juego juego, UsuarioAdmin usuario);
        Juego BuscarJuego(int codigo, UsuarioAdmin usu = null);
        void JuegoBaja(Juego juego, UsuarioAdmin usuario);        
        List<Juego> ListaJuegosinJugadaperoconPregunta(UsuarioAdmin usuLog);
        List<Juego> JuegosconPreguntas();
        List<Juego> JuegossinPreguntas(UsuarioAdmin usuLog);
    }
}
