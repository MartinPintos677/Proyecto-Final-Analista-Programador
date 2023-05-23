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
    public class Jugada
    {
        private string _jugador;
        private int _puntajeFinal;
        private DateTime _fechaHora;
        private Juego _juego;

        [DataMember]
        public string Jugador
        {
            get { return _jugador; }
            set
            {
                if (value.Trim() == string.Empty)
                {
                    throw new Exception("Debe indicar un nombre.");
                }
                else if (value.Length > 50)
                {
                    throw new Exception("El nombre de jugador no debe tener más de 50 caracteres.");
                }
                _jugador = value.Trim();
            }
        }
        [DataMember]
        public int PuntajeFinal
        {
            get { return _puntajeFinal; }
            set
            {
                if (value < 1)
                {
                    throw new Exception("El puntaje debe ser positivo.");
                }
                _puntajeFinal = value;
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
        public Juego Juego
        {
            get { return _juego; }
            set
            {
                if (value == null)
                {
                    throw new Exception("Debe indicar un juego.");
                }
                _juego = value;
            }
        }
        public Jugada(string jugador, int puntajeFinal, DateTime fechaHora, Juego juego)
        {
            Jugador = jugador;
            PuntajeFinal = puntajeFinal;
            FechaHora = fechaHora;
            Juego = juego;
        }
        public Jugada() { }
    }
}
