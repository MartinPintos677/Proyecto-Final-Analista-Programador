using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Logica.Interfaces;
using Logica.Clases;

namespace Logica
{
    public class Fabrica
    {
        public static ILogicaCatPregunta ILCatPregunta()
        {
            return LogicaCatPregunta.GetInstancia();
        }

        public static ILogicaJuego ILJuego()
        {
            return LogicaJuego.GetInstancia();
        }

        public static ILogicaJugada ILJugada()
        {
            return LogicaJugada.GetInstancia();
        }
        public static IlogicaPregunta ILPregunta()
        {
            return LogicaPregunta.GetInstancia();
        }
        public static IlogicaUsuarioAdmin ILUsuarioAdmin()
        {
            return LogicaUsuarioAdmin.GetInstancia();
        }
        public static ILogicaAsigna ILAsigna()
        {
            return LogicaAsigna.GetInstancia();
        }
    }
}
