using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.ServiceModel;
using System.Runtime.Serialization;

namespace EntidadesCompartidas
{    
    [DataContract]
    public class UsuarioAdmin
    {
        private string _usuarioLogueo;
        private string _contrasena;
        private string _nombre;
        private string _apellido;

        [DataMember]
        public string UsuarioLogueo
        {
            get { return _usuarioLogueo; }
            set
            {
                if (value.Trim() == string.Empty)
                {
                    throw new Exception("Debe indicar un Usuario.");
                }
                else if (value.Length > 20)
                {
                    throw new Exception("El nombre de usuario no puede tener más de 20 caracteres.");
                }
                _usuarioLogueo = value.Trim();
            }
        }
        [DataMember]
        public string Contrasena
        {
            get { return _contrasena; }
            set
            {
                if (value.Trim() == string.Empty)
                {
                    throw new Exception("Debe indicar una Contraseña.");
                }
                else if (value.Length > 15)
                {
                    throw new Exception("La contraseña no debe tener más de 15 caracteres.");
                }
                _contrasena = value.Trim();
            }
        }
        [DataMember]
        public string Nombre
        {
            get { return _nombre; }
            set
            {
                if (value.Trim() == string.Empty)
                {
                    throw new Exception("Debe indicar un nombre.");
                }
                else if (value.Length > 50)
                {
                    throw new Exception("El nombre no debe tener más de 50 caracteres.");
                }
                _nombre = value.Trim();
            }
        }
        [DataMember]
        public string Apellido
        {
            get { return _apellido; }
            set
            {
                if (value.Trim() == string.Empty)
                {
                    throw new Exception("Debe indicar un apellido.");
                }
                else if (value.Length > 50)
                {
                    throw new Exception("El apellido no puede tener más de 50 caracteres.");
                }
                _apellido = value.Trim();
            }
        }
        public UsuarioAdmin(string usuarioLogueo, string contrasena, string nombre, string apellido)
        {
            UsuarioLogueo = usuarioLogueo;
            Contrasena = contrasena;
            Nombre = nombre;
            Apellido = apellido;
        }

        public UsuarioAdmin() { }

        public override string ToString()
        {
            return Nombre + " " + Apellido;
        }
    }
}
