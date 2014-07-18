-- Declaração de variáveis globais para o modulo - Declaration of the global variables
cgmr = {}
cgmr.lista_de_itens = {}
cgmr.lista_de_grupos = {}
cgmr.lista_de_itens_filtrada = {}
cgmr.lista_de_itens_secundaria = nil
cgmr.total_de_itens = 0
cgmr.total_de_itens_filtrados = 0
cgmr.total_de_itens_lista_secundaria = 0
cgmr.receita_visualizando = "-"
cgmr.receita_metodo = "craft"
cgmr.versao = "CGMR-20130506"
cgmr.primeira_carga = 1
cgmr.carregando = 0 -- 0 para não carregada, 1 para carregando, 2 para carregada e 3 para recarga forçada.
-- 0 for don't load, 1 to loading, 2 to full loaded, 3 to force reload

--===============================================================================================================
--Configurações:
cgmr.apenas_lista_principal = 0 -- 0 para carregar todas, 1 para carregar apenas a lista primária ignorando a rotina secundária.
cgmr.carregar_moreblocks = 1 -- 1 para carregar o mod moreblocks, 0 para não, caso não exista ele é automaticamente mudado para 0.
cgmr.carregar_technic = 1 -- 1 para carregar o mod technic, 0 para não, caso não exista ele é automaticamente mudado para 0.

--===============================================================================================================

cgmr.moreblocks_lista_de_materiais = {}
cgmr.moreblocks_lista_de_partes = {}

dofile(minetest.get_modpath("cgmr").."/rotinas_secundarias.lua")

--[[
  Rotina que irá carregar todos os itens existentes para a variável.
  (Function who will load all items to a variable)
--]]
function cgmr.carrega_lista_de_itens()
  if cgmr.carregando ~= 0 and cgmr.carregando ~= 3 then
    return
  end

  if cgmr.carregando == 0 then -- Put the signal of the load in on to avoid the load of another instance of this object changing values at same time.
    cgmr.carregando = 1 -- Coloca marcador de carga para evitar que outra instância do objeto altere a mesma variável simultâneamente.
  end

  --Limpa e carrega a lista secundária a partir de fontes externas ao modulo.  - Clear and load the secondary list from outside sources of this module
--  if lista_de_itens_secundaria == nil or cgmr.carregando == 3 then

  if(cgmr.carregando == 1 or cgmr.carregando == 3) and cgmr.apenas_lista_principal == 0 then
    cgmr.carrega_lista_de_itens_secundaria()
  end

--  local receitas = ""
  cgmr.lista_de_itens = {}
  cgmr.lista_de_grupos = {}
  cgmr.lista_de_receitas = {}
  local total_de_itens_na_rotina = 0

  --Adiciona item desconhecido para que seja referênciado quando um for encontrado.
--[[  cgmr.lista_de_itens["cgmr:item_desconhecido"] = {}
  cgmr.lista_de_itens["cgmr:item_desconhecido"].total_de_receitas=0
  cgmr.lista_de_itens["cgmr:item_desconhecido"].receitas = {}
  table.insert(cgmr.lista_de_itens["cgmr:item_desconhecido"].receitas,1)
  cgmr.lista_de_itens["cgmr:item_desconhecido"].receitas[1] = {{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}}
  cgmr.lista_de_itens["cgmr:item_desconhecido"].receitas[1].metodo = 'craft'
--]]

  for nome,def in pairs(minetest.registered_items) do
    --Adiciona apenas itens que tenham nome e desrição (Add only items with name and description)
    if nome ~= nil and def ~= nil and dump(nome) ~= "\"\"" and dump(def) ~= "\"\"" then
      if cgmr.lista_de_itens[nome]==nil then
        cgmr.lista_de_itens[nome] = {}
        cgmr.lista_de_itens[nome].total_de_receitas=0
      end
      cgmr.lista_de_itens[nome].definicoes=def

      -- Cadastra os grupos durante a carga  (Append groups in the load)
      for grupo,_ in pairs(def.groups) do
        if cgmr.lista_de_grupos[grupo] == nil then  -- Cadastro grupo e exemplo caso não exista
          cgmr.lista_de_grupos[grupo] = {}
          cgmr.lista_de_grupos[grupo].exemplo = nome
        end
      end
--      local receitas = minetest.get_craft_recipe(nome)
   
      --Coleta todas as receitas para o item.  (Collecting all recipes to the object)
--      local receitas = minetest.get_all_craft_recipes(nome)
      local receitas = cgmr.pega_todas_as_receitas(nome)
      local n = 1

--DOM_inspeciona("Receita consultada:",receitas)
      if receitas == nil then
        -- Não faz nada na auxência de receitas.  (Don't do nothing if no recipe)
      elseif receitas[n] == nil then
        -- Não faz nada na auxência de receitas.  (Don't do nothing if no recipe)
      elseif receitas[n] ~= nil then
        while receitas[n] ~= nil do
          -- Convertendo receita em matrix 5x5.  (Convert recipe to 5x5 matrix)
          local receitas_5x5={{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}}

          local margem_superior = 0
          local margem_lateral = 0
          local altura = 0
          local linhas={}
          local colunas={}

          -- Encontra largura da receita.  Usa 3 como padrão.  (Find lenght of the recipe.  Default is 3)
          local largura = 3
          if receitas[n].width ~= nil then
            largura = receitas[n].width
          end
          if largura == 0 then
            largura = 1
          end

--DOM_inspeciona("Receita adicionada:",nome,receitas[n]["items"])
          -- Transfere receita (Transfer recipe)
          for a=1,largura,1 do --Colunas (Cols)
            for b=1,5,1 do --Linhas (Rows)
              local item_local = receitas[n]["items"][tostring((a-1) + ((b-1)*largura))] --Work with the windows version
              local i2 = receitas[n]["items"][(a) + ((b-1)*largura)] --Work for the Linux version.

              if item_local == nil then
                item_local = i2
              end

              if item_local ~= nil then
                receitas_5x5[a][b] = item_local
--DOM_inspeciona_r("Item:"..dump(item_local))
                linhas[b]=1
                colunas[a]=1
              end
            end
          end
--DOM_inspeciona("Receita 5x5:",nome,receitas_5x5)
          -- Acha altura da receita (Find height of the recipe)
          for b=1,5,1 do
            if linhas[b] ~= nil then
              altura = altura + 1
            end
          end
          if altura == 0 then
            altura = 3
          end

          -- Corrige eventual largura errada da receita.  (Fix eventual wrong lenght in the recipe)
          largura = 0
          for a=1,5,1 do
            if colunas[a] ~= nil then
              largura = largura + 1
            end
          end
          if largura == 0 then
            largura = 3
          end

          --Faz o deslocamento centralizando os valores na matriz
          receitas_5x5 = DOM_centraliza_matriz_5x5(receitas_5x5, largura, altura)

          local t = cgmr.lista_de_itens[nome].total_de_receitas
          cgmr.lista_de_itens[nome].total_de_receitas = t + 1

          if cgmr.lista_de_itens[nome].receitas == nil then
            cgmr.lista_de_itens[nome].receitas = {}
          end
          if cgmr.lista_de_itens[nome].receitas[t+1] == nil then
            cgmr.lista_de_itens[nome].receitas[t+1] = {}
          end

          table.insert(cgmr.lista_de_itens[nome].receitas,t+1)
          cgmr.lista_de_itens[nome].receitas[t+1] = receitas_5x5
          cgmr.lista_de_itens[nome].receitas[t+1].metodo = receitas[n].type
          n = n + 1
        end
  
        if cgmr.lista_de_receitas[nome] == nil then
          cgmr.lista_de_receitas[nome] = {}
        end

        table.insert(cgmr.lista_de_receitas[nome], receitas)
        total_de_itens_na_rotina = total_de_itens_na_rotina + 1
      end
    end
  end
  cgmr.total_de_itens = total_de_itens_na_rotina

  table.sort(cgmr.lista_de_itens)

  if cgmr.lista_de_itens_filtrada == nil then
    cgmr.lista_de_itens_filtrada = cgmr.lista_de_itens
    cgmr.total_de_itens_filtrados = cgmr.total_de_itens
  end

  cgmr.carregando = 2
end

-- Monta formulário do computador
function cgmr.monta_formulario (m, busca1, busca2, pagina, alternativa)
  local formulario = nil

--DOM_inspeciona("Entrada da rotina monta_formulario",busca,pagina,alternativa)

  if cgmr.primeira_carga == 1 then -- No caso da variável ainda estiver em um, indicando primeira carga, a carga é feita normalmente.
--    minetest.chat_send_player(name, "[DOM]CGMR: Loading first time...")
--DOM_inspeciona_r("Primeira carga.")
    cgmr.primeira_carga = 0
    cgmr.carregando = 3
    cgmr.carrega_lista_de_itens()
--    minetest.chat_send_player(name, "[DOM]CGMR: Item list loaded.")
  end

  if busca1 == nil then 
    busca1 = m:get_string("busca1")
  end
  if busca2 == nil then 
    busca2 = m:get_string("busca2")
  end

  if pagina == nil then 
    pagina = cgmr.formulario_pega_pagina(m) 
  end
  if alternativa == nil then 
    alternativa = cgmr.formulario_pega_alternativa(m) 
  end
  if cgmr.lista_de_receitas == nil then
    return
  end
--DOM_inspeciona("Entrada da rotina, apos tratamento",busca,pagina,alternativa)
  busca1 = DOM_remove_simbolos(busca1)
  busca1 = string.lower(busca1)
  busca2 = DOM_remove_simbolos(busca2)
  busca2 = string.lower(busca2)

  local i = m:get_inventory()
  local size = i:get_size("main")
  local start = (pagina-1) * (4*14) + 1
  local paginas = math.floor((size-1) / (4*14) + 1)
--DOM_inspeciona("Total de paginas:",paginas,size,pagina)

  local stack = i:get_stack("output",1)

--DOM_inspeciona("Geral:",cgmr.lista_de_itens,cgmr.lista_de_itens[stack:get_name()])
--  if cgmr.lista_de_itens[stack:get_name()] == nil then
--    return
--  end

--  DOM_inspeciona("Geral:",cgmr.lista_de_itens[stack:get_name()])
  local alternativas = 1
  if cgmr.lista_de_itens[stack:get_name()] ~= nil then
    alternativas = cgmr.lista_de_itens[stack:get_name()].total_de_receitas
  end

  local local_receitas = nil
  local_receita_classe = ""
  local_receita_nome = ""

  if cgmr.receita_visualizando ~= nil and cgmr.receita_visualizando ~= "-" then
--DOM_inspeciona("Cgmr:",local_receitas)
    local_receitas = DOM_quebra_texto_em_lista_por_delimitador(cgmr.receita_visualizando, ":")
    if local_receitas ~= nil then
      local_receita_classe = local_receitas[1]
      local_receita_nome = local_receitas[2]
    end
  end

  while formulario == nil do
    formulario = "size[14,11;]"
    .."list[current_name;main;0,0;14,4;"..tostring(start).."]"
    .."field[6.5,4.1;2,1;cgmr_search_box1;;"..tostring(busca1).."]"
    .."field[8.5,4.1;2,1;cgmr_search_box2;;"..tostring(busca2).."]"
    .."button[10,3.8;1.2,1;cgmr_search_button;Search]"

    .."label[11.7,4.5;Page "..tostring(pagina).." of "..tostring(paginas).."]"
    .."button[11,3.8;1.5,1;cgmr_prev;<<]"
    .."button[12.5,3.8;1.5,1;cgmr_next;>>]"

    .."label[0,6.5;Output]"
    .."list[current_name;output;0,7;1,1;]"

--    .."label[0,8.5;Analiser]"
--    .."list[current_name;analiser;0,9;1,1;]"

    .."label[0,4;Inventory Craft:]"
    .."label[0.2,4.3;".. local_receita_classe .. "]"
    .."label[0.3,4.6;".. local_receita_nome .. "]"
    .."list[current_name;build;2,6;5,5;]"

    .."label[0,5.1;Method:]"
    .."label[0.2,5.4;" .. tostring(cgmr.receita_metodo) .. "]"

    .."label[9,6.5;Bookmarks]"
    .."list[current_name;bookmark;9,7;5,3;]"

    .."label[12,6.1;Bin ->]"

    .."label[9,10.9;Version:"..cgmr.versao.."]"

    .."list[current_name;bin;13,6;1,1;]"

    if alternativas > 1 then
      formulario = formulario
      .."label[7,6.6;Recipe "..tostring(alternativa).." of "..tostring(alternativas).."]"
      .."button[7,7;2,1;alternar;Alternate]"
    end
  end
 
  return formulario
end

-- Recebe campos na interação com o objeto
function cgmr.inventario_receber_campos(pos, formname, fields, player)
--  if cgmr.carregando ~= 2 then return end.
  local m = minetest.env:get_meta(pos);
  local i = m:get_inventory()

  if i==nil then
    cgmr.create_inventory(i)
    m:set_string("formspec",cgmr.monta_formulario(m))
  end

  if fields==nil then
    fields={}
    fields.cgmr_search_box1=""
    fields.cgmr_search_box2=""
  end

  local size = i:get_size("main",1)
  local stack = i:get_stack("output",1)
   
  local alternativas = 1
  local alternativa = 1

  if cgmr.lista_de_itens[stack:get_name()] ~= nil then 
    alternativas=cgmr.lista_de_itens[stack:get_name()].total_de_receitas
    alternativa = cgmr.formulario_pega_alternativa(m)
  end
  
--DOM_print("Alternativa lida: %d/%d\n",alternativa,alternativas)
  local pagina = cgmr.formulario_pega_pagina(m)
  local paginas = math.floor((size-1) / (4*14) + 1)

  local busca1
  local busca2
	
  -- search
  busca1 = DOM_remove_simbolos(fields.cgmr_search_box1)
  m:set_string("busca1", busca1)
  busca2 = DOM_remove_simbolos(fields.cgmr_search_box2)
  m:set_string("busca2", busca2)

  if fields.cgmr_search_button then
    pagina = 1
  end

  -- change page
  if fields.cgmr_prev then
    pagina = pagina - 1
  end
  if fields.cgmr_next then
    pagina = pagina + 1
  end
  if pagina < 1 then
    pagina = 1
  end
  if pagina > paginas then
    pagina = paginas
  end

  -- Alternativas
  if fields.alternar then
--DOM_inspeciona("Clicado em alternar, valores:",fields,alternativa,alternativas)
    alternativa = alternativa + 1

    if alternativa > alternativas then
      alternativa = 1
    end

--DOM_print("Depois... %d/%d\n",alternativa,alternativas)
    cgmr.mostra_receita(m, player, stack, alternativa)
  end


  -- Atualiza formulário
--DOM_inspeciona("Antes de atualizar o formulário",m,busca,pagina, alternativa)
  cgmr.create_inventory(i, busca1,busca2)
  m:set_string("formspec",cgmr.monta_formulario(m, busca1, busca2, pagina, alternativa))
end


--[[
  Pega a página atual a partir da string do formulário.
--]]
function cgmr.formulario_pega_pagina(m)
  local f = m:get_string("formspec")
  local p = string.match(f, "label%[[%d.]+,[%d.]+;Page (%d+) of [%d.]+%]")
  p = tonumber(p) or 1 -- Evita erro caso a página retorne em branco.
  return p
end


--[[
  Pega a alternativa atual a partir da string do formulário.
--]]
function cgmr.formulario_pega_alternativa(m)
  local f = m:get_string("formspec")
  local a = string.match(f, "label%[[%d.]+,[%d.]+;Recipe (%d+) of [%d.]+%]")
  a = tonumber(a) or 1 -- Evita erro caso a alternativa retorne em branco.
  return a
end


--[[
  Atualiza receita no formulário.
--]]
function cgmr.mostra_receita(m, jogador, stack, alternativa)
--    DOM_inspeciona_r("Entrada")
  local inv = m:get_inventory()
  local alternativas = 1

  if alternativa == nil then
    alternativa = 1
  end

  for a=0,inv:get_size("build"),1 do
    inv:set_stack("build", a, nil)
  end

  if stack==nil then 
    return
  end

  nome = stack:get_name()
  if nome == nil then
    return
  end

  if cgmr.lista_de_itens[nome] ~= nil then
    local alternativas = cgmr.lista_de_itens[nome].total_de_receitas or 1
  end

  inv:set_stack("output", 1, ItemStack(nome))
  cgmr.receita_visualizando = nome
  cgmr.receita_metodo = "-"
--  cgmr.receita_visualizando = ItemStack(nome).name or "-"
--  

--  if inv == nil then 
--    m:set_string("formspec",cgmr.monta_formulario(m))
--  end

  local item = cgmr.lista_de_itens[nome]

  if inv == nil or item == nil or item.total_de_receitas <1 then 
    m:set_string("formspec",cgmr.monta_formulario(m))
    return
  end

--DOM_inspeciona("Receita:",item.receitas[alternativa], alternativa)
--  cgmr.receita_metodo = tostring(item.definicoes.type)
  local receita = item.receitas
  cgmr.receita_metodo = tostring(item.receitas[alternativa].metodo)
  if cgmr.receita_metodo == "normal" then
    cgmr.receita_metodo = "craft"
  end

--DOM_inspeciona(nome,item)

  -- Para fórmulas identificadas como 5x5 em uma linha de receita

  for receitas_c=1,5,1 do -- Corre 5 possíveis colunas
    for receitas_l=1,5,1 do -- Corre as 5 possíveis linhas

      if receita[alternativa][receitas_c][receitas_l] ~= nil then
        local i = receita[alternativa][receitas_c][receitas_l]
--DOM_inspeciona("Valor em i(receitas_l)",i,receitas_l)

        -- Quando um grupo é encontrado armazenado seu exemplo é usado no lugar.
        if string.find(dump(i),"group:") then -- Tenta converter item para seu grupo se já cadastrado.
          if cgmr.lista_de_grupos[string.sub(i,7)] ~= nil then
            e = cgmr.lista_de_grupos[string.sub(i,7)].exemplo
          end
        elseif ItemStack(i) ~= nil then
--DOM_inspeciona("ItemStack:",ItemStack(i):to_table())
          e = i
        else -- Caso o item não seja reconhecido mostra o item padrão para desconhecidos.
          e = "cgmr:item_desconhecido"
        end

--        e = "default:wood" -- Para testes.

        inv:set_stack("build", (receitas_c) + ((receitas_l-1)*5), ItemStack(e))
      end
    end
  end

--  DOM_inspeciona_r("Inspeção")
  m:set_string("formspec",cgmr.monta_formulario(m))
end


-- create_inventory
function cgmr.create_inventory(i, busca1,busca2)
  if(busca1 == nil) then
    busca1 = ""
  end
  if(busca2 == nil) then
    busca2 = ""
  end
 
  -- Remove simbolos proibidos evitando falhas na rotina.
  busca1=DOM_remove_simbolos(busca1)
  busca1=string.lower(busca1)
  busca2=DOM_remove_simbolos(busca2)
  busca2=string.lower(busca2)

  cgmr.lista_de_itens_filtrada = cgmr.lista_de_itens
  cgmr.total_de_itens_filtrados = cgmr.total_de_itens

  -- Busca vazia retorna todos os itens, senão filtra
  if busca1 ~="" or busca2 ~="" then
  -- Zera itens.
    cgmr.lista_de_itens_filtrada = {}
    cgmr.total_de_itens_filtrados = 0

    for nome,_ in pairs(cgmr.lista_de_itens) do
      local item = cgmr.lista_de_itens[nome]
      campo1=""
      campo2=""

      campo1=string.lower(nome)
   
      if item.definicoes.description ~= nil then 
        campo2=string.lower(item["definicoes"].description)
      end

--DOM_inspeciona("ponto de busca, campos e busca:",campo1,campo2,busca1,busca2)
      if ((string.find(campo1, busca1) or string.find(campo2, busca1)) and (string.find(campo1, busca2) or string.find(campo2, busca2))) and (item.total_de_receitas >0) then
        if cgmr.lista_de_itens_filtrada[nome]==nil then
          cgmr.lista_de_itens_filtrada[nome] = {}
          cgmr.lista_de_itens_filtrada[nome].total_de_receitas=0
        end

        table.insert(cgmr.lista_de_itens_filtrada,item.name)
        cgmr.lista_de_itens_filtrada[nome] = cgmr.lista_de_itens[nome]
        cgmr.total_de_itens_filtrados = cgmr.total_de_itens_filtrados + 1
      end
    end
  end

-- Ordena lista dos nomes dos itens
  table.sort(cgmr.lista_de_itens_filtrada)

--Zera lista?
  for a=1,i:get_size("main"),1 do
    i:set_stack("main", a, nil)
  end

--Primeiro item não aparece se não for adicionado o item 0, razão ainda desconhecida...
  if busca1=="" and busca2=="" then
    i:set_size("main", cgmr.total_de_itens+1)
  else
    i:set_size("main", cgmr.total_de_itens_filtrados+1)
  end

  --Sem o item na posição inicial a lista "come" um dos itens.
  i:add_item("main", ItemStack("default:air"))

  local total_local = 0

  for nome,def in pairs(cgmr.lista_de_itens_filtrada) do --_filtrada) do
    if def.total_de_receitas > 0 then 
      i:add_item("main", ItemStack(nome))
      total_local = total_local + 1
    end 
  end

  -- Acerta o tamanho
  if busca1=="" and busca2=="" then
    i:set_size("main", total_local)
  end
end


-- Rotina construtora do objeto.
function cgmr.construtor(pos)
  local m = minetest.env:get_meta(pos)
  local i = m:get_inventory()
  i:set_size("output", 1)
  i:set_size("analiser", 1)
  i:set_size("build", 5*5)
  i:set_size("bookmark", 6*3)
  i:set_size("bin", 1)

  -- Agenda carga da lista de itens caso o total de itens seja 0, o que indica primeira carga.
  if cgmr.total_de_itens == 0 then
    cgmr.carrega_lista_de_itens()
  end

  cgmr.lista_de_itens_filtrada = {}
  cgmr.total_de_itens_filtrados = 0

  cgmr.create_inventory(i)
  m:set_string("formspec",cgmr.monta_formulario(m))
end

-- Permite colocar itens no inventário?  Ou bloqueia esta ação?
function cgmr.inventario_colocar(pos, listname, index, stack, player)
  if listname == "analiser" then
    return 1
  end

  return 0
end


-- Permite pegar itens no inventário?  Ou bloqueia esta ação?
function cgmr.inventario_pegar(pos, listname, index, stack, player)
  if listname == "analiser" then
    return 1
  end

  return 0
end


-- Movimentação de itens no inventário?
function cgmr.inventario_mover(pos, from_list, from_index, to_list, to_index, count, player)
  local m = minetest.env:get_meta(pos)
  local i = m:get_inventory()
  if to_list == "bin" and from_list == "output" then
    i:set_stack(from_list,from_index,nil)
    cgmr.mostra_receita(m, player, i:get_stack(from_list, from_index))
  end

--DOM_inspeciona("Item na receita: ",(i:get_stack(from_list, from_index)):to_table())

  if to_list == "bin" and from_list == "bookmark" then
    i:set_stack(from_list,from_index,nil)
  end

  if to_list == "bookmark" then
    i:set_stack(to_list, to_index, i:get_stack(from_list, from_index):get_name())
--    if from_list == "output" then
--      i:set_stack(from_list,from_index,nil)
--    end
  end

  if to_list == "output" or from_list == "output" then
    cgmr.mostra_receita(m, player, i:get_stack(from_list, from_index))
  end

  if from_list == "bookmarks" and to_list == "bookmarks"  then
    return count
  end
  return 0
end


--Registra comando para configurar o uso do cgmr
--Comandos previstos:
-- Reload
minetest.register_chatcommand("cgmr",
{
  params = "",
  description = "Config [DOM]cgmr mod." ,
  func = function(name,param)
    local j = minetest.env:get_player_by_name(name)
    p = DOM_remove_simbolos(param)
    local p = string.lower(param)

    if p == "reload" then -- Marca lista de itens para recarga.
      if cgmr.carregando == 2 then
        minetest.chat_send_player(name, "[DOM]CGMR: Reloading...")
        cgmr.carregando = 3
        cgmr.carrega_lista_de_itens()
        minetest.chat_send_player(name, "[DOM]CGMR: Item list reloaded.")
      else
        minetest.chat_send_player(name, "[DOM]CGMR: Alredy is loading, wait some time and try again.")
      end
    elseif p == "purge" then -- Remove todos os itens e desabilita anexos
    elseif p == "" then -- Relata estado.
      minetest.chat_send_player(name, "[DOM]CGMR: Repport:")
      minetest.chat_send_player(name, "Status: "..tostring(cgmr.carregando).."")
      if cgmr.carregando==2 then --Se já carregado.
        minetest.chat_send_player(name, "Total of items: "..tostring(cgmr.total_de_itens).."/"..tostring(cgmr.total_de_itens_lista_secundaria) .. "("..tostring(cgmr.total_de_itens_lista_secundaria+cgmr.total_de_itens)..")")
      end
    end
  end
})
