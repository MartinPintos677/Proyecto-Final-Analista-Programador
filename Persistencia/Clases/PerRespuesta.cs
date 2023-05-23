using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;

namespace Persistencia.Clases
{
    internal class PerRespuesta
    {
        private static PerRespuesta _instancia = null;

        private PerRespuesta() { }

        public static PerRespuesta GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerRespuesta();

            return _instancia;
        }

        internal void AltaRespuesta(Respuesta respuesta, string pregunta, SqlTransaction _pTransaccion)
        {
            SqlCommand _comando = new SqlCommand("RespuestaparaPregunta", _pTransaccion.Connection);
            _comando.CommandType = CommandType.StoredProcedure;            
            _comando.Parameters.AddWithValue("@codigoPregunta", pregunta);
            _comando.Parameters.AddWithValue("@texto", respuesta.Texto);
            _comando.Parameters.AddWithValue("@correccion", respuesta.Correcta);
            SqlParameter _ParamRetorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _ParamRetorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_ParamRetorno);
                        
            try
            {
                _comando.Transaction = _pTransaccion; 
                _comando.ExecuteNonQuery();

                int retorno = Convert.ToInt32(_ParamRetorno.Value);
                if (retorno == -1)
                    throw new Exception("No existe pregunta con el código ingresado.");
                else if (retorno == -2)
                    throw new Exception("Error en agregar respuesta.");                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<Respuesta> ListaRespuestas(string pregunta)
        {
            int _codigo;
            string _texto;
            bool _correcta;
            
            List<Respuesta> _Lista = new List<Respuesta>();
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());
            SqlCommand _Comando = new SqlCommand("RespuestasdePregunta", _cnn);
            _Comando.CommandType = CommandType.StoredProcedure;
            _Comando.Parameters.AddWithValue("@codigo", pregunta);
            SqlDataReader _Reader;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                while (_Reader.Read())
                {                    
                    _codigo = (int)_Reader["CodRespuesta"];                    
                    _texto = (string)_Reader["Texto"];
                    _correcta = (bool)_Reader["Correccion"];

                    Respuesta respuesta = new Respuesta(_codigo, _correcta, _texto);
                    _Lista.Add(respuesta);
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
    }
}
