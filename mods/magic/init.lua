--
-- Pressoir à fruit pour créer le jus de nether apple, jus de citrouille.
--

-- déclaration de l'item
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



--*******************



--
-- Jus de pomme du nether, pour créer la potion de base
--

-- déclaration de l'item : dans le mod nether

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
			
			replacements = 
			{
				{"magic:press", "magic:press"},
			},
		
		})



--*******************


	
--
-- Potion base : necessaire pour la confection des autres potions
-- Le craft rempli une fiole d'eau avec le contenu d'une fiole de jus de pomme du nether
-- Le résultat du craft retourne une fiole vide.

-- Déclaration de l'item
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
			replacements = 
			{
				{"nether:nether_apple_juice", "vessels:glass_bottle"},
			},
		})



--*******************		



--
-- Potion de santé niveau 1 : donne 6 Hp à l'utilisateur
-- se craft à partir d'une potion de base et de citrouille
--

-- Déclaration de l'item : dans le mod potionspack
	

-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:healthi",
		
		recipe = {
			{"farming:pumpkin"},
			{"magic:potion_basic"},
		},
		
		replacements = 
		{
			{"magic:potion_basic", "vessels:glass_bottle"},
		},
	})
	
-- Craft inverse à partir d'une potion de santé niveau 2 :
	minetest.register_craft(
	{
		output = "potionspack:healthi",
		
		recipe = {
			{"default:coal_lump"},
			{"potionspack:healthii"},
		}

	})
	

	
--
-- Potion de santé niveau 2 : donne 12 Hp à l'utilisateur
-- se craft à partir d'une potion de santé de niveau 1 et de poussière de glowstone.
--

-- Déclaration de l'item : dans le mod potionspack

-- Craft
minetest.register_craft(
	{
		output = "potionspack:healthii",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:healthi"},
		}
		
	})
	
	

--*******************



--
-- Potion de rapidité niveau 1 : accélère les déplacement de 
-- l'utilisateur
-- se craft à partir d'une potion de base et de sucre
--

-- Déclaration de l'item : dans le mod potionspack
	

-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:speed",
		
		recipe = {
			{"bushes:sugar"},
			{"magic:potion_basic"},
		},
		
		replacements = 
		{
			{"magic:potion_basic", "vessels:glass_bottle"},
		},
	})
	
-- Craft inverse à partir d'une potion de santé niveau 2 :
	minetest.register_craft(
	{
		output = "potionspack:speed",
		
		recipe = {
			{"default:coal_lump"},
			{"potionspack:speedii"},
		}

	})
		

--
-- Potion de rapidité niveau 2 : accélère les déplacements de l'utilisateur
-- se craft à partir d'une potion de vitesse de niveau 1 et de poussière de glowstone.
--

-- Déclaration de l'item : dans le mod potionspack

-- Craft
minetest.register_craft(
	{
		output = "potionspack:speedii",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:speed"},
		}
		
	})



--*******************


--
-- Potion anti gravité niveau 1 : réduit la gravité 
-- se craft à partir d'une potion de base et d'une plume d'oiseau
--

-- Déclaration de l'item : dans le mod potionspack
	

-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:antigravity",
		
		recipe = {
			{"animalmaterials:feather"},
			{"magic:potion_basic"},
		},
		
		replacements = 
		{
			{"magic:potion_basic", "vessels:glass_bottle"},
		},
	})
	
-- Craft inverse à partir d'une potion de santé niveau 2 :
	minetest.register_craft(
	{
		output = "potionspack:antigravity",
		
		recipe = {
			{"default:coal_lump"},
			{"potionspack:antigravityii"},
		}

	})
	

	
--
-- Potion anti gravité niveau 2 : réduit la gravité 
-- se craft à partir d'une potion de base et d'une plume d'oiseau

-- Déclaration de l'item : dans le mod potionspack

-- Craft
minetest.register_craft(
	{
		output = "potionspack:antigravityii",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:antigravity"},
		}
		
	})
