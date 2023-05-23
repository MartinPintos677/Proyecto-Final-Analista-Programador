using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using EntidadesCompartidas;

namespace ServicioWCF
{
    [ServiceContract]
    public interface IServicio
    {
        // USUARIOADMIN //
        [OperationContract]
        void UsuarioAlta(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        [OperationContract]
        void UsuarioModificar(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        [OperationContract]
        void UsuarioBaja(UsuarioAdmin usuario, UsuarioAdmin usuLog);
        [OperationContract]
        UsuarioAdmin BuscarUsuarioActivo(string logueo, UsuarioAdmin usuLog);
        [OperationContract]
        UsuarioAdmin Login(string logueo, string password);

        // JUEGO //
        [OperationContract]
        void AltaJuego(Juego juego, UsuarioAdmin usuario);
        [OperationContract]
        void ModificarJuego(Juego juego, UsuarioAdmin usuario);
        [OperationContract]
        Juego BuscarJuego(int codigo, UsuarioAdmin usu = null);
        [OperationContract]
        void JuegoBaja(Juego juego, UsuarioAdmin usuario);
        [OperationContract]
        List<Juego> ListaJuegosinJugadaperoconPregunta(UsuarioAdmin usuLog);
        [OperationContract]
        List<Juego> JuegosconPreguntas();
        [OperationContract]
        List<Juego> JuegossinPreguntas(UsuarioAdmin usuLog);

        // ASIGNA //
        [OperationContract]
        void Asignar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario);
        [OperationContract]
        void Quitar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario);

        // CATEGORIA DE PREGUNTA //
        [OperationContract]
        void AltaCategoria(CategoriaPregunta categoria, UsuarioAdmin logueo);
        [OperationContract]
        void CategoriaModificar(CategoriaPregunta categoria, UsuarioAdmin usuario);
        [OperationContract]
        void CategoriaBaja(CategoriaPregunta categoria, UsuarioAdmin usuario);
        [OperationContract]
        CategoriaPregunta BuscarCategoriaActiva(string codigo, UsuarioAdmin usuario);
        [OperationContract]
        List<CategoriaPregunta> ListaCategorias(UsuarioAdmin usuario);

        // JUGADAS //
        [OperationContract]
        void AltaJugada(Jugada J);
        [OperationContract]
        List<Jugada> ListaJugadas();

        // PREGUNTAS //
        [OperationContract]
        void AltaPregunta(Pregunta pregunta, UsuarioAdmin usuario);
        [OperationContract]
        List<Pregunta> PreguntasNuncaUsadas(UsuarioAdmin usuLog);
        [OperationContract]
        Pregunta BuscarPregunta(string codigo, UsuarioAdmin usuLog);
    }
}
