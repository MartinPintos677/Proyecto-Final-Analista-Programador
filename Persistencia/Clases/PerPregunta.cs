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
    internal class PerPregunta : IPersistenciaPregunta
    {
        private static PerPregunta _instancia = null;

        private PerPregunta() { }

        public static PerPregunta GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerPregunta();

            return _instancia;
        }

        public void AltaPregunta(Pregunta pregunta, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("AltaPregunta", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", pregunta.Codigo);
            _comando.Parameters.AddWithValue("@texto", pregunta.Texto);
            _comando.Parameters.AddWithValue("@puntaje", pregunta.PuntajePregunta);
            _comando.Parameters.AddWithValue("@categoria", pregunta.CategoriaPregunta.Codigo);

            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            SqlTransaction _miTransaccion = null;

            try
            {
                _cnn.Open();
                _miTransaccion = _cnn.BeginTransaction();
                _comando.Transaction = _miTransaccion;
                _comando.ExecuteNonQuery();
                
                if ((int)_retorno.Value == -1)
                    throw new Exception("Pregunta ya existe en el sistema.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en alta de pregunta.");

                foreach (Respuesta respuesta in pregunta.Respuestas)
                {
                    PerRespuesta.GetInstancia().AltaRespuesta(respuesta, pregunta.Codigo, _miTransaccion);
                }

                _miTransaccion.Commit();
            }
            catch (Exception ex)
            {
                _miTransaccion.Rollback();
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
        }
        public List<Pregunta> PreguntasNuncaUsadas(UsuarioAdmin usuLog)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));
            SqlCommand _commando = new SqlCommand("PreguntasNuncaUsadas", _cnn);
            _commando.CommandType = CommandType.StoredProcedure;
            
            SqlDataReader reader;
            List<Pregunta> preguntas = new List<Pregunta>();
            string codigo;
            int puntaje;
            string texto;
            string codCategoria;

            Pregunta pregunta = null;
            CategoriaPregunta categoria = null;
            List<Respuesta> respuestas;

            try
            {
                _cnn.Open();
                reader = _commando.ExecuteReader();

                while (reader.Read())
                {
                    codCategoria = (string)reader["CategPregunta"];
                    codigo = (string)reader["Codigo"];
                    puntaje = (int)reader["PuntajePregunta"];
                    texto = (string)reader["Texto"];
                    categoria = PerCategoriaPregunta.GetInstancia().BuscarCategoria(codCategoria);

                    respuestas = PerRespuesta.GetInstancia().ListaRespuestas(codigo);

                    pregunta = new Pregunta(codigo, puntaje, texto, categoria, respuestas);
                    preguntas.Add(pregunta);
                }
                reader.Close();
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                _cnn.Close();
            }
            return preguntas;
        }
        internal List<Pregunta> PreguntasdeJuego(int juego)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());
            SqlCommand _commando = new SqlCommand("ListadodePreguntasdeJuego", _cnn);
            _commando.CommandType = CommandType.StoredProcedure;
            _commando.Parameters.Add(new SqlParameter("@codJuego", juego));

            SqlDataReader reader;
            List<Pregunta> preguntas = new List<Pregunta>();
            string codigo;
            int puntaje;
            string texto;
            string codCategoria;

            Pregunta pregunta = null;
            CategoriaPregunta categoria = null;
            List<Respuesta> respuestas;

            try
            {
                _cnn.Open();
                reader = _commando.ExecuteReader();

                while (reader.Read())
                {
                    codCategoria = (string)reader["CategPregunta"];
                    codigo = (string)reader["Codigo"];
                    puntaje = (int)reader["PuntajePregunta"];
                    texto = (string)reader["Texto"];
                    categoria = PerCategoriaPregunta.GetInstancia().BuscarCategoria(codCategoria);

                    respuestas = PerRespuesta.GetInstancia().ListaRespuestas(codigo);

                    pregunta = new Pregunta(codigo, puntaje, texto, categoria, respuestas);
                    preguntas.Add(pregunta);
                }
                reader.Close();
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                _cnn.Close();
            }
            return preguntas;
        }
        public Pregunta BuscarPregunta(string codigo, UsuarioAdmin usuLog)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));
            Pregunta pregunta = null;

            SqlCommand _comando = new SqlCommand("BUscarPregunta", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", codigo);

            List<Respuesta> respuestas;
            CategoriaPregunta categoria = null;
            string codCategoria;
            try
            {
                _cnn.Open();
                SqlDataReader _lector = _comando.ExecuteReader();
                if (_lector.HasRows)
                {
                    _lector.Read();
                    codCategoria = (string)_lector["CategPregunta"];
                    categoria = PerCategoriaPregunta.GetInstancia().BuscarCategoria(codCategoria);

                    respuestas = PerRespuesta.GetInstancia().ListaRespuestas(codigo);

                    pregunta = new Pregunta(codigo, (int)_lector["PuntajePregunta"], (string)_lector["Texto"], 
                                           categoria, respuestas);
                }
                _lector.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _cnn.Close();
            }
            return pregunta;
        }
    }
}
