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
    public class Pregunta
    {
        private string _codigo;
        private int _puntajePregunta;
        private string _texto;
        private CategoriaPregunta _categoriaPregunta;
        private List<Respuesta> _respuestas;        

        [DataMember]
        public string Codigo
        {
            get { return _codigo; }
            set
            {
                Regex regexCodigo = new Regex("[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]");
                if (!regexCodigo.IsMatch(value)) 
                {
                    throw new Exception("El código debe tener 5 caracteres alfanuméricos.");
                }
                _codigo = value.Trim();
            }
        }
        [DataMember]
        public int PuntajePregunta
        {
            get { return _puntajePregunta; }
            set
            {
                if (value < 1 || value > 10)
                {
                    throw new Exception("El puntaje debe ser entre 1 y 10.");
                }
                _puntajePregunta = value;
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
                    throw new Exception("Debe ingresar texto para la pregunta.");
                }
                else if (value.Length > 100)
                {
                    throw new Exception("El texto debe tener un máximo de 100 caracteres.");
                }
                _texto = value;
            }
        }
        [DataMember]
        public CategoriaPregunta CategoriaPregunta
        {
            get { return _categoriaPregunta; }
            set
            {
                if (value == null)
                {
                    throw new Exception("Debe indicar una categoria para la pregunta.");
                }
                _categoriaPregunta = value;
            }
        }
        [DataMember]
        public List<Respuesta> Respuestas
        {
            get { return _respuestas; }
            set
            {
                if (value == null || value.Count() == 0)
                {
                    throw new Exception("La cantidad de respuestas para una pregunta no puede ser 0.");
                }
                _respuestas = value;
            }
        }
        public Pregunta(string codigo, int puntajePregunta, string texto, CategoriaPregunta categoriaPregunta, List<Respuesta> respuestas)
        {
            Codigo = codigo;
            PuntajePregunta = puntajePregunta;
            Texto = texto;
            CategoriaPregunta = categoriaPregunta;
            Respuestas = respuestas;
        }
        public Pregunta() { }
    }
}
