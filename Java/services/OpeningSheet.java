package op_surfer.demo.services;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


public class OpeningSheet {

    static String ruta = "src/main/java/op_surfer/demo/services/openings_sheet.csv";

    public void imprimirTodo(){
        int n = 0;
        String csvFile = "openings_sheet.csv"; // Nombre del archivo CSV en el mismo directorio
        String currentDir = System.getProperty("user.dir"); // Directorio de trabajo actual

        try (BufferedReader reader = new BufferedReader(new FileReader(currentDir + "\\" + csvFile))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null && n < 2000) {
                if (lineNumber > 0) { // Saltar la primera línea (encabezados)
                    String[] elements = line.split(",");
                    int size = elements.length;
                    if (size >= 3) { // Verificar que haya al menos 3 elementos
                        String eco = elements[0].trim();
                        String name = elements[1].trim();
                        String moves = elements[size-1].trim();
                        System.out.printf("%-10s %-35s %-10s%n", eco, name, moves);
                    }
                }
                lineNumber++;
                n++;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        String look = "e4 c6";//"a3 e5 h3 d5";
        //archivo_csv = 'data/openings_sheet.csv'
        try{
        Map<Boolean, String> hola = buscar(look, ruta);
        System.out.println(hola.toString());
        Map<String,String> hello = buscarVariantes(look, ruta);
        System.out.println(hello.toString());
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*def buscar(log, ruta):
    flag = False
    with open(ruta, 'r') as csv_file:
        lector = csv.reader(csv_file)
        next(lector)
        for linea in lector:
            campo1, campo2, campo3 = procesar_linea(linea)
            #print( campo1, campo2, campo3)
            if (log == campo3):
                flag = True
                #print("Posicion detectada: " + campo2[0])
                break
    csv_file.close()
    return flag, campo2*/

    public static Map<Boolean, String> buscar(String log, String ruta) throws IOException {
        boolean flag = false;
        String el = null;
        try (BufferedReader reader = new BufferedReader(new FileReader("src/main/java/op_surfer/demo/services/openings_sheet.csv"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] campos = line.split(","); // Separar la línea por comas
                //String campo1 = campos[0];
                String campo2 = campos[1];
                String campo3 = campos[campos.length-1];
                if (log.equals(campo3)) {
                    flag = true;
                    System.out.println("posicion detectada: " + campo2.charAt(0));
                    el = campo3;
                    break;
                }
            }
        }
        Map<Boolean, String> resultado = new HashMap<>();
        resultado.put(flag, el);
        return resultado;
    }

    public static Map<String, String> buscarVariantes(String log, String ruta) {
        Map<String, String> variantes = new HashMap<>();
        String ECO = "";
        boolean flag = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(ruta))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] campos = line.split(",");
                String campo1 = campos[0];
                String campo2 = campos[1];
                String campo3 = campos[campos.length-1];

                if (log.equals(campo3)) {
                    ECO = campo1;
                    flag = true;
                }

                if (campo1.equals(ECO)) {
                    variantes.put(campo1, campo2);
                    System.out.println(campo1 + ": " + campo2 + ". Jugadas: " + campo3);
                } else if (flag) {
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return variantes;
    }
}
