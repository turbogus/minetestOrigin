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

-- ***********************

--
-- Poudre d'os : permet de transformer une potion bénéfique en potion maléfique
--

-- Déclaration de l'item
	minetest.register_craftitem("magic:bone_dust",
		{
			description = " Bone dust",
			wield_image = "bone_dust.png",
			inventory_image = "bone_dust.png",
		})

-- Craft
	minetest.register_craft(
		{
			output = "magic:bone_dust 4",
			recipe = 
				{
					{"magic:press"},
					{"animalmaterials:bone"},
				},
			replacements =
				{
					{"magic:press", "magic:press"},
				},
		})
				
--*******************

-- 
-- Jus de citrouille, permet de crafter la potion de santé niveau 1
--

-- Déclaration de l'item
	minetest.register_craftitem("magic:pumpkin_juice",
		{
			description = "Pumpkin juice",
			inventory_image = "pumpkin_juice.png",
		})

-- Craft
	minetest.register_craft(
		{
			output = "magic:pumpkin_juice",
			recipe = 
				{
					{"magic:press"},
					{"farming:pumpkin"},
					{"vessels:glass_bottle"}
				},
			replacements =
				{
					{"magic:press", "magic:press"},
				},
		})


--*******************

-- 
-- Jus de cactus fermenté, permet de crafter la potion d'inversion
--

-- Déclaration de l'item
	minetest.register_craftitem("magic:cactus_juice",
		{
			description = "Fermented cactus juice",
			inventory_image = "cactus_juice.png",
		})

-- Craft
	minetest.register_craft(
		{
			output = "magic:cactus_juice",
			recipe = 
				{
					{"magic:press"},
					{"default:cactus"},
					{"vessels:glass_bottle"}
				},
			replacements =
				{
					{"magic:press", "magic:press"},
				},
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



--********************
--********************
--********************		



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
			{"magic:pumpkin_juice"},
			{"magic:potion_basic"},
		}
		
		
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
	
-- Craft inverse à partir d'une potion harming niveau 1 :
	minetest.register_craft(
	{
		output = "potionspack:healthi",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:harmingi"},
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

-- Craft inverse à partir d'une potion harming niveau 2 et de poussière de glowstone
minetest.register_craft(
	{
		output = "potionspack:healthii",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:harmingii"},
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
		}
		
		
	})
	
-- Craft inverse à partir d'une potion de vitesse niveau 2 :
	minetest.register_craft(
	{
		output = "potionspack:speed",
		
		recipe = {
			{"default:coal_lump"},
			{"potionspack:speedii"},
		}

	})
	
-- Craft inverse à partir d'une potion d'inversion et de poussière de glowstone

	minetest.register_craft(
	{
		output = "potionspack:speed",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:inversion"},
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
		}
		
	
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
	
-- Craft inverse à partir d'une potion de confusion :
	minetest.register_craft(
	{
		output = "potionspack:antigravity",
		
		recipe = {
			{"nether:glowstone_dust"},
			{"potionspack:confusion"},
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
	


--********************
--********************
--********************

--
-- Potion de confusion : rend aléatoire les déplacements du joueur 
-- se craft à partir d'une potion de base et d'un os de zombi
--

-- Déclaration de l'item : dans le mod potionspack
	
-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:confusion",
		
		recipe = {
			{"animalmaterials:bone"},
			{"magic:potion_basic"},
		}
		
		
	})
	
-- Craft inverse à partir d'une potion antigravité e tde poussière d'os :
	minetest.register_craft(
	{
		output = "potionspack:confusion",
		
		recipe = {
			{"magic:bone_dust"},
			{"potionspack:antigravity"},
		}

	})

--*******************************

--
-- Potion harming niveau 1 : retire  6 points de vie
-- se craft avec de la viande de zombi
--

-- Déclaration de l'item : dans le mod potionspack
	
-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:harmingi",
		
		recipe = {
			{"animalmaterials:meat_undead"},
			{"magic:potion_basic"},
		}
		
	
	})
	
-- Craft inverse à partir d'une potion harming niveau 2 et de coal:
	minetest.register_craft(
	{
		output = "potionspack:harmingi",
		
		recipe = {
			{"default:coal_lump"},
			{"potionspack:healthii"},
		}

	})
	
-- Craft inverse à partir d'une potion health niveau 1 et de poussière d'os :
	minetest.register_craft(
	{
		output = "potionspack:harmingi",
		
		recipe = {
			{"magic:bone_dust"},
			{"potionspack:healthi"},
		}

	})
	
--*************************
	
--
-- Potion harming niveau 2 : retire  12 points de vie
-- se craft avec de la viande de zombi
--

-- Déclaration de l'item : dans le mod potionspack
	
-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:harmingii",
		
		recipe = {
			{"animalmaterials:meat_undead"},
			{"animalmaterials:meat_undead"},
			{"magic:potion_basic"},
		}
		
	
	})
		
-- Craft inverse à partir d'une potion health niveau 1 et de poussière d'os :
	minetest.register_craft(
	{
		output = "potionspack:harmingii",
		
		recipe = {
			{"magic:bone_dust"},
			{"potionspack:healthii"},
		}

	})
	
--*************************
	
--
-- Potion d'inversion : inverse les commandes du joueur
-- se craft avec du jus de cactus fermenté
--

-- Déclaration de l'item : dans le mod potionspack
	
-- Craft 
	minetest.register_craft(
	{
		output = "potionspack:inversion",
		
		recipe = {
			{"magic:cactus_juice"},
			{"magic:potion_basic"},
		},
		
		replacements = 
		{
			{"magic:potion_basic", "vessels:glass_bottle"},
		},
	})
		
-- Craft inverse à partir d'une potion de vitesse I et de poussière d'os :
	minetest.register_craft(
	{
		output = "potionspack:inversion",
		
		recipe = {
			{"magic:bone_dust"},
			{"potionspack:speed"},
		}

	})

--******************************
--******************************
--******************************

-- 
-- Potion aleatoire " mais que va faire cette potion ?", produit un effet aléatoire sur
-- le joueur. Se fabrique en mélanger de la poussière de glowstone et de la poudre d'os 
-- à une potion de base. 
-- NB : aucun craft inverse possible avec cette potion !
--

-- Déclaration : dans le mod potionspack

-- Craft :
	minetest.register_craft(
	{
		output = "potionspack:whatwillthisdo",
		
		recipe = {
			{"magic:bone_dust"},
			{"nether:glowstone_dust"},
			{"magic:potion_basic"},
		}
		
	
	})

	
