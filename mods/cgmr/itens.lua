--[[
  Itens cobertos neste arquivo:
  - Placa sinal do local de aprendizado
  - Conjunto de aprendizado que utiliza a placa na produção
--]]

-- ====================================== Detalhes ===========================================
-- Placa
minetest.register_node("cgmr:placa", {
  description = "Craft Sign",
  drawtype = "signlike",
  tiles = {"cgmr_placa.png"},
  inventory_image = "cgmr_placa.png",
  paramtype = 'light',
  paramtype2 = "wallmounted",
  sunlight_propagates = true,
  walkable = false,
  groups = {choppy=2,dig_immediate=2},
  --sounds = default.node_sound_defaults(),
  selection_box = {
    type = "wallmounted",
  },
})

-- craft pc
minetest.register_node("cgmr:pc", {
  description = "Craft PC",
  drawtype = "nodebox",
  tiles = {
    "cgmr_pc_cinza.png",
    "cgmr_pc_cinza.png",
    "cgmr_pc_cinza.png",
    "cgmr_pc_cinza.png",
    "cgmr_pc_preto.png",
--    "cgmr_pc_tela_a.png",
    {name="cgmr_pc_tela_a.png", animation={type="vertical_frames",aspect_w=64, aspect_h=64, length=5.0, frame_speed=25}},
  },
  paramtype = 'light',
  paramtype2 = "facedir",
  sunlight_propagates = true,
  walkable = false,
  selection_box = {type="regular"},
  groups = {choppy=2,dig_immediate=2},

  node_box = {
    type = "fixed",
    fixed = {
      {-1.0000000e-1,-0.45259861,2.5136044e-2, 0.10000000,-2.5986075e-3,-2.4863956e-2},
      {-0.40006064,-0.25615262,-0.13023723, -0.37006064,0.26767738,-0.16023723},
      {0.37054221,-0.25615274,-0.13023723, 0.40054221,0.26767750,-0.16023723},
      {-0.40000000,-0.30600000,-0.13023723, 0.40000000,-0.25600000,-0.16023723},
      {-0.40000000,0.26433021,-0.12945597, 0.40000000,0.29433021,-0.15945597},
      {-0.35000000,-0.25514168,-2.9045502e-2, 0.35000000,0.24485832,-7.9045502e-2},
      {-0.40000000,-0.30617002,-8.0237234e-2, 0.40000000,0.29382998,-0.13023723},
      {-0.25000000,-0.50000000,0.25000000, 0.25000000,-0.45000000,-0.25000000}
    },
  },
  --sounds = default.node_sound_defaults(),
  on_construct = cgmr.construtor,
  on_punchnode = function(pos, node, puncher)
    cgmr.construtor(pos)
  end,
  on_rightclick=function(pos, node, puncher)
    cgmr.construtor(pos)
  end,
  on_receive_fields = cgmr.inventario_receber_campos,
  allow_metadata_inventory_move = cgmr.inventario_mover,
  allow_metadata_inventory_put = cgmr.inventario_colocar,
  allow_metadata_inventory_take = cgmr.inventario_pegar,
})

-- Placa
minetest.register_craft({
  output = 'cgmr:placa',
  recipe = {
    {'default:stick', 'default:stick'},
    {'default:stick', 'default:stick'},
    {'default:stick', ''},
  }
})

-- craft pc
minetest.register_craft({
  output = 'cgmr:pc',
  recipe = {
    {'cgmr:placa'},
    {'default:glass'},
    {'default:wood'},
  }
})

minetest.register_node("cgmr:item_desconhecido", {
  description = "Unknow item",
  inventory_image = "cgmr_desconhecido.png",
})
