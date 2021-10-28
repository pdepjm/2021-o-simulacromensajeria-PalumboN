// PUNTOS DE ENTRADA DE LOS REQUERIMIENTOS

//1) chat.espacioQueOcupa() -> Numero
//2) chat.recibir(mensaje)	[Acción]
//3) usuario.buscarTexto(texto) -> Chats
//4) usuario.mensajesMasPesados() -> Mensajes
//5) a) Se resuelve en Chat.recibir [acción]
//	 b) usuario.leer(chat) [acción]
//	 c) usuario.notificacionesSinLeer() -> Notificaciones

class Chat {
	const participantes = #{}
	const mensajes = []
	
	method espacioQueOcupa() = 
		mensajes.sum({mensaje => mensaje.peso() })
		
	method recibir(mensaje) {
		self.validarNuevoMensaje(mensaje)
		mensajes.add(mensaje)
		self.enviarNotificacionNuevoMensaje()
	}
	
	method enviarNotificacionNuevoMensaje() {
		participantes.forEach({usuario => 
			usuario.recibirNotificacion(self)
		}) 
	}
	
	method validarNuevoMensaje(mensaje) {
		 self.validarEmisor(mensaje)
		 self.validarMemoriaDisponiblePara(mensaje)
	}
	
	method validarEmisor(mensaje) {
		if (not self.esMensajeDeParticipante(mensaje)) {
			throw new DomainException(message = "El emisor no pertenece a este chat")
		} 
	}
	
	method validarMemoriaDisponiblePara(mensaje) {
		if (not self.todosTienenEspacioPara(mensaje)) {
			throw new DomainException(message = "Hay problemas con la memoria")
		}
	}
	
	method contieneTexto(texto) =
		mensajes.any({mensaje => mensaje.contiene(texto) })
	
	method esMensajeDeParticipante(mensaje) =
		participantes.contains(mensaje.emisor())
		
	method todosTienenEspacioPara(mensaje) =
		participantes.all({usuario => usuario.tieneEspacioPara(mensaje)})
		
	method mensajeMasPesado() =
		mensajes.max({mensaje => mensaje.peso()})
		
	method cantidadMensajes() = mensajes.size()
	
	method agregarParticipante(usuario) {
		participantes.add(usuario)
		usuario.nuevoChat(self)
	}
}

class ChatPremium inherits Chat {
	var property restriccion
	const property creador
	
	override method validarNuevoMensaje(mensaje) {
		super(mensaje)
		restriccion.validar(mensaje, self)
	}
}

object difusion { 
	method validar(mensaje, chat) {
		if (mensaje.emisor() != chat.creador()) {
			throw new DomainException(message = "Solo el creador puede enviar mensajes a este chat")
		}
	}
}

class Restringido { 
	const limite
	
	method validar(mensaje, chat) {
		if (chat.cantidadMensajes() >= limite) {
			throw new DomainException(message = "Se ha llegado al límite de mensajes del chat")
		}
	}
}

class Ahorro { 
	const pesoMaximo
	
	method validar(mensaje, chat) {
		if (mensaje.peso() >= pesoMaximo) {
			throw new DomainException(message = "Este mensaje es muy pesado para este chat")
		}
	}
}


class Mensaje {
	const property emisor
	
	method peso() = 5 + self.pesoContenido() * 1.3

	method pesoContenido()
	
	method contiene(texto) = emisor.contieneNombre(texto)
}

class Texto inherits Mensaje { 
	const texto
	
	override method pesoContenido() = texto.size()
	
	override method contiene(textoABuscar) = 
		super(textoABuscar) or texto.contains(textoABuscar)
}

class Audio inherits Mensaje { 
	const duracion
	
	override method pesoContenido() = duracion * 1.2
}

object original {
	method pixelesAEnviar(totalDePixeles) = totalDePixeles
}

class Variable {
	const porcentajeCompresion // Número entre 0 y 1
	
	method pixelesAEnviar(totalDePixeles) = totalDePixeles * porcentajeCompresion
}

object maxima {
	const maximaCantidadDePixeles = 10000
	method pixelesAEnviar(totalDePixeles) = totalDePixeles.min(maximaCantidadDePixeles) 
}

class Imagen inherits Mensaje { 
	const ancho
	const largo
	const compresion
	
	method cantPixeles() = ancho * largo
	
	method pixelesAEnviar() = compresion.pixelesAEnviar(self.cantPixeles())
	
	override method pesoContenido() = 2 * self.pixelesAEnviar()
}

class Gif inherits Imagen {
	const cantCuadros
	
	override method pesoContenido() = super() * cantCuadros 
}

class Contacto inherits Mensaje {
	const usuario
	override method pesoContenido() = 3
	
	override method contiene(textoABuscar) = usuario.contieneNombre(textoABuscar)
}

class Usuario { 
	const chats = []
	const notificaciones = []
	const memoriaTotal
	const nombre
	
	method tieneEspacioPara(mensaje) =
		self.espacioLibre() >= mensaje.peso()
		
	method espacioLibre() =
		memoriaTotal - self.espacioOcupadoPorChats()
		
	method espacioOcupadoPorChats() =
		chats.sum({chat => chat.espacioQueOcupa()})
		
	method buscarTexto(texto) =
		chats.filter({chat => chat.contieneTexto(texto)})
		
	method contieneNombre(textoABuscar) =
		nombre.contains(textoABuscar)
		
	method mensajesMasPesados() =
		chats.map({unChat => unChat.mensajeMasPesado()})
		
	method recibirNotificacion(chat) {
		notificaciones.add(new Notificacion(chat = chat))
	}
	
	method leer(chat) {
		self.notificacionesDeChat(chat)
			.forEach({notificacion => notificacion.leete()})
	}
	
	method notificacionesDeChat(chat) =
		notificaciones.filter({notificacion => notificacion.esDelChat(chat)}) 
		
	method notificacionesSinLeer() =
		notificaciones.filter({notificacion => not notificacion.leida()})
		
	method nuevoChat(chat) {
		chats.add(chat)
	}
}

class Notificacion {
	const chat
	var property leida = false
	
	method leete() { leida = true }
	
	method esDelChat(unChat) = chat == unChat
}


