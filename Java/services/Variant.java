package op_surfer.demo.services;

/*
 * Version primitiva de la clase Opening, no se usa en el programa definitivo, pero se la incluye como parte del proceso de desarrollo
 */

public class Variant {
    String log;
    String name;

    public Variant() {
    }

    public Variant(String log, String name) {
        this.log = log;
        this.name = name;
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
