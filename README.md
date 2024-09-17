# Script de Limpieza de Logs

## Descripción

Script hecho en Bash minimalista diseñado para limpiar y comprimir archivos de registro (logs) antiguos para liberar espacio en disco. Este script realiza las siguientes tareas:

1. **Identificar Archivos de Registro Antiguos**: Encuentra archivos de registro más antiguos que un número específico de días.
2. **Comprimir Archivos de Registro Antiguos**: Comprime los archivos de registro antiguos identificados utilizando `gzip`.
3. **Mover Archivos Comprimidos**: Mueve los archivos de registro comprimidos a un directorio de archivo.
4. **Eliminar Archivos de Registro Originales**: Elimina los archivos de registro originales para liberar espacio.
5. **Generar un Informe**: Genera un informe detallando las acciones realizadas.

## Características

- **Manejo de Errores**: El script incluye manejo de errores para los comandos `gzip` y `mv`. Si alguno de estos comandos falla, se registra un mensaje de error.
- **Registro**: El script escribe un informe detallado en un archivo de registro y registra cualquier error encontrado durante el proceso.
- **Retroalimentación al Usuario**: Proporciona una salida informativa, incluyendo el número de archivos procesados, el tamaño total antes y después de la compresión, y la cantidad de espacio en disco ahorrado.

## Requisitos Previos

- **Bash**: El script está escrito en Bash y requiere un shell Bash para ejecutarse.
- **gzip**: El script utiliza `gzip` para la compresión de archivos.
- **Permisos**: Asegúrate de que el script tenga los permisos necesarios para leer, escribir y eliminar archivos en los directorios especificados.

## Configuración

El script utiliza las siguientes variables de configuración:

- `LOG_DIR`: El directorio donde se almacenan los archivos de registro.
- `ARCHIVE_DIR`: El directorio donde se moverán los archivos de registro comprimidos.
- `DAYS_OLD`: El número de días después de los cuales un archivo de registro se considera antiguo.
- `REPORT_FILE`: El archivo donde se guardará el informe.

## Uso

1. **Clonar el Repositorio**:
   ```bash
   git clone https://github.com/elliotsecops/log-cleaner.git
   cd log-cleaner
   ```

2. **Hacer el Script Ejecutable**:
   ```bash
   chmod +x log_cleaner.sh
   ```

3. **Ejecutar el Script**:
   ```bash
   sudo ./log_cleaner.sh
   ```

4. **Verificar el Informe**:
   - El informe se guardará en `/tmp/log_cleaner_report.txt`.
   - Cualquier error encontrado se registrará en `/tmp/log_cleaner_errors.txt`.

## Ejemplo de Salida

Después de ejecutar el script, puedes verificar el archivo de informe para obtener información detallada:

```bash
cat /tmp/log_cleaner_report.txt
```

Ejemplo de contenido del informe:

```
Informe de Limpieza de Logs

Comprimido: /var/log/fontconfig.log
Movido al archivo: /var/log/archive/fontconfig.log.gz
Eliminado original: /var/log/fontconfig.log
Total de archivos procesados: 1
Tamaño total antes: 1MB
Tamaño total después: 0MB
Espacio total ahorrado: 1MB
```

## Contribuciones

¡Las contribuciones son bienvenidas!

## Autor

- [ElliotSecOps](https://github.com/elliotsecops)

---

# Log Cleaner Script

## Description

The `log_cleaner.sh` script is a minimalistic Bash script designed to clean and compress old log files to free up disk space. This script performs the following tasks:

1. **Identify Old Log Files**: Finds log files older than a specified number of days.
2. **Compress Old Log Files**: Compresses the identified old log files using `gzip`.
3. **Move Compressed Files**: Moves the compressed log files to an archive directory.
4. **Delete Original Log Files**: Deletes the original log files to free up space.
5. **Generate a Report**: Generates a report detailing the actions performed.

## Features

- **Error Handling**: The script includes error handling for `gzip` and `mv` commands. If either command fails, an error message is logged.
- **Logging**: The script writes a detailed report to a log file and logs any errors encountered during the process.
- **User Feedback**: Provides informative output, including the number of files processed, total size before and after compression, and the amount of disk space saved.

## Prerequisites

- **Bash**: The script is written in Bash and requires a Bash shell to run.
- **gzip**: The script uses `gzip` for file compression.
- **Permissions**: Ensure the script has the necessary permissions to read, write, and delete files in the specified directories.

## Configuration

The script uses the following configuration variables:

- `LOG_DIR`: The directory where log files are stored.
- `ARCHIVE_DIR`: The directory where compressed log files will be moved.
- `DAYS_OLD`: The number of days after which a log file is considered old.
- `REPORT_FILE`: The file where the report will be saved.

## Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/elliotsecops/log-cleaner.git
   cd log-cleaner
   ```

2. **Make the Script Executable**:
   ```bash
   chmod +x log_cleaner.sh
   ```

3. **Run the Script**:
   ```bash
   sudo ./log_cleaner.sh
   ```

4. **Check the Report**:
   - The report will be saved to `/tmp/log_cleaner_report.txt`.
   - Any errors encountered will be logged to `/tmp/log_cleaner_errors.txt`.

## Example Output

After running the script, you can check the report file for detailed information:

```bash
cat /tmp/log_cleaner_report.txt
```

Example report content:

```
Log Cleaner Report

Compressed: /var/log/fontconfig.log
Moved to archive: /var/log/archive/fontconfig.log.gz
Deleted original: /var/log/fontconfig.log
Total files processed: 1
Total size before: 1MB
Total size after: 0MB
Total space saved: 1MB
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or improvements.

## Author

- [ElliotSecOps](https://github.com/elliotsecops)

