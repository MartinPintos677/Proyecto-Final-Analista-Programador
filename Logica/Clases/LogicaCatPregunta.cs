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
    internal class LogicaCatPregunta : ILogicaCatPregunta
    {
        private static LogicaCatPregunta _instancia = null;

        private LogicaCatPregunta() { }

        public static LogicaCatPregunta GetInstancia()
        {
            if (_instancia == null)
                _instancia = new LogicaCatPregunta();

            return _instancia;
        }
        public CategoriaPregunta BuscarCategoriaActiva(string codigo, UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPCatPregunta().BuscarCategoriaActiva(codigo, usuLog);
        }
        public List<CategoriaPregunta> ListaCategorias(UsuarioAdmin usuLog)
        {
            return FabricaPersistencia.IPCatPregunta().ListaCategorias(usuLog);
        }
        public void AltaCategoria(CategoriaPregunta categoria, UsuarioAdmin logueo)
        {
            FabricaPersistencia.IPCatPregunta().AltaCategoria(categoria, logueo);
        }
        public void CategoriaModificar(CategoriaPregunta categoria, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPCatPregunta().CategoriaModificar(categoria, usuario);
        }
        public void CategoriaBaja(CategoriaPregunta categoria, UsuarioAdmin usuario)
        {
            FabricaPersistencia.IPCatPregunta().CategoriaBaja(categoria, usuario);
        }
    }
}
