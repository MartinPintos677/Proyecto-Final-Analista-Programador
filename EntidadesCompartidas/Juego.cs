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
    public class Juego
    {
        private int _codigo;
        private string _dificultad;
        private DateTime _fechaHora;
        private UsuarioAdmin _usuarioAdmin;
        private List<Pregunta> _preguntas;

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
        public string Dificultad
        {
            get { return _dificultad; }
            set
            {
                if (value != "Facil" && value != "Medio" && value != "Dificil")
                {
                    throw new Exception("Debe indicar si la dificultad es fácil, medio o difícil.");
                }
                _dificultad = value;
            }
        }
        [DataMember]
        public DateTime FechaHora
        {
            get { return _fechaHora; }
            set
            {
                _fechaHora = value;
            }
        }
        [DataMember]
        public UsuarioAdmin UsuarioAdmin
        {
            get { return _usuarioAdmin; }
            set
            {
                if (value == null)
                {
                    throw new Exception("Debe indicar un Usuario.");
                }
                _usuarioAdmin = value;
            }
        }
        [DataMember]
        public List<Pregunta> Preguntas
        {
            get { return _preguntas; }
            set
            {
                if (value == null)
                {
                    throw new Exception("Debe haber una colección.");
                }
                _preguntas = value;
            }
        }
        public Juego(int codigo, string dificultad, DateTime fechaHora, UsuarioAdmin usuarioAdmin, List<Pregunta> preguntas)
        {
            Codigo = codigo;
            Dificultad = dificultad;
            FechaHora = fechaHora;
            UsuarioAdmin = usuarioAdmin;
            Preguntas = preguntas;
        }
        public Juego() { }
    }
}
