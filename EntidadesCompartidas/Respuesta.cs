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
    public class Respuesta
    {
        private int _codigo;
        private bool _correcta;
        private string _texto;

        [DataMember]
        public int Codigo
        {
            get { return _codigo; }
            set
            {
                _codigo = value;
            }
        }
        [DataMember]
        public bool Correcta
        {
            get { return _correcta; }
            set
            {
                _correcta = value;
            }
        }
        [DataMember]
        public string Texto
        {
            get { return _texto; }
            set
            {
                if (value == string.Empty)
                {
                    throw new Exception("Debe ingresar texto para la respuesta.");
                }
                else if (value.Length > 100)
                {
                    throw new Exception("El texto debe tener un máximo de 100 caracteres.");
                }
                _texto = value;
            }
        }
        
        public Respuesta(int codigo, bool correcta, string texto)
        {
            Codigo = codigo;
            Correcta = correcta;
            Texto = texto;            
        }
        public Respuesta() { }
    }
}
