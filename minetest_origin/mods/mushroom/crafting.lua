
minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:brown_essence",
         recipe = { "mushroom:brown" , "vessels:glass_bottle" },
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:poison",
         recipe = { "mushroom:red" , "vessels:glass_bottle" },
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:identifier",
         recipe = { "default:steel_ingot" },
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:spore_brown",
         recipe = { "mushroom:identifier" , "mushroom:spore1" },
         replacements = {
             { 'mushroom:identifier', 'mushroom:identifier' }
         }
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:spore_red",
         recipe = { "mushroom:identifier" , "mushroom:spore2" },
         replacements = {
             { 'mushroom:identifier', 'mushroom:identifier' }
         }
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:spore_red 2",
         recipe = { "mushroom:identifier" , "mushroom:red" },
         replacements = {
             { 'mushroom:identifier', 'mushroom:identifier' }
         }
})


minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:spore_brown 2",
         recipe = { "mushroom:identifier" , "mushroom:brown" },
         replacements = {
             { 'mushroom:identifier', 'mushroom:identifier' }
         }
})
