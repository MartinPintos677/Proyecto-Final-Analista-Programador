using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using EntidadesCompartidas;
using Logica;

namespace ServicioWCF
{
    // NOTA: puede usar el comando "Rename" del menú "Refactorizar" para cambiar el nombre de clase "Servicio" en el código, en svc y en el archivo de configuración a la vez.
    // NOTA: para iniciar el Cliente de prueba WCF para probar este servicio, seleccione Servicio.svc o Servicio.svc.cs en el Explorador de soluciones e inicie la depuración.
    public class Servicio : IServicio
    {
        // USUARIOADMIN //
       void IServicio.UsuarioAlta(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            Fabrica.ILUsuarioAdmin().UsuarioAlta(usuario, usuLog);
        }
        void IServicio.UsuarioBaja(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            Fabrica.ILUsuarioAdmin().UsuarioBaja(usuario, usuLog);
        }
        void IServicio.UsuarioModificar(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            Fabrica.ILUsuarioAdmin().UsuarioModificar(usuario, usuLog);
        }
        UsuarioAdmin IServicio.BuscarUsuarioActivo(string codigo, UsuarioAdmin usuLog)
        {
            return Fabrica.ILUsuarioAdmin().BuscarUsuarioActivo(codigo, usuLog);
        }
        UsuarioAdmin IServicio.Login(string codigo, string pass)
        {
            return Fabrica.ILUsuarioAdmin().Login(codigo, pass);
        }

        // JUEGO //
        void IServicio.AltaJuego(Juego juego, UsuarioAdmin usuario)
        {
            Fabrica.ILJuego().AltaJuego(juego, usuario);
        }
        void IServicio.ModificarJuego(Juego juego, UsuarioAdmin usuario)
        {
            Fabrica.ILJuego().ModificarJuego(juego, usuario);
        }
        void IServicio.JuegoBaja(Juego juego, UsuarioAdmin usuario)
        {
            Fabrica.ILJuego().JuegoBaja(juego, usuario);
        }
        Juego IServicio.BuscarJuego(int codigo, UsuarioAdmin usuario = null) // ???
        {
            return Fabrica.ILJuego().BuscarJuego(codigo, usuario);
        }
        List<Juego> IServicio.ListaJuegosinJugadaperoconPregunta(UsuarioAdmin usuLog)
        {
            return Fabrica.ILJuego().ListaJuegosinJugadaperoconPregunta(usuLog);
        }
        List<Juego> IServicio.JuegosconPreguntas()
        {
            return Fabrica.ILJuego().JuegosconPreguntas();
        }
        List<Juego> IServicio.JuegossinPreguntas(UsuarioAdmin usuLog)
        {
            return Fabrica.ILJuego().JuegossinPreguntas(usuLog);
        }

        // ASIGNA //
        void IServicio.Asignar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario)
        {
            Fabrica.ILAsigna().Asignar(pregunta, juego, usuario);
        }
        void IServicio.Quitar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario)
        {
            Fabrica.ILAsigna().Quitar(pregunta, juego, usuario);
        }

        // CATEGORIA DE PREGUNTA //
        void IServicio.AltaCategoria(CategoriaPregunta categoria, UsuarioAdmin logueo)
        {
            Fabrica.ILCatPregunta().AltaCategoria(categoria, logueo);
        }
        void IServicio.CategoriaModificar(CategoriaPregunta categoria, UsuarioAdmin logueo)
        {
            Fabrica.ILCatPregunta().CategoriaModificar(categoria, logueo);
        }
        void IServicio.CategoriaBaja(CategoriaPregunta categoria, UsuarioAdmin logueo)
        {
            Fabrica.ILCatPregunta().CategoriaBaja(categoria, logueo);
        }
        CategoriaPregunta IServicio.BuscarCategoriaActiva(string codigo, UsuarioAdmin usuario)
        {
            return Fabrica.ILCatPregunta().BuscarCategoriaActiva(codigo, usuario);
        }
        List<CategoriaPregunta> IServicio.ListaCategorias(UsuarioAdmin usuario)
        {
            return Fabrica.ILCatPregunta().ListaCategorias(usuario);
        }

        // JUGADAS //
        void IServicio.AltaJugada(Jugada J)
        {
            Fabrica.ILJugada().AltaJugada(J);
        }
        List<Jugada> IServicio.ListaJugadas()
        {
            return Fabrica.ILJugada().ListaJugadas();
        }

        // PREGUNTAS //
        void IServicio.AltaPregunta(Pregunta pregunta, UsuarioAdmin usuario)
        {
            Fabrica.ILPregunta().AltaPregunta(pregunta, usuario);
        }
        List<Pregunta> IServicio.PreguntasNuncaUsadas(UsuarioAdmin usuLog)
        {
            return Fabrica.ILPregunta().PreguntasNuncaUsadas(usuLog);
        }
        Pregunta IServicio.BuscarPregunta(string codigo, UsuarioAdmin usuLog)
        {
            return Fabrica.ILPregunta().BuscarPregunta(codigo, usuLog);
        }
    }
}
