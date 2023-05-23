using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

using System.ServiceModel;
using System.Runtime.Serialization;


namespace EntidadesCompartidas
{
    [DataContract]
    public class CategoriaPregunta
    {
        private string _codigo;
        private string _nombre;
        
        [DataMember]        
        public string Codigo
        {
            get { return _codigo; }
            set
            {
                Regex regex = new Regex("[a-zA-Z][a-zA-Z][a-zA-Z][a-zA-Z]"); 
                if (!regex.IsMatch(value))
                {
                    throw new Exception("El código debe tener 4 letras.");
                }
                _codigo = value.Trim().ToUpper();
            }
        }
        [DataMember]
        public string Nombre
        {
            get { return _nombre; }
            set
            {
                if (value == string.Empty)
                {
                    throw new Exception("Debe ingresar un nombre para la Categoria de Pregunta.");
                }
                else if (value.Trim().Length > 30)
                {
                    throw new Exception("Nombre de Categoria de Pregunta no debe tener más de 30 caracteres.");
                }
                _nombre = value.Trim();
            }
        }

        public CategoriaPregunta(string codigo, string nombre)
        {
            Codigo = codigo;
            Nombre = nombre;
        }

        public CategoriaPregunta() { }
    }
}
