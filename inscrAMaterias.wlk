class  Aprobada {
    var property materia
    var property nota

    method esDe(_materia){
        return materia == _materia
    }
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
        
        if (self.cupo() > self.inscriptos().size()) {
            inscriptos.add(alumno)
        }
        else
            listaDeEspera.add(alumno)
           
    }
    
   
    method darCupo(){
        if (not listaDeEspera.isEmpty()){
            const alumno = listaDeEspera.first()
            inscriptos.add(alumno)
            listaDeEspera.remove(alumno)
        }
    }

    method darDeBaja(alumno){
        inscriptos.remove(alumno)
        self.darCupo()
    }
}

class Estudiante {
    const materiasAprobadas = [] //Lista de objetos aprobada
    var property carrerasEnCurso = [] 

    method agregarMateriaAprobada(materia, nota) {
        self.validarSiYaSeRegistroMateria(materia)
        materiasAprobadas.add(new Aprobada(materia = materia, nota = nota))
    }

    method validarSiYaSeRegistroMateria(materia){
        if (self.tieneAprobada(materia))
            self.error ("la materia ya esta registrada")
    }

    method cantidadDeMateriasAprobadas() {
      return materiasAprobadas.size()
    }

    method sumaDeNotasAprobadas() {
        return materiasAprobadas.sum({aprobada => aprobada.nota()})
    }

    method promedio() {
      return self.sumaDeNotasAprobadas().div(self.cantidadDeMateriasAprobadas())
    }

    method tieneAprobada(materia) {
        return materiasAprobadas.any({aprobada => aprobada.esDe(materia) }) 
    }

    method todasLasMateriasDeCarrerasInscriptas() {
        return carrerasEnCurso.flatMap({carrera => carrera.materias()})
    }

    method puedeInscribirseA(materia) {
        return  self.perteneceACarrerasCursando(materia)
                and
                not self.tieneAprobada(materia)
                and 
                self.cumpleCorrelativas(materia)      
    }

    method perteneceACarrerasCursando(_materia) {
        return carrerasEnCurso.any({carrera => carrera.materias().contains(_materia) }) 
    }

    method cumpleCorrelativas(materia) {
        return materia.correlativas().all({correlativa => self.tieneAprobada(correlativa)})
    }

    method inscribirAMateria(materia) {
        self.validarSiPuedeInscribirAMateria(materia)
        materia.agregarAInscriptos(self)
    }

    method validarSiPuedeInscribirAMateria(_materia) {
        if (not self.puedeInscribirseA(_materia)) {
            self.error ("No cumple los requisitos para anotarse a la materia dada")
        }
    }

    method materiasALasQueSePuedeInscribirDe(_carrera) {
       return  _carrera.materias().filter({materia => self.puedeInscribirseA(materia)})
    }
    
}


