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
    internal class PerJugada : IPersistenciaJugada
    {
        private static PerJugada _instancia = null;

        private PerJugada() { }

        public static PerJugada GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerJugada();

            return _instancia;
        }

        public void AltaJugada(Jugada jugada)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());

            SqlCommand _comando = new SqlCommand("GenerarJugada", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@jugador", jugada.Jugador);
            _comando.Parameters.AddWithValue("@juego", jugada.Juego.Codigo);
            _comando.Parameters.AddWithValue("@puntaje", jugada.PuntajeFinal);
            
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
                    throw new Exception("Error en generar jugada.");
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
        public List<Jugada> ListaJugadas()
        {
            Juego juego = null;
            string _jugador;
            DateTime _fechaHora;
            int _puntaje;
            int _codigo;

            List<Jugada> _Lista = new List<Jugada>();
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());
            SqlCommand _Comando = new SqlCommand("ListadoJugadas", _cnn);
            SqlDataReader _Reader;

            Jugada jugada = null;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                while (_Reader.Read())
                {
                    _fechaHora = (DateTime)_Reader["FechaHora"];
                    _jugador = (string)_Reader["Jugador"];
                    _puntaje = (int)_Reader["Puntaje"];                    

                    _codigo = (int)_Reader["Juego"];
                    juego = PerJuego.GetInstancia().BuscarJuego(_codigo);                     

                    jugada = new Jugada(_jugador, _puntaje, _fechaHora, juego);
                    _Lista.Add(jugada);
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
