package op_surfer.demo.services;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ServicioRestApplication {
    @GetMapping(value="/holamundo")
    public String getHolaMundo(@RequestParam Optional<String> nombre){
        String value=nombre.orElse("");
        /*if (value.equals("")){
            throw new IllegalArgumentException("El parametro nombre es requerido.");
        }
        else {*/
            return "Hola " + value;
        //S}
    }

    @GetMapping(value="/aperturas", produces = "application/json")
    public List<Opening> buscar_todo(){
        int n = 0;
        //String ruta = "lib/model/openings_sheet.csv";
        //String csvFile = "openings_sheet.csv"; // Nombre del archivo CSV en el mismo directorio
        //String currentDir = System.getProperty("user.dir"); // Directorio de trabajo actual
        List<Opening>openings = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader("src/main/java/op_surfer/demo/services/openings_sheet.csv"))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null && n < 200) {
                if (lineNumber > 0) { // Saltar la primera línea (encabezados)
                    String[] elements = line.split(",");
                    int size = elements.length;
                    if (size >= 3) { // Verificar que haya al menos 3 elementos
                        String eco = elements[0].trim();
                        String name = elements[1].trim();
                        String moves = elements[size-1].trim();
                        //System.out.printf("%-10s %-35s %-10s%n", eco, name, moves);
                        openings.add(new Opening(eco, name, moves));
                    }
                }
                lineNumber++;
                n++;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return openings;
    }

    @GetMapping(value="/variantes", produces = "application/json")
    public static List<Opening> buscarVariantes(@RequestParam String log) {
        if (log.length() > 0){
            List<Opening>variantes = new ArrayList<>();
            log = log.replace('_', ' ');
            log = log.substring(0, log.length() - 1);
            String ECO = "";
            boolean flag = false;
            String campo1;
            String campo2;
            String campo3;

            try (BufferedReader reader = new BufferedReader(new FileReader("src/main/java/op_surfer/demo/services/openings_sheet.csv"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] campos = line.split(",");
                    campo1 = campos[0];
                    campo2 = campos[1];
                    campo3 = campos[campos.length-1];

                    if (log.equals(campo3)) {
                        ECO = campo1;
                        flag = true;
                    }

                    if (campo1.equals(ECO)) {
                        variantes.add(new Opening(campo1, campo2, campo3));
                        //System.out.println(campo1 + ": " + campo2 + ". Jugadas: " + campo3);
                    } else if (flag) {
                        break;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println(variantes);
            return variantes;
        }
        else{
            return null;
        }
    }
    
    @GetMapping(value="/buscarlinea")
    public static String buscarLinea(@RequestParam String log) {
        if (log.length()  == 0){
            return "Standard Position";
        }
        if (log.length() > 0){
            log = log.replace('_', ' ');
            log = log.substring(0, log.length() - 1);
            String campo1;
            String campo2;
            String campo3;

            try (BufferedReader reader = new BufferedReader(new FileReader("src/main/java/op_surfer/demo/services/openings_sheet.csv"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] campos = line.split(",");
                    campo1 = campos[0];
                    campo2 = campos[1];
                    campo3 = campos[campos.length-1];

                    if (log.equals(campo3)) {
                        return (String.format("%s : %s", campo1, campo2));
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            return "Unidentified position";
        }
        else{
            return null;
        }
    }
}
