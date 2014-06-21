--
-- Pressoir à fruit pour créer le jus de nether apple, jus de citrouille.
--

-- déclaration
	minetest.register_craftitem("magic:press", 
		{
			description = "Press",
			wield_image = "press.png",
			inventory_image = "press.png",
		})
	
	
-- craft
	minetest.register_craft(
		{
			output = "magic:press",
			recipe = 
				{
					{"","group:stick",""},
					{"group:wood","group:stone","group:wood"},
					{"group:wood","group:wood","group:wood"},
				}
		})

--
-- Jus de pomme du nether, pour créer la potion de base
--

-- déclaration
	-- dans le mod nether

-- craft
	minetest.register_craft(
		{
			output = "nether:nether_apple_juice",
			
			recipe =
			{
				{"magic:press"},
				{"nether:nether_apple"},
				{"vessels:glass_bottle"},
			},
			
			replacement = {"magic:press", "magic:press"},
		
		})
	
--
-- Potion base : necessaire pour la confection des autres potions
-- Le craft rempli une fiole d'eau avec le contenu d'une fiole de jus de pomme du nether
-- Le résultat du craft retourne une fiole vide.

-- Déclaration
	minetest.register_craftitem("magic:potion_basic", 
		{
			description = "basic potion",
			inventory_image = "potion_basic.png",
		})
	

-- Craft
	minetest.register_craft(
		{
			output = 'magic:potion_basic',
			recipe = 
			{
				{'nether:nether_apple_juice'},
				{'vessels:glass_bottle_water'},
			},
			replacement = {"nether:nether_apple_juice", "vessels:glass_bottle"},
		})
