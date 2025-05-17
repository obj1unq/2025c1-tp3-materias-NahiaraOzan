//Hago commit por miedo a que se me corte la luz y no tenga subido nada
class  Cursada {
    const property materia
    const property nota
}

class Carrera {
    const property materias = [] 
}

class Materia {
    const property correlativas = [] 
}

class Estudiante {
    const materiasAprobadas = []
    const property carrerasEnCurso = []
    const materiasInscriptas = [] //Lista de lista de materias por carrera

    method materiasAprobadas(){
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
        return materiasAprobadas.any ({cursada => cursada.materia() == _materia })
    }

    method materiasInscriptas() {
        return materiasInscriptas.flatten() 
    }

    method puedeInscribirseA(_materia) {
        return  self.perteneceACarrerasCursando(_materia)
                and
                not self.tieneAprobada(_materia)
                and 
                not materiasInscriptas.contains(_materia)
                and self.cumpleCorrelativas(_materia)        
    }

    method perteneceACarrerasCursando(_materia) {
        return carrerasEnCurso.any({carrera => carrera.materias().contains(_materia) }) //deberia hacer una subtarea para el contains? Si fuera el caso, esa subatera seria responsabilidad del estudiante?
    }

    method cumpleCorrelativas() {
        return
    }

    
}
