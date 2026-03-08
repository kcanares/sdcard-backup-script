#!/bin/bash
# update these as needed
CAMERA_SUBFOLDER="DCIM/106RICOH"
CLOUD_PROVIDER="onedrive"
UDEV_UUID="3232-6238"
USER_NAME="kyla"

REMOTE="$CLOUD_PROVIDER:Photos/$CAMERA_SUBFOLDER"
CONFIG="/home/$USER_NAME/.config/rclone/rclone.conf"
UPLOADED_LOG="/home/$USER_NAME/.sdcard-uploaded"
MOUNT_POINT="/media/$USER_NAME/$UDEV_UUID/$CAMERA_SUBFOLDER"

# Check the SD card mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
  echo "[$(date)] Could not find mount point, aborting."
  exit 1
fi

# Build rclone command, skipping already-uploaded files if we have a record
if [ -f "$UPLOADED_LOG" ]; then
  echo "[$(date)] Skipping files in uploaded log..."
  EXCLUDE_ARGS="--exclude-from $UPLOADED_LOG"
else
  echo "[$(date)] No upload log found, uploading everything..."
  EXCLUDE_ARGS=""
fi

# Copy to OneDrive
rclone copy "$MOUNT_POINT" "$REMOTE" \
  --config "$CONFIG" \
  --log-level INFO \
  --ignore-existing \
  $EXCLUDE_ARGS

# Append newly uploaded files to the permanent record
rclone lsf "$REMOTE" --config "$CONFIG" >>"$UPLOADED_LOG"

# Deduplicate the log
sort -u "$UPLOADED_LOG" -o "$UPLOADED_LOG"

echo "[$(date)] Backup complete."
