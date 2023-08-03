resource "shoreline_notebook" "mongodb_number_cursors_open_incident" {
  name       = "mongodb_number_cursors_open_incident"
  data       = file("${path.module}/data/mongodb_number_cursors_open_incident.json")
  depends_on = [shoreline_action.invoke_mongodb_cursors_and_connection_pooling]
}

resource "shoreline_file" "mongodb_cursors_and_connection_pooling" {
  name             = "mongodb_cursors_and_connection_pooling"
  input_file       = "${path.module}/data/mongodb_cursors_and_connection_pooling.sh"
  md5              = filemd5("${path.module}/data/mongodb_cursors_and_connection_pooling.sh")
  description      = "Reduce the number of open cursors in MongoDB"
  destination_path = "/agent/scripts/mongodb_cursors_and_connection_pooling.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mongodb_cursors_and_connection_pooling" {
  name        = "invoke_mongodb_cursors_and_connection_pooling"
  description = "Reduce the number of open cursors in MongoDB"
  command     = "`chmod +x /agent/scripts/mongodb_cursors_and_connection_pooling.sh && /agent/scripts/mongodb_cursors_and_connection_pooling.sh`"
  params      = ["MONGODB_USER","MONGODB_PASSWORD","POOL_SIZE","MONGODB_INSTANCE"]
  file_deps   = ["mongodb_cursors_and_connection_pooling"]
  enabled     = true
  depends_on  = [shoreline_file.mongodb_cursors_and_connection_pooling]
}

