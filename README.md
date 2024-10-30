# Log Cleaner

This script cleans and compresses old log files to free up disk space. It identifies log files older than a specified number of days, compresses them with `gzip`, moves them to an archive directory, and generates a summary report.

## Features

- **Automated Cleaning:** Automatically identifies and compresses old log files.
- **Configurable:** Customize log directory, archive directory, and age threshold.
- **Compression:** Uses `gzip` for efficient disk space savings.
- **Archiving:** Moves compressed logs to a dedicated archive directory.
- **Detailed Reporting:** Provides a summary of processed files, sizes, and space saved.
- **Robust Error Handling:** Extensive error checking and logging for reliability.
- **Safe File Operations:** Ensures successful compression and move before deleting originals.

## Usage

1. **Clone:**
   ```bash
   git clone https://github.com/elliotsecops/Log-Cleaner.git
   cd Log-Cleaner
   ```

2. **Make Executable:**
   ```bash
   chmod +x log_cleaner.sh
   ```

3. **Run:**
   ```bash
   sudo ./log_cleaner.sh [LOG_DIR] [ARCHIVE_DIR] [DAYS_OLD]
   ```

   - **`LOG_DIR`**: Directory containing log files (default: `/var/log`).
   - **`ARCHIVE_DIR`**: Directory to store compressed logs (default: `/var/log/archive`).
   - **`DAYS_OLD`**: Age threshold for compression (default: 7 days).

   **Example (Custom Configuration):**
   ```bash
   sudo ./log_cleaner.sh /var/log/myapp /var/log/myapp/archive 30
   ```

## Log Files

- **Report:** `/tmp/log_cleaner_report.txt`
- **Errors:** `/tmp/log_cleaner_errors.txt`

## Dependencies

- `bash`
- `gzip`
- `find`
- `stat`
- `awk`

## Contributing

Contributions are welcome! Open an issue or submit a pull request.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
