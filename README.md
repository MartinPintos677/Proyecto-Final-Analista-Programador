# Letra Proyecto Final Analista Programador

PROYECTO FINAL DE SEGUNDO AÑO
CARRERA DE ANALISTA DE SISTEMAS
ANALISTA PROGRAMADOR WEB .NET 2023

Generalidades

La entrega final se hará durante la última clase de tutoría. Durante las clases de tutorías deberán
realizarse entregas parciales de acuerdo a lo establecido en la sección Tutorías & Entregas.
Se deberá realizar la entrega mediante correo electrónico, del software junto con toda la
documentación exigida en la sección Requerimientos de Entrega:
 Asunto: Entrega Proyecto Final ANP 2021

 Destinatarios: segundoanalista@bios.edu.uy y tutor asignado (OBLIGATORIO)

 Compartido por Drive: documentación y solución completa

 Cuerpo: Nombre y Cedula de los integrantes del grupo que realiza la entrega

 Se deberán formar grupos de 1 a 3 personas, los cuales deberán inscribirse en bedelía
desde el día 21 de noviembre hasta el día 02 de diciembre. No se aceptaran
inscripciones fuera de fecha. Luego de esto, Bedelía publicara la asignación de tutores así
como de horarios. La inscripción es únicamente por vía mail, con el siguiente formato:
a) Asunto: Inscripción a Proyecto Final Segundo Año
b) Contenido:
a. Cedula y Nombre de todos los integrantes del grupo que se presenta
b. Franja Horaria a la que se concurre a clase

 La asistencia a la última tutoría es obligatoria para todos los miembros del grupo ya que se
realizara la defensa en máquina del proyecto.
Idea General
Se desea realizar el desarrollo de un sitio web, para un juego de preguntas y respuestas
.
Los usuarios administradores (gestionan los juegos y sus datos) deberán tener usuario de logueo
(único en el Sistema), contraseña, y nombre completo. Los jugadores no tendrán usuario propio, ya
que jugar será de acceso público.
Arquitectura Solicitada
 Se podrán acceder a la información y se podrán realizar tareas / juegos a través de un sitio web,
que será publicado en un servidor contratado para dicha funcionalidad.

 La lógica de negocio del sistema estará ubicada dentro de otro servidor, y se podrá acceder a ella
mediante un contrato de servicio publicado en el mismo servidor.

 La base de datos estará instalada en un servidor de datos. La persistencia se comunicara con
dicho servidor mediante ADO.NET.

Proyecto Final Segundo Año Página 2 de 5 Carrera Analista de Sistemas
Funcionalidades Mínimas del Sitio Web
Formulario Web: Principal (formulario por defecto del sitio)
Actor Participante: público
Resumen:
a) En este formulario se desplegaran todas las jugadas realizadas. Los datos a desplegar serán:
Fecha de realizada la jugada, Nombre del jugador, el puntaje obtenido y el nivel de dificultad del
juego jugado. Se deberá poder filtrar las jugadas por nombre de jugador o por tipo de dificultad
del juego realizado. También se podrán ordenar por dificultad y dentro de esta por puntaje. El
resultado final se mostrara en el mismo control que la lista completa. Los filtros propuestos
deberán realizarse mediante Linq to Object.

b) La página deberá tener un acceso directo a la página de logueo al sistema.

c) La página deberá tener un acceso directo a la página de jugar
Formulario Web: Jugar (generar jugada)
Actor Participante: público
Resumen: Mediante esta página se permitirá que cualquier usuario selecciones un juego y lo juegue.
Para ello se le mostraran todos los juego con preguntas del sistema (desplegando fecha de creado,
cantidad de preguntas y su dificultad). Cuando el usuario seleccione uno, comienza el juego. Una por
vez, se desplegara cada pregunta acompañada de sus respuestas. No se podrá pasar a la siguiente
pregunta sin responder la actual (seleccionar una respuesta). Solo se permite ir a la siguiente pregunta
(no hay un “atrás”). Se debe ir almacenando en memoria el resultado, es decir almacenando el puntaje
de las preguntas que se contestaron correctamente. Cuando ya no hay más preguntas en el juego, este se
termina, y se almacena la jugada, sabiendo: fecha y hora (automática en el momento de terminar el
juego), nombre del jugador (se solicita al usuario), que juego se jugó, y puntaje final obtenido

Formulario Web: Logueo
Actor Participante: público
Resumen: Mediante esta página se permitirá el logueo de un usuario administrador al sitio (ingreso de
usuario y contraseña). Si el usuario se autentica correctamente, el sistema lo re direccionará a la página
de bienvenida correspondiente. Tomar en cuenta, que todos los accesos a Base de Datos luego de
loguearse, deberán realizarse con el usuario SQL asociado al usuario logueado sin excepción
alguna.

Formulario Web: ABM de usuarios
Actor Participante: Administrador
Resumen: Este formulario permite realizar alta, baja y modificación de usuarios. Tomar en cuenta los
datos necesarios que se especificaron en la sección “Idea General”. Además, se deberá crear en el
Servidor SQL, un usuario de logueo y un usuario de base de datos, asociado a dicho usuario. Estos
serán utilizados cada vez que el usuario quiera acceder a la base de datos. Tomar en cuenta la seguridad
y acciones que debe realizar un usuario administrador, para la determinación de permisos. Considerar
que solo el propio usuario podrá cambiar la contraseña. Si se elimina un usuario, los juegos
realizados por él, deberán persistir en el sistema.
Proyecto Final Segundo Año Página 3 de 5 Carrera Analista de Sistemas
Formulario Web: ABM de Categorías de Preguntas
Actor Participante: Administrador
Resumen: Este formulario permite realizar alta, baja y modificación de categorías de preguntas. Se
deberá saber: Código (identificador único en el sistema) compuesto por 4 letras y nombre. Ejemplos:
Math (matemáticas), Hist (historia), etc. Si se elimina una categoría, las preguntas asociadas, deberán
persistir en el sistema

Formulario Web: ABM de Juegos
Actor Participante: Administrador
Resumen: Este formulario permite realizar alta, baja y modificación de juegos. Se deberá saber: Código
(identificador único en el sistema y autogenerado), fecha de creación (automático en el momento de
crearlo o modificarlo), Dificultad (fácil – medio – difícil), usuario administrador que lo creo / modifico
(automático el usuario logueado). En un segundo paso se le deberán asignar las preguntas al juego.
Pueden tenerse juegos sin preguntas, ya que la asignación de estas se realizara aparte de la creación. No
se podrán eliminar juegos que ya tengan jugadas realizadas.

Formulario Web: Manejo de Preguntas de un Juego
Actor Participante: Administrador
Resumen: Este formulario permite agregar o eliminar preguntas asignadas a un juego. Primero se le
debe pedir al usuario que seleccione el juego. Si el juego ya tiene preguntas asignadas, estas deberán
mostrarse en una grilla (se despliega texto y puntaje) permitiendo quitarlas del juego. Además el usuario
podrá agregar nuevas preguntas.

Formulario Web: Alta Preguntas
Actor Participante: Administrador
Resumen: Este formulario permite realizar el alta de una pregunta De cada una se deberá saber: código
(identificador único) alfanumérico de 5 de largo, puntaje de la pregunta (entre 1 y 10), categoría a la que
pertenece la pregunta y el texto de la misma. Cada pregunta está compuesta por varias respuestas.
Para cada una de las respuestas se sabe: código interno (único dentro de cada pregunta, y generado
automáticamente para cada una), texto de la respuesta, y si es correcta o no. Una pregunta se maneja
conjunto con sus respuestas. No se pueden eliminar preguntas del sistema

Formulario Web: Listados Sin Asignación
Actor Participante: Administrador
Resumen: Este formulario permitirá realizar las siguientes consultas, las cuales deben generarse a nivel
de base de datos (mediante SP).
A. Juegos nunca usados: despliega todos los juegos que no tengan jugadas asociadas. Considerar
solo aquellos juegos que si podrán jugarse: los que tienen preguntas asociadas
B. Preguntas nunca usadas: despliega todas las preguntas que no estén asociadas a ningún juego
C. Juegos vacíos: despliega aquellos juegos que no tienen preguntas asignadas
Proyecto Final Segundo Año Página 4 de 5 Carrera Analista de Sistemas
Requerimientos de Implementación

 Implementación completa del sistema con tecnologías .NET en lenguaje C#. Obligatorio la
entrega en Visual Studio 2015.
 La información deberá almacenarse obligatoriamente en una base de datos SQL Server 2008
R2

 El script de la base de datos debe generarse manualmente, sin la ayuda de un asistente. Deberá
contener el Esquema de creación de la base de datos, Stored Procedures necesarios para
realizar todas las tareas solicitadas, Creación de usuarios y permisos solicitados y necesarios,
e Inserción de datos de prueba. Las restricciones sobre datos, deberán realizarse en la propia
estructura de la tabla (uso de los modificadores unique, check, default).

 Las eliminaciones a nivel de la base de datos deberán ser físicas o lógicas en función de las
posibilidades. Es decir, si un elemento a eliminar no tiene elementos dependientes dentro de los
registros de la base de datos, o estos se pueden eliminar, se elimina físicamente; de lo contrario
se hará una eliminación lógica. Obligatorio de implementar

 Para el desarrollo del sistema utilizar la arquitectura en 3 capas vista en el curso, mediante la
utilización de bibliotecas de clases.

 Obligatorio el uso de clases definidas por el usuario para la comunicación de datos entre
componentes (tanto para invocación como respuesta).

 Los componentes de Lógica y Persistencia deberán ser generados en base a los patrones de
Fábrica y Singleton vistos en clase. No deberá implementarse ningún otro patrón.

 Siempre se deberá de trabajar en forma conectada (ADO.NET) para el manejo de la
información de la base de datos.

 Los componentes deberán lanzar excepciones en caso de error. No se contempla otra forma de
comunicación de errores entre componentes

 La comunicación del Servicio Web que publica las operaciones de la capa Lógica, deberá
realizarse mediante contratos de servicio (WCF).

 Uso obligatorio de MasterPage para el manejo de usuarios y permisos de acceso

Requerimientos de Entrega:
 Modelo Conceptual.

 MER

 Diagrama de Clases completo de la Arquitectura en capas (incluye a todos los componentes,
clases, interfaces y relaciones entre ellos)

 Solución completa del Software

 Script de la base de datos

Nota: todos los diagramas deberán ser generados con una herramienta para lenguaje UML. Estos deberán ser entregados
en forma digital: una copia del archivo original del diagrama y una copia en formato PDF o JPG
Proyecto Final Segundo Año Página 5 de 5 Carrera Analista de Sistemas
Tutorías y Entregas
A continuación se detallan las entregas sugeridas:

 Primera Sesión (semana del 23/01 al 27/01):

o Modelo Conceptual

o DER

o Script BD completa (tablas – procedimientos – manejo de usuarios y baja lógica)

o Capa de Entidades Compartidas completa

o Capa de Persistencia completa

 Segunda Sesión (semana del 13/02 al 17/02):

o Capa de Lógica completa

o Servicio WCF completo y publicado

o UI: estructura del sitio y armado del logueo

o UI: mantenimiento de usuarios completo

 Tercera Sesión (semana del 13/03 al 17/03):

o Entrega de todo lo solicitado en el punto Requerimientos de Entrega.

o Defensa obligatoria del proyecto. Para ello el grupo deberá concurrir antes de su horario
de tutoría, para realizar la instalación del sistema. Dicha instalación deberá respetar la
arquitectura propuesta. 
