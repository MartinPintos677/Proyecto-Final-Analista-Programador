using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;
using Persistencia.Interfaces;

namespace Persistencia
{
    internal class PerCategoriaPregunta : IPersistenciaCatPregunta
    {
        private static PerCategoriaPregunta _instancia = null;

        private PerCategoriaPregunta() { }

        public static PerCategoriaPregunta GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerCategoriaPregunta();

            return _instancia;
        }

        public void AltaCategoria(CategoriaPregunta categoria, UsuarioAdmin logueo)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(logueo));

            SqlCommand _comando = new SqlCommand("AltaCategoria", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", categoria.Codigo);
            _comando.Parameters.AddWithValue("@nombre", categoria.Nombre);
            
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();

                if ((int)_retorno.Value == 0)
                    throw new Exception("Error en alta de categoria de pregunta.");
                else if ((int)_retorno.Value == -1)
                    throw new Exception("Categoria de pregunta ya existe en el sistema.");
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

        public void CategoriaModificar(CategoriaPregunta categoria, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("ModificarCategoria", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", categoria.Codigo);
            _comando.Parameters.AddWithValue("@nombre", categoria.Nombre);
            
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                if ((int)_retorno.Value == -1)
                    throw new Exception("La categoria de pregunta no existe en el sistema.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en modificación de categoria de pregunta.");
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
        public void CategoriaBaja(CategoriaPregunta categoria, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));

            SqlCommand _comando = new SqlCommand("BajaCategoria", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", categoria.Codigo);
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                if ((int)_retorno.Value == -1)
                    throw new Exception("Ninguna categoria de pregunta en el sistema con el código digitado.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en la baja de categoria de pregunta.");
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
        public CategoriaPregunta BuscarCategoriaActiva(string codigo, UsuarioAdmin usuario)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));
            CategoriaPregunta categoria = null;

            SqlCommand _comando = new SqlCommand("BuscarCategoriaActiva", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", codigo);

            try
            {
                _cnn.Open();
                SqlDataReader _lector = _comando.ExecuteReader();
                if (_lector.HasRows)
                {
                    _lector.Read();
                    categoria = new CategoriaPregunta(codigo, (string)_lector["Nombre"]);
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
            return categoria;
        }
        internal CategoriaPregunta BuscarCategoria(string codigo)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());
            CategoriaPregunta categoria = null;

            SqlCommand _comando = new SqlCommand("BuscarCategoria", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@codigo", codigo);

            try
            {
                _cnn.Open();
                SqlDataReader _lector = _comando.ExecuteReader();
                if (_lector.HasRows)
                {
                    _lector.Read();
                    categoria = new CategoriaPregunta(codigo, (string)_lector["Nombre"]);
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
            return categoria;
        }
        public List<CategoriaPregunta> ListaCategorias(UsuarioAdmin usuario)
        {
            string _codigo;
            string _nombre;
            List<CategoriaPregunta> _Lista = new List<CategoriaPregunta>();
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuario));
            SqlCommand _Comando = new SqlCommand("ListadoCategorias", _cnn);
            SqlDataReader _Reader;
            try
            {
                _cnn.Open();
                _Reader = _Comando.ExecuteReader();
                while (_Reader.Read())
                {
                    _codigo = (string)_Reader["Codigo"];
                    _nombre = (string)_Reader["Nombre"];
                    CategoriaPregunta categoria = new CategoriaPregunta(_codigo, _nombre);
                    _Lista.Add(categoria);
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
