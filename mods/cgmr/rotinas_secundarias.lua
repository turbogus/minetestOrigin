cgmr.moreblocks_lista_de_partes = {
 ":micro_".."," .."_bottom",
 ":micro_".."," .."_top",
 ":panel_".."," .."_bottom",
 ":panel_".."," .."_top",
 ":panel_".."," .."_vertical",
 ":slab_".."," .."",
 ":slab_" .."," .."_inverted",
 ":slab_" .."," .."_quarter",
 ":slab_" .."," .."_quarter_inverted",
 ":slab_" .."," .."_quarter_wall",
 ":slab_" .."," .."_three_quarter",
 ":slab_" .."," .."_three_quarter_inverted",
 ":slab_" .."," .."_three_quarter_wall",
 ":stair_".."," .."",
 ":stair_".."," .."_half",
 ":stair_".."," .."_half_inverted",
 ":stair_".."," .."_inner",
 ":stair_".."," .."_inner_inverted",
 ":stair_".."," .."_inverted",
 ":stair_".."," .."_outer",
 ":stair_".."," .."_outer_inverted",
 ":stair_".."," .."_right_half",
 ":stair_".."," .."_right_half_inverted",
 ":stair_".."," .."_wall",
 ":stair_".."," .."_wall_half"
}

--[[
  Rotina que irá pegar as receitas de um item clonando o comportamento da rotina minetest.get_all_craft_recipes(nome) porém buscando a partir
de lista secundária.
--]]
cgmr.pega_todas_as_receitas = function(nome)
  local receitas

  if minetest.get_all_craft_recipes == nil then 
    receitas = minetest.get_craft_recipe(nome)
  else
    receitas = minetest.get_all_craft_recipes(nome) --Pega todas as receitas conhecidas.
  end

  --Adiciona as secundarias identificadas
  if cgmr.lista_de_itens_secundaria ~= nil then
    if cgmr.lista_de_itens_secundaria[nome] ~= nil then
      for i,n in ipairs(cgmr.lista_de_itens_secundaria[nome]) do
        if receitas == nil then
          receitas = {}
        end

        table.insert(receitas,n)
      end
    end
  end
  return(receitas)
end


--[[
  Rotina que irá carregar todas os itens existentes em outros módulos para a variável secundária.
--]]
cgmr.carrega_lista_de_itens_secundaria = function ()
  --Apenas carrega se o módulo ainda estiver carregando.
  if cgmr.carregando ~= 1 and cgmr.carregando ~= 3 then
    return
  end

  --Limpa e carrega a lista secundária a partir de fontes externas ao modulo.
  cgmr.lista_de_itens_secundaria = nil
  cgmr.total_de_itens_lista_secundaria = 0
  cgmr.moreblocks_lista_de_materiais = {}

  --Verifica existência dos mods e configura de acordo para carga.
  --Moreblocks
--DOM_inspeciona("Mods:",dump(minetest.get_modpath("moreblocks")),dump(minetest.get_modpath("technic")))
  if minetest.get_modpath("moreblocks")=="" or minetest.get_modpath("moreblocks") == nil then
    cgmr.carregar_moreblocks = 0
  else
    if circular_saw ~= nil then
      if circular_saw.known_stairs == nil then
        cgmr.carregar_moreblocks = 0 
      end
    else
      cgmr.carregar_moreblocks = 0   
    end
  end

--  if minetest.get_modpath("technic")=="" or minetest.get_modpath("technic") == nil then
    cgmr.carregar_technic = 0
--  else
--    cgmr.carregar_technic = 1    
--  end
  
  
  --circular_saw.known_stairs ~= nil
  
  if cgmr.carregar_moreblocks == 1 then  -- Itens do moreblocks:circular_saw.
--DOM_inspeciona("Circular_saw:",#(circular_saw.known_stairs))
    for _,tipo in ipairs({"moreblocks"}) do
    --Carrega lista de cada bloco existente no módulo pela combinação das peças e dos materiais.
      for i,n in ipairs(circular_saw.known_stairs) do
        --Adiciona material a lista de materias.
        table.insert(cgmr.moreblocks_lista_de_materiais, n);
   
        --Corre todos os subtipos testando a existencia de cada item e adicionando a lista.
        for m2,n2 in ipairs(cgmr.moreblocks_lista_de_partes) do
          local n_c = n2 -- Ponto onde os modificadores de bloco esta disponiveis en n_c separados por ","

          nome = tipo .. string.sub(n_c,1, string.find(n_c,",")-1) .. string.sub(n,string.find(n,":")+1) .. string.sub(n_c,string.find(n_c,",")+1)
          if minetest.registered_nodes[nome] ~= nil then
            cgmr.adiciona_item_a_lista_secundaria(nome,nil,"moreblocks:circular_saw")
          end 
        end
      end
    end
  end

--  if alloy_recipes ~= nil then  
  if cgmr.carregar_technic == 1 then -- Itens do technic:alloy_furnaces.
--DOM_inspeciona("Alloy:",#alloy_recipes)
    --Lista todos os produtos 
    for a=1,#alloy_recipes,1 do
      nome = alloy_recipes[a].dst_name
      nome = nome:sub(1,nome:find(" "))
      cgmr.adiciona_item_a_lista_secundaria(nome,nil,"technic:alloy_furnace")
--print("Encontrado item (alloy):"..dump(alloy_recipes[a].dst_name))
    end


    if grinder_recipes ~= nil then  -- Itens do technic:grinder.

--DOM_inspeciona("Grinder:",#grinder_recipes)
    --Lista todos os produtos 
      for a=1,#grinder_recipes,1 do
        nome = grinder_recipes[a].dst_name
        if nome:find(" ") then nome = nome:sub(1,nome:find(" ")-1) end

        origem = grinder_recipes[a].src_name
        if origem:find(" ") then origem = origem:sub(1,origem:find(" ")-1) end

        local m = {{nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil},{nil, nil, origem, nil, nil},{nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil}}
--      local m = DOM_cria_matriz_5x5(origem)
--      m = DOM_centraliza_matriz_5x5(m, 1, 1)
        cgmr.adiciona_item_a_lista_secundaria(nome,m,"technic:grinder")
   
--print("Encontrado item (grinder):"..dump(nome).." de " .. dump(origem))
      end
    end
  end
end

--[[
  Gera item zerado para uso com a rotina de adicionar itens secundarios.
]]--
cgmr.gera_item_padrao_zerado = function(tipo_usado)
  local r = {}
  r.items = {} 
  local receitas_5x5 = {{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}}
  r.items = receitas_5x5
  r.width=5
  r.height=5
  r.type = tipo_usado

  return(r)
end

--[[
  Adiciona item a lista secundária, para resumir código repetitivo.
]]--
cgmr.adiciona_item_a_lista_secundaria = function(nome, receita, tipo)
  local r = cgmr.gera_item_padrao_zerado(tipo)
  if receita ~= nil then
    r.items = receita
  end  
        
  if cgmr.lista_de_itens_secundaria == nil then
    cgmr.lista_de_itens_secundaria = {}
  end

  table.insert(cgmr.lista_de_itens_secundaria,nome)
  cgmr.total_de_itens_lista_secundaria = cgmr.total_de_itens_lista_secundaria + 1
  cgmr.lista_de_itens_secundaria[nome] = {}
  table.insert(cgmr.lista_de_itens_secundaria[nome],"")
  cgmr.lista_de_itens_secundaria[nome][1] = r
end
