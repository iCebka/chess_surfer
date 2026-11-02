package op_surfer.demo.services;

/*
 * Definimos la clase Apertura para guardar informacion de una apertura de ajedrez
 * Se contiene su codigo de apertura oficial de la FIDE, el nombre largo y la secuencia de jugadas en un log
 */

public class Opening {
    String eco;
    String name;
    String log;

    public Opening() {
    }

    public Opening(String eco, String name, String log) {
        this.eco = eco;
        this.log = log;
        this.name = name;
    }

    public String getEco() {
        return eco;
    }

    public void setEco(String eco) {
        this.eco = eco;
    }

    public String getLog() {
        return log;
    }

    public void setLog(String log) {
        this.log = log;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
