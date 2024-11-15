locals {
  valid_characters = ["beavis", "cheese", "cow", "daemon", "dragon", "fox", "ghostbusters", "kitty",
    "meow", "miki", "milk", "octopus", "pig", "stegosaurus", "stimpy", "trex",
  "turkey", "turtle", "tux"]
  character_types = {
    animals         = ["cow", "fox", "kitty", "meow", "octopus", "pig", "stegosaurus", "trex", "turkey", "turtle", "tux"]
    mythical_animal = ["daemon", "dragon", ]
    silly           = ["cheese", "milk"]
    pop_culture     = ["beavis", "ghostbusters", "stimpy", "miki"]
  }
}

variable "character" {
  type    = string
  default = "cow"
  validation {
    condition = contains(["beavis", "cheese", "cow", "daemon", "dragon", "fox", "ghostbusters", "kitty",
      "meow", "miki", "milk", "octopus", "pig", "stegosaurus", "stimpy", "trex",
    "turkey", "turtle", "tux"], var.character)
    error_message = "Invalid character!"
  }
}

output "my_input_character" {
  value = var.character
}

variable "character_count" {
  type    = number
  default = 1
}

resource "random_shuffle" "character" {
  count        = var.character_count
  input        = local.valid_characters
  result_count = 1
}

# output "random" {
#   value = random_shuffle.character
# }

output "my_characters" {
  value = random_shuffle.character[*].result[0]
}

resource "random_shuffle" "character_type" {
  for_each     = local.character_types
  input        = each.value
  result_count = 1
}

output "my_characters_by_type" {
  value = { for k, v in random_shuffle.character_type : k => v.result[0] }
}
