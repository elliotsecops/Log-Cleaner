#!/bin/bash
set -x

# Configuration
LOG_DIR="/var/log"
ARCHIVE_DIR="/var/log/archive"
DAYS_OLD=7
REPORT_FILE="/tmp/log_cleaner_report.txt"

# Ensure the archive directory exists
mkdir -p "$ARCHIVE_DIR"

# Identify old log files
OLD_LOGS=$(find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS_OLD)

# Initialize report
REPORT="Log Cleaner Report\n\n"
total_size_before=0
total_size_after=0
files_processed=0

# Process each old log file
for LOG_FILE in $OLD_LOGS; do
    # Get original file size
    file_size_before=$(du -k "$LOG_FILE" | cut -f1)
    total_size_before=$((total_size_before + file_size_before))

    # Compress the log file
    if gzip -9 "$LOG_FILE"; then
        REPORT+="Compressed: $LOG_FILE\n"
        
        # Move the compressed file to the archive directory
        if mv "${LOG_FILE}.gz" "$ARCHIVE_DIR/"; then
            REPORT+="Moved to archive: ${LOG_FILE}.gz\n"

            # Get compressed file size
            file_size_after=$(du -k "$ARCHIVE_DIR/${LOG_FILE}.gz" | cut -f1)
            total_size_after=$((total_size_after + file_size_after))

            # Delete the original log file
            rm -f "$LOG_FILE"
            REPORT+="Deleted original: $LOG_FILE\n"
        else
            REPORT+="ERROR: Failed to move ${LOG_FILE}.gz to archive\n"
            # Log the error to a separate file for further investigation
            echo "ERROR: Failed to move ${LOG_FILE}.gz to archive" >> /tmp/log_cleaner_errors.txt
        fi
    else
        REPORT+="ERROR: Failed to compress: $LOG_FILE\n"
        # Log the error to a separate file for further investigation
        echo "ERROR: Failed to compress $LOG_FILE" >> /tmp/log_cleaner_errors.txt
    fi

    files_processed=$((files_processed + 1))
done

# Calculate space saved
space_saved=$((total_size_before - total_size_after))

# Output the report
echo -e "$REPORT" > "$REPORT_FILE"
echo "Total files processed: $files_processed" >> "$REPORT_FILE"
echo "Total size before: $((total_size_before / 1024))MB" >> "$REPORT_FILE"
echo "Total size after: $((total_size_after / 1024))MB" >> "$REPORT_FILE"
echo "Total space saved: $((space_saved / 1024))MB" >> "$REPORT_FILE"

# Display report path
echo "Log cleaning complete. Report saved to: $REPORT_FILE"
echo "Any errors encountered are logged in: /tmp/log_cleaner_errors.txt"