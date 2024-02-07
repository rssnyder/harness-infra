data "aws_instances" "us_work_hours" {
  instance_tags = {
    Schedule = "us-work-hours"
  }
}

# get all databases with out tag and value
# data "aws_db_instances" "this" {
#   tags = {
#     Schedule = "us-work-hours"
#   }
# }

# create a rule for each instance we find
resource "harness_autostopping_rule_vm" "us_work_hours" {
  for_each           = toset(data.aws_instances.us_work_hours.ids)
  name               = "${each.key} us-work-hours"
  cloud_connector_id = "rileyharnessccm"
  idle_time_mins     = 5
  filter {
    vm_ids = [
      each.key
    ]
    regions = [
      data.aws_instances.us_work_hours.id # region of instances
    ]
  }
}

# create a rule for each database we find
# resource "harness_autostopping_rule_rds" "this" {
#   for_each           = toset(data.aws_db_instances.this.instance_identifiers)
#   name               = "${each.key} us-work-hours"
#   cloud_connector_id = "rileyharnessccm"
#   idle_time_mins     = 5
#   database {
#     id     = each.key
#     region = data.aws_db_instances.this.id
#   }
# }

# create a schedule and attach each rule
resource "harness_autostopping_schedule" "us_work_hours" {
  count         = length(harness_autostopping_rule_vm.us_work_hours) > 0 ? 1 : 0
  name          = "usworkhours"
  schedule_type = "uptime"
  time_zone     = "EST"

  repeats {
    days       = ["MON", "TUE", "WED", "THU", "FRI"]
    start_time = "09:00"
    end_time   = "17:00"
  }

  rules = [for rule in harness_autostopping_rule_vm.us_work_hours : rule.id]
  #   rules = concat([
  #     for rule in harness_autostopping_rule_vm.this : rule.id
  #     ], [
  #     for rule in harness_autostopping_rule_rds.this : rule.id
  #   ])
}