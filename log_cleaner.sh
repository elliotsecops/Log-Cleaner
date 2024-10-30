#!/bin/bash

# Configuration (with defaults and command-line argument parsing)
LOG_DIR="${1:-/var/log}"
ARCHIVE_DIR="${2:-/var/log/archive}"
DAYS_OLD="${3:-7}"
REPORT_FILE="/tmp/log_cleaner_report.txt"
ERROR_FILE="/tmp/log_cleaner_errors.txt"

# Function to log messages with timestamps (stderr for errors)
log() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >&2 
}

# Create archive directory (handle existing file and mkdir failure)
if [[ -f "$ARCHIVE_DIR" ]]; then
    log "Error: $ARCHIVE_DIR exists and is a file."
    exit 1
elif ! mkdir -p "$ARCHIVE_DIR"; then
    log "Error creating archive directory: $ARCHIVE_DIR"
    exit 1
fi

# Find old log files (null-terminated for safe filename handling)
find "$LOG_DIR" -type f -mtime +"$DAYS_OLD" -print0 | while IFS= read -r -d $'\0' log_file; do
    log "Processing: $log_file" >> "$REPORT_FILE"

    # Get original size (handle stat errors)
    original_size=$(stat -c%s "$log_file" 2>/dev/null)
    if [[ -z "$original_size" ]]; then
        log "Error getting size of: $log_file" >> "$ERROR_FILE"
        continue
    fi

    archived_file="$ARCHIVE_DIR/$(basename "$log_file").gz"

    # Compress (handle gzip errors)
    if gzip -c "$log_file" > "$archived_file"; then
        compressed_size=$(stat -c%s "$archived_file" 2>/dev/null)
        if [[ -z "$compressed_size" ]]; then
            log "Error getting compressed size of: $archived_file" >> "$ERROR_FILE"
            continue
        fi

        space_saved=$((original_size - compressed_size))

        # Delete original (handle rm errors)
        if rm "$log_file"; then
            log "Compressed and moved: $log_file (Original: $original_size bytes, Compressed: $compressed_size bytes, Saved: $space_saved bytes)" >> "$REPORT_FILE"
        else
            log "Error deleting original file: $log_file" >> "$ERROR_FILE"
            # Consider moving the compressed file back or handling the orphaned .gz
            if mv "$archived_file" "$log_file"; then
                log "Restored original file: $log_file" >> "$ERROR_FILE"
            else
                log "Error restoring original file: $log_file" >> "$ERROR_FILE"
            fi
        fi
    else
        log "Error compressing: $log_file" >> "$ERROR_FILE"
    fi
done

# Summary Report (with total calculations and formatted output)
total_original_size=0       # Initialize to 0
total_compressed_size=0     # Initialize to 0
total_space_saved=0         # Initialize to 0

# Iterate through the report file to calculate totals (more robust than grep/awk)
while read -r line; do
  if [[ "$line" == *"Original:"* ]]; then
    original_size=$(echo "$line" | awk '{print $NF}')
    total_original_size=$((total_original_size + original_size))
  elif [[ "$line" == *"Compressed:"* ]]; then
    compressed_size=$(echo "$line" | awk '{print $NF}')
    total_compressed_size=$((total_compressed_size + compressed_size))
  fi
done < "$REPORT_FILE"

total_space_saved=$((total_original_size - total_compressed_size))

log "--------------------" >> "$REPORT_FILE"
log "Summary:" >> "$REPORT_FILE"
printf "Total Original Size: %d bytes\n" "$total_original_size" >> "$REPORT_FILE"  # Formatted output
printf "Total Compressed Size: %d bytes\n" "$total_compressed_size" >> "$REPORT_FILE" # Formatted output
printf "Total Space Saved: %d bytes\n" "$total_space_saved" >> "$REPORT_FILE"      # Formatted output

# Exit status based on error file
if [[ -s "$ERROR_FILE" ]]; then
    log "Errors encountered. See $ERROR_FILE for details."
    exit 1
else
    log "Log cleaning completed successfully."
    exit 0
fi
