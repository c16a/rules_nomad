id        = "database"
name      = "database"
type      = "csi"
plugin_id = "hostpath"

capacity_min = "1GiB"
capacity_max = "10GiB"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
