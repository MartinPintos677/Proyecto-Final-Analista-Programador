using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Persistencia.Interfaces;
using Persistencia.Clases;

namespace Persistencia
{
    public class FabricaPersistencia
    {
        public static IPersistenciaCatPregunta IPCatPregunta()
        {
            return PerCategoriaPregunta.GetInstancia();
        }

        public static IPersistenciaJuego IPJuego()
        {
            return PerJuego.GetInstancia();
        }

        public static IPersistenciaJugada IPJugada()
        {
            return PerJugada.GetInstancia();
        }
        public static IPersistenciaPregunta IPPregunta()
        {
            return PerPregunta.GetInstancia();
        }
        public static IPersistenciaUsuarioAdmin IPUsuarioAdmin()
        {
            return PerUsuarioAdmin.GetInstancia();
        }
        public static IPersistenciaAsigna IPAsigna()
        {
            return PerAsigna.GetInstancia();
        }
    }
}
