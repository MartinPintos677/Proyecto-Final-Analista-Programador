using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;
using Persistencia.Interfaces;

namespace Persistencia.Clases
{
    internal class PerJuego : IPersistenciaJuego
    {
        private static PerJuego _instancia = null;

        private PerJuego() { }

        public static PerJuego GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerJuego();

            return _instancia;
        }
        public void AltaJuego(Juego juego, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("AltaJuego", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@dificultad", juego.Dificultad);
            _comando.Parameters.AddWithValue("@usuario", juego.UsuarioAdmin.UsuarioLogueo);
            
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();

                if ((int)_retorno.Value == -1)
                    throw new Exception("No existe el usuario en el sistema.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en alta de juego.");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
        }
        public void ModificarJuego(Juego juego, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("ModificarJuego", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", juego.Codigo);
            _comando.Parameters.AddWithValue("@dificultad", juego.Dificultad);
            _comando.Parameters.AddWithValue("@usuario", juego.UsuarioAdmin.UsuarioLogueo);

            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                if ((int)_retorno.Value == -1)
                    throw new Exception("No existe juego con el código indicado.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("No existe usuario con el código indicado.");
                else if ((int)_retorno.Value == -3)
                    throw new Exception("No se pudo modificar el juego.");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
        }
        
        public void JuegoBaja(Juego juego, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("BajaJuego", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", juego.Codigo);
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                if ((int)_retorno.Value == -1)
                    throw new Exception("No existe juego con el código indicado.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("No se puede eliminar juego con jugada asignada.");
                else if ((int)_retorno.Value == -3)
                    throw new Exception("Error, no se puedo eliminar el juego asignado a pregunta.");
                else if ((int)_retorno.Value == -4)
                    throw new Exception("Error, no se puedo eliminar el juego.");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
        }
        
        public List<Juego> ListaJuegosinJugadaperoconPregunta(UsuarioAdmin usuLog)
        {
            int _codigo;
            string _dificultad;
            DateTime _fechaHora;            
            List<Pregunta> _preguntas;
            string _logueo;

            Juego juego = null;

            List<Juego> _Lista = new List<Juego>();
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));
            SqlCommand _Comando = new SqlCommand("JuegosinJugadaperoconPregunta", _cnn);
            SqlDataReader _Reader;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                while (_Reader.Read())
                {
                    _logueo = (string)_Reader["UsuarioLogueo"];
                    usuLog = PerUsuarioAdmin.GetInstancia().BuscarUsuario(_logueo);

                    _codigo = (int)_Reader["Codigo"];
                    _dificultad = (string)_Reader["Dificultad"];
                    _fechaHora = (DateTime)_Reader["FechaHora"];

                    _preguntas = PerPregunta.GetInstancia().PreguntasdeJuego(_codigo);
                                        
                    juego = new Juego(_codigo, _dificultad, _fechaHora, usuLog, _preguntas); 
                    _Lista.Add(juego);
                }
                _Reader.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
            return _Lista;
        }
        public List<Juego> JuegosconPreguntas()
        {
            int _codigo;
            string _dificultad;
            DateTime _fechaHora;
            List<Pregunta> _preguntas;
            string _logueo;
            UsuarioAdmin usuario = null;

            Juego juego = null;

            List<Juego> _Lista = new List<Juego>();
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());
            SqlCommand _Comando = new SqlCommand("ListadoJuegosconPreguntas", _cnn);
            SqlDataReader _Reader;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                while (_Reader.Read())
                {
                    _codigo = (int)_Reader["Codigo"];
                    _logueo = (string)_Reader["UsuarioLogueo"];
                    usuario = PerUsuarioAdmin.GetInstancia().BuscarUsuario(_logueo);                    
                    _dificultad = (string)_Reader["Dificultad"];
                    _fechaHora = (DateTime)_Reader["FechaHora"];

                    _preguntas = PerPregunta.GetInstancia().PreguntasdeJuego(_codigo);

                    juego = new Juego(_codigo, _dificultad, _fechaHora, usuario, _preguntas);
                    _Lista.Add(juego);
                }
                _Reader.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
            return _Lista;
        }
        public List<Juego> JuegossinPreguntas(UsuarioAdmin usuLog)
        {
            int _codigo;
            string _dificultad;
            DateTime _fechaHora;
            List<Pregunta> _preguntas;
            string _logueo;
            UsuarioAdmin usuario = null;

            Juego juego = null;

            List<Juego> _Lista = new List<Juego>();
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));
            SqlCommand _Comando = new SqlCommand("JuegosinPregunta", _cnn);
            SqlDataReader _Reader;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                while (_Reader.Read())
                {
                    _logueo = (string)_Reader["UsuarioLogueo"];
                    usuario = PerUsuarioAdmin.GetInstancia().BuscarUsuario(_logueo);

                    _codigo = (int)_Reader["Codigo"];
                    _dificultad = (string)_Reader["Dificultad"];
                    _fechaHora = (DateTime)_Reader["FechaHora"];

                    _preguntas = PerPregunta.GetInstancia().PreguntasdeJuego(_codigo);

                    juego = new Juego(_codigo, _dificultad, _fechaHora, usuario, _preguntas);
                    _Lista.Add(juego);
                }
                _Reader.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
            return _Lista;
        }
        public Juego BuscarJuego(int codigo, UsuarioAdmin usu = null)
        {
            int _codigo;
            string _dificultad;
            DateTime _fechaHora;
            List<Pregunta> _preguntas;
            string _logueo;
            UsuarioAdmin usuario = null;

            Juego juego = null;
            
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usu));
            SqlCommand _Comando = new SqlCommand("BuscarJuego", _cnn);
            _Comando.CommandType = CommandType.StoredProcedure;
            _Comando.Parameters.AddWithValue("@codigo", codigo);
            SqlDataReader _Reader;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                if (_Reader.Read())
                {
                    _codigo = (int)_Reader["Codigo"];
                    _logueo = (string)_Reader["UsuarioLogueo"];
                    usuario = PerUsuarioAdmin.GetInstancia().BuscarUsuario(_logueo);                    
                    _dificultad = (string)_Reader["Dificultad"];
                    _fechaHora = (DateTime)_Reader["FechaHora"];

                    _preguntas = PerPregunta.GetInstancia().PreguntasdeJuego(_codigo);

                    juego = new Juego(_codigo, _dificultad, _fechaHora, usuario, _preguntas);                    
                }
                _Reader.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
            return juego;
        }
    }
}
