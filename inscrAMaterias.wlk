class  Cursada {
    var property materia
    var property nota
}

class Carrera {
    const property materias = [] 
}

class Materia {
    var property correlativas = [] 
    var property inscriptos = []
    var property listaDeEspera = []  
    const property cupo 

    method agregarAInscriptos(alumno){
        inscriptos.add(alumno)
    }
    method agregarAListaDeEspera(alumno){
        listaDeEspera.add(alumno)
    }
    method removerDeInscriptos(alumno){
        inscriptos.remove(alumno)
    }
    method darCupo(){
        if (not listaDeEspera.isEmpty()){
            var alumno = listaDeEspera.first()
            inscriptos.add(alumno)
            alumno.removerMateriaEnEspera(self)
            alumno.materiasEnCurso().add(self)
        }
    }
}

class Estudiante {
    const materiasAprobadas = []
    var property carrerasEnCurso = []
    const materiasInscriptas = [] 
    const materiasEnEspera = []

    method materiasEnCurso(){
        return self.todasLasMateriasDeCarrerasInscriptas().filter({materia => materia.inscriptos().contains(self)})
    }
    method materiasEnCola() {
        return self.todasLasMateriasDeCarrerasInscriptas().filter({materia => materia.listaDeEspera().contains(self)})
    }

    method removerMateriaEnEspera(_materia){
        self.validarSiSePuedeRemover(_materia)
        materiasEnEspera.remove(_materia)
    }

    method validarSiSePuedeRemover(_materia){
        if (not self.sePuedeRemover(_materia))
            self.error ("la materia no esta en la lista de espera")
    }

    method sePuedeRemover(_materia){
        return materiasEnEspera.contains(_materia)
    }

    method aprobaciones(){
        return materiasAprobadas
    }

    method agregarMateriaAprobada(_materia, _nota) {
        self.validarSiAproboMateria(_nota)
        self.validarSiYaSeRegistroMateria(_materia)
        materiasAprobadas.add(new Cursada(materia = _materia, nota = _nota))
    }

    method validarSiAproboMateria(_nota) {
        if (not self.aproboMateria(_nota))
            self.error ("la materia no esta aprobada")
    }

    method aproboMateria(_nota) {
        return _nota >= 4
    }

    method validarSiYaSeRegistroMateria(_materia){
        if (self.tieneAprobada(_materia))
            self.error ("la materia ya esta registrada")
    }

    method cantidadDeMateriasAprobadas() {
      return materiasAprobadas.size()
    }

    method sumaDeNotasAprobadas() {
        return materiasAprobadas.sum({cursada => cursada.nota()})
    }

    method promedio() {
      return self.sumaDeNotasAprobadas().div(self.cantidadDeMateriasAprobadas())
    }

    method tieneAprobada(_materia) {
        return materiasAprobadas.any({cursada => cursada.materia() == _materia })
    }

    method todasLasMateriasDeCarrerasInscriptas() {
        return self.materiasDeCarreras().flatten()
    }

    method materiasDeCarreras() {
        return carrerasEnCurso.map({carrera => carrera.materias()})
    }

    method puedeInscribirseA(_materia) {
        return  self.perteneceACarrerasCursando(_materia)
                and
                not self.tieneAprobada(_materia)
                and 
                not materiasInscriptas.contains(_materia)
                and 
                self.cumpleCorrelativas(_materia)        
    }

    method perteneceACarrerasCursando(_materia) {
        return carrerasEnCurso.any({carrera => carrera.materias().contains(_materia) }) //deberia hacer una subtarea para el contains? Si fuera el caso, esa subatera seria responsabilidad del estudiante?
    }

    method cumpleCorrelativas(_materia) {
        return _materia.correlativas().all({correlativa => self.tieneAprobada(correlativa)})
    }

    method inscribirAMateria(_materia) {
        self.validarSiPuedeInscribirAMateria(_materia)
        if (_materia.cupo() > _materia.inscriptos().size()) {
            _materia.agregarAInscriptos(self)
            materiasInscriptas.add(_materia)
        }
        else
           _materia.agregarAListaDeEspera(self)
           materiasEnEspera.add(_materia)
    }

    method validarSiPuedeInscribirAMateria(_materia) {
        if (not self.puedeInscribirseA(_materia)) {
            self.error ("No cumple los requisitos para anotarse a la materia dada")
        }
    }

    method darDeBajaMateria(_materia) {
        materiasInscriptas.remove(_materia)
        _materia.removerDeInscriptos(self)
        _materia.darCupo()
    }

    method materiasALasQueSePuedeInscribirDe(_carrera) {
       return  _carrera.materias().filter({materia => self.puedeInscribirseA(materia)})
    }
    
}


