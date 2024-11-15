locals {
  song = "Where is my mind?"
}

resource "random_pet" "mypet" {

}

output "mypet" {
  value = random_pet.mypet.id
}
