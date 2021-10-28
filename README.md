### Enunciado
- [Aquí](https://docs.google.com/document/d/e/2PACX-1vTiod1ID7UPdUFQcH7nXs1VlKK6d1EW2FuwzbAkG-TvtBteEFPQJ16EfDSbzX-Y5BgDukIJLE0VdsZ0/pub)

### Diagramas de clase

#### Punto 1

![diagrama punto 1](https://yuml.me/841a00d2.png)

#### Punto 2

![diagrama punto 2](https://yuml.me/06d60d27.png)

#### Completo (Casi, faltan algunas cosas)

![diagrama completo](https://yuml.me/2c395d78.png)

#### Código que los genera:

Pegarlo en [https://yuml.me/diagram/scruffy/class/draw](https://yuml.me/diagram/scruffy/class/draw)

```yuml
///////// Punto 1

// Chat
[≪class≫;Chat|mensajes|espacioQueOcupa()]

// Mensajes
[≪class≫;Mensaje|emisor|peso()]
[≪class≫;Audio|duracion|pesoContenido()]
[≪class≫;Contacto|usuario|pesoContenido()]
[≪class≫;Texto|texto|pesoContenido()]
[≪class≫;Imagen|ancho;largo;compresion|pesoContenido()]
[≪class≫;Gif|cantCuadros|pesoContenido()]

// Compresiones
[≪interfaz≫;Compresion|pixelesAEnviar(totalDePixeles)]
[≪object≫;original||pixelesAEnviar(totalDePixeles)]
[≪class≫;Variable|porcentajeCompresion|pixelesAEnviar(totalDePixeles)]
[≪object≫;maxima||pixelesAEnviar(totalDePixeles)]

// Flechas:
// Un chat tiene muchos mensajes
[≪class≫;Chat]-*>[≪class≫;Mensaje]
// Una imagen tiene una compresión
[≪class≫;Imagen]->[≪interfaz≫;Compresion]
// Subclases de Mensaje
[≪class≫;Mensaje]^-[≪class≫;Audio]
[≪class≫;Mensaje]^-[≪class≫;Contacto]
[≪class≫;Mensaje]^-[≪class≫;Texto]
[≪class≫;Mensaje]^-[≪class≫;Imagen]
[≪class≫;Imagen]^-[≪class≫;Gif]
// Compresiones polimórficas (implementan interfaz)
[≪interfaz≫;Compresion]^-.-[≪object≫;original]
[≪interfaz≫;Compresion]^-.-[≪class≫;Variable]
[≪interfaz≫;Compresion]^-.-[≪object≫;maxima]

// Nota
[≪class≫;Imagen]-[note: compresión por composición y tipo imagen por herencia{bg:wheat}]


///////// Punto 2
[≪class≫;Usuario|chats;memoriaTotal|tieneEspacioPara(mensaje);espacioLibre();espacioOcupadoPorChats()]
[≪class≫;Chat|mensajes;participantes|espacioQueOcupa();recibir(mensaje);validarNuevoMensaje();validarEmisor();validarMemoriaDisponiblePara()]
[≪class≫;ChatPremium|restriccion|validarNuevoMensaje(mensaje)]

// Restricciones
[≪interfaz≫;Restriccion|validar(mensaje,chat)]
[≪object≫;difusion||validar(mensaje,chat)]
[≪class≫;Restringido|limite|validar(mensaje,chat)]
[≪class≫;Ahorro|maximo|validar(mensaje,chat)]


// Flechas:
// Un chat tiene muchos usuarios participantes
[≪class≫;Chat]-*>[≪class≫;Usuario]
// Un usuario tiene muchos chats
[≪class≫;Usuario]-*>[≪class≫;Chat]
// Un chat premium conoce una restricción
[≪class≫;ChatPremium] -> [≪interfaz≫;Restriccion]
// ChatPremium hereda de Chat
[≪class≫;Chat]^-[≪class≫;ChatPremium]

// Restricciones polimórficas (implementan interfaz)
[≪interfaz≫;Restriccion] ^-.- [≪object≫;difusion]
[≪interfaz≫;Restriccion] ^-.- [≪class≫;Restringido]
[≪interfaz≫;Restriccion] ^-.- [≪class≫;Ahorro]

///////// Punto 3 (INCOMPLETO)
[≪class≫;Usuario||buscar(texto)]
[≪class≫;Chat| mensajes | contieneTexto(texto);esMensajeDeParticipante(mensaje);todosTienenEspacioPara(mensaje)]

///////// Punto 4 (INCOMPLETO)
[≪class≫;Usuario||mensajesMasPesados()]

///////// Punto 5
[≪class≫;Chat||recibir(mensaje);enviarNotificacionNuevoMensaje()]
[≪class≫;Notificacion|chat;leida|leete();esDelChat(chat)]
[≪class≫;Usuario|notificaciones|recibirNotificacion(chat);leer(chat);notificacionesDeChat(chat);notificacionesSinLeer()]

// Usuario tiene muchas notificaciones
[≪class≫;Usuario]-*>[≪class≫;Notificacion]
// Notificación tiene un chat
[≪class≫;Notificacion]->[≪class≫;Chat]
```
