variable "db_parameter_group_name" {
  default = "digdag-pg"
}

variable "db_id" {
  default = "digdag"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_name" {
  default = "digdag"
}

variable "db_username" {
  default = "digdag"
}

variable "db_password" {
  description = "DB のパスワード。環境変数の TF_VAR_db_password から取得"
  type        = string
  default = "digdagdigdag"
}

variable "db_multi_az" {
  default = true
}

variable "db_backup_retention_period" {
  description = "DB バックアップを保持する日数"
  default     = 14
}

variable "db_skip_final_snapshot" {
  description = "DB の最終スナップショットをスキップするか"
  default     = false
}

variable "db_max_pool_size" {
  default = 32
}

