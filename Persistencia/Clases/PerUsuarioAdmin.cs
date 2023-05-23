using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using EntidadesCompartidas;
using Persistencia.Interfaces;

namespace Persistencia.Clases
{
    internal class PerUsuarioAdmin : IPersistenciaUsuarioAdmin
    {
        private static PerUsuarioAdmin _instancia = null;

        private PerUsuarioAdmin() { }

        public static PerUsuarioAdmin GetInstancia()
        {
            if (_instancia == null)
                _instancia = new PerUsuarioAdmin();

            return _instancia;
        }

        public void UsuarioAlta(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));

            SqlCommand _comando = new SqlCommand("AltaUsuAdmin", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@logueo", usuario.UsuarioLogueo);
            _comando.Parameters.AddWithValue("@pass", usuario.Contrasena);
            _comando.Parameters.AddWithValue("@nombre", usuario.Nombre);
            _comando.Parameters.AddWithValue("@apellido", usuario.Apellido);
            
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                
                if ((int)_retorno.Value == -1)
                    throw new Exception("Usuario ya existe en el sistema.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("No se puede crear usuario Login.");
                else if ((int)_retorno.Value == -3)
                    throw new Exception("No se puede crear usuario BD.");
                else if ((int)_retorno.Value == -4)
                    throw new Exception("Error en alta de usuario.");
                else if ((int)_retorno.Value == -5)
                    throw new Exception("Error en alta de usuario.");
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
        public void UsuarioModificar(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));

            SqlCommand _comando = new SqlCommand("ModificarUsuario", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@logueo", usuario.UsuarioLogueo);
            _comando.Parameters.AddWithValue("@contrasena", usuario.Contrasena);
            _comando.Parameters.AddWithValue("@nombre", usuario.Nombre);
            _comando.Parameters.AddWithValue("@apellido", usuario.Apellido);
            
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                if ((int)_retorno.Value == -1)
                    throw new Exception("El usuario no existe en el sistema.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en modificación de usuario.");
                else if ((int)_retorno.Value == -3)
                    throw new Exception("Error en modificación de contraseña de UsuarioAdmin.");
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
        public void UsuarioBaja(UsuarioAdmin usuario, UsuarioAdmin usuLog)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));

            SqlCommand _comando = new SqlCommand("EliminarUsuario", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@logueo", usuario.UsuarioLogueo);
            SqlParameter _retorno = new SqlParameter("@Retorno", SqlDbType.Int);
            _retorno.Direction = ParameterDirection.ReturnValue;
            _comando.Parameters.Add(_retorno);

            try
            {
                _cnn.Open();
                _comando.ExecuteNonQuery();
                if ((int)_retorno.Value == -1)
                    throw new Exception("Ningún usuario en el sistema con el código indicado.");
                else if ((int)_retorno.Value == -2)
                    throw new Exception("Error en baja de usuario.");
                else if ((int)_retorno.Value == -3)
                    throw new Exception("No se puede eliminar usuario Login.");
                else if ((int)_retorno.Value == -4)
                    throw new Exception("No se puede eliminar usuario BD.");
                else if ((int)_retorno.Value == -5)
                    throw new Exception("No se puede eliminar usuario Login.");
                else if ((int)_retorno.Value == -6)
                    throw new Exception("No se puede eliminar usuario BD.");
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
        internal UsuarioAdmin BuscarUsuario(string logueo)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());
            UsuarioAdmin usuario = null;

            SqlCommand _comando = new SqlCommand("BuscarUsuario", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@logueo", logueo);

            try
            {
                _cnn.Open();
                SqlDataReader _lector = _comando.ExecuteReader();
                if (_lector.HasRows)
                {
                    _lector.Read();
                    usuario = new UsuarioAdmin(logueo, (string)_lector["Contrasena"], (string)_lector["Nombre"],
                                            (string)_lector["Apellido"]);
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
            return usuario;
        }
        public UsuarioAdmin BuscarUsuarioActivo(string logueo, UsuarioAdmin usuLog)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn(usuLog));
            UsuarioAdmin usuario = null;

            SqlCommand _comando = new SqlCommand("BuscarUsuarioActivo", _cnn);
            _comando.CommandType = CommandType.StoredProcedure;
            _comando.Parameters.AddWithValue("@logueo", logueo);

            try
            {
                _cnn.Open();
                SqlDataReader _lector = _comando.ExecuteReader();
                if (_lector.HasRows)
                {
                    _lector.Read();
                    usuario = new UsuarioAdmin(logueo, (string)_lector["Contrasena"], (string)_lector["Nombre"],
                                            (string)_lector["Apellido"]);
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
            return usuario;
        }
        public UsuarioAdmin Login(string logueo, string password)
        {
            SqlConnection _cnn = new SqlConnection(Conexion.Cnn());

            SqlCommand command = new SqlCommand("LogueodeUsuario", _cnn);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("logueo", logueo));
            command.Parameters.Add(new SqlParameter("contrasena", password));

            UsuarioAdmin usuario = null;

            try
            {
                _cnn.Open();
                SqlDataReader _lector = command.ExecuteReader();
                if (_lector.HasRows)
                {
                    _lector.Read();
                    usuario = new UsuarioAdmin(logueo, (string)_lector["Contrasena"], (string)_lector["Nombre"],
                                            (string)_lector["Apellido"]);
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
            return usuario;
        }
    }
}
