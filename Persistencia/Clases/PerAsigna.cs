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
    internal class PerAsigna : IPersistenciaAsigna
    {
        private static PerAsigna _instancia = null;

        private PerAsigna() { }

        public static PerAsigna GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerAsigna();

            return _instancia;
        }

        public void Asignar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("AsignarPreguntapJuego", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codJuego", juego.Codigo);
            _comando.Parameters.AddWithValue("@codPregunta", pregunta.Codigo);

            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();

                if ((int)_retorno.Value == 0)
                    throw new Exception("Error en asignación de pregunta para juego.");
                else if ((int)_retorno.Value == -1)
                    throw new Exception("No existe juego en el sistema con el código indicado.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("No existe pregunta en el sistema con el código indicado.");
                else if ((int)_retorno.Value == -3)
                    throw new Exception("La pregunta ya fue asignada al juego.");
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
        public void Quitar(Pregunta pregunta, Juego juego, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("EliminarPreguntadeJuego", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codJuego", juego.Codigo);
            _comando.Parameters.AddWithValue("@codPregunta", pregunta.Codigo);

            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();

                if ((int)_retorno.Value == -1)
                    throw new Exception("No existe pregunta asignada a un juego con los códigos indicados.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en quitar pregunta de juego.");                
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
    }
}
