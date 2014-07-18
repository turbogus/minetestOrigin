--Para ser usado no gerador aleatório.
local domb_aleatorio = nil
local domb_aleatorio_anterior = 0

--Para uso com rotinas que precisem de pontos memorizados.
domb.p = {}

local domb_mapa ={}

--Inicialização da variável aleatoria para que seja usada quando necessário.
minetest.after(0.01, function()
  domb_aleatorio=nil
  domb_aleatorio=PseudoRandom(200 + (minetest.env:get_timeofday()*100000) + domb_aleatorio_anterior) 
  domb_aleatorio_anterior=domb_aleatorio:next(1,100)
end)


--Realiza o sorteio aleatório garantido que dois números iguais jamais saiam em sequência
function DOM_gera_aleatorio(menor, maior)
  local numero=0
  numero = domb_aleatorio:next(menor, maior)

  while (numero == domb_anterior) or (numero < menor or numero > maior) do
    domb_aleatorio=PseudoRandom(200 + (minetest.env:get_timeofday()*100000) + domb_aleatorio_anterior) 
    numero = domb_aleatorio:next(menor-domb_aleatorio_anterior, maior+ domb_aleatorio_anterior)
  end

  domb_aleatorio_anterior=numero
--DOM_inspeciona("Valor",numero)

  return(numero)
end

-- Identifica vizinhança de um ponto, os pontos retornados tem a parte superior como ponto 1.
-- Totaliza atualmente água, lava e ar.  Contabiliza totais e separando fontes de fluindo.
function DOM_vizinhos(ponto)
  local p = {}
  local vx=0
  local vy=0
  local vz=0
  local tipo = ''
  local pontos = 1
--  p.total = 0
  p.total_ar = 0
  p.total_lava = 0
  p.total_lava_fonte = 0
  p.total_agua = 0
  p.total_agua_fonte = 0
  p.n = {'','','','','',''}

  --Começa pelo y (altura) de baixo para cima, sendo assim os 3 últimos testes serão os 
  for vy=-1,1 do
    for vx=-1, 1 do
      for vz=-1,1 do
        p.n[pontos] = ''
        tipo =  minetest.env:get_node({x=(ponto.x + vx), y=(ponto.y + vy), z=(ponto.z + vz)}).name

        -- Busca pontos onde dois eixos estejam zerados e um outro tenha valor.
        if vx==0 and vy==0 and vz==0 then
          -- Ignora caso seja exatamente o ponto testado. 
        elseif (vx==0 and vy==0 and vz~= 0) or (vx==0 and vz==0 and vy~=0) or (vy==0 and vz==0 and vx~=0) then
          if tipo == "default:air" or tipo == "air" then
            p.total_ar = p.total_ar + 1
          elseif tipo == "default:water_source" or tipo == "default:water_flowing" or tipo == "default:water" then
            p.total_agua = p.total_agua + 1
            if tipo == "default:water_source" then
              p.total_agua_fonte = p.total_agua_fonte + 1
            end
          elseif tipo == "default:lava_source" or tipo == "default:lava_flowing" then
            p.total_lava = p.total_lava + 1
            if tipo == "default:lava_source" then
              p.total_lava_fonte = p.total_lava_fonte + 1
            end
          end

          p.n[pontos] = tipo
          pontos = pontos + 1
        end
      end
    end
  end 

  p.total_lava_corrente = p.total_lava - p.total_lava_fonte
  p.total_agua_corrente = p.total_agua - p.total_agua_fonte

  return(p)
end


--[[
  Rotina que pega o texto e remove eventuais símbolos não desejados.
]]--

function DOM_remove_simbolos(texto)
  local t = ""
  
  if texto == "" or texto == nil then
    return("")
  end

  -- Remoção de símbolos proibidos.
  t=string.gsub(texto, "(%[)", "")
  t=string.gsub(t, "(%])", "")
  t=string.gsub(t, "(%()", "")
  t=string.gsub(t, "(%))", "")
  t=string.gsub(t, "(#)", "")
  t=string.gsub(t, "(@)", "")
  t=string.gsub(t, "(?)", "")
  t=string.gsub(t, "(!)", "")
  t=string.gsub(t, "($)", "")
  t=string.gsub(t, "(%%)", "")
  t=string.gsub(t, "(&)", "")
  t=string.gsub(t, "(*)", "")
  t=string.gsub(t, "(=)", "")

  return(t)
end

--[[
  Rotina que pega o texto e remove eventuais espaços no inicio, no final e espacos duplos no meio da string.
]]--

function DOM_remove_espacos(texto)
  local t = ""
  
  if texto == "" or texto == nil then
    return("")
  end
  t = texto

  --Remove todos os espaços duplos que encontrar.
  while string.find(t,"  ") do
    t=string.gsub(texto, "(  )", " ")
  end

  --Remove espaços no final e no início do texto.
  t=string.trim(t)
    
  return t
end


--[[
  Rotina usada para inspecionar elementos retornando um relatório na linha de comando.
  Aceita quantidade variável de parâmetros sendo:
  1) Arquivo
  2) Linha
  3) Teste
  4) Parâmetros
 
]]--
function DOM_inspeciona_condicional(...)
  if(arg[3] ~= true) then return end

  local a=0
  local linha= {tostring(debug.getinfo(2, 'l').currentline)}
  local arquivo = debug.getinfo(2, 'S').short_src or debug.getinfo(2,'S').source
  if string.len(arquivo) > 25 then
    arquivo = "..." arquivo:sub(string.len(arquivo)- 22) 
  end

  if arg[2] ~= nil then
    linha = arg[2]
  end

  if arg[1] ~= nil then
    arquivo = arg[1]
  end



  print("====================================== [DOM Inspeciona] =======")
  print(arquivo .. "  [" .. linha .. "]")
  print(tostring(arg[4]))
  print("---------------------------------------------------------------")
  for a=5,#arg,1 do
    print(string.format("%s", dump(arg[a])))
  end
  print("");
  print("-------------------------------------- [DOM Inspeciona] ---Fim-")
  print(arquivo .. "  [" .. linha .. "]")
  print("===============================================================")
end

--[[
  Chama a rotina de inpecao sem a necessidade de passar a condicao.
]]--

function DOM_inspeciona(...)
  local linha = debug.getinfo(2, 'l').currentline
  local arquivo = debug.getinfo(2, 'S').short_src or debug.getinfo(2,'S').source
  if string.len(arquivo) > 25 then
    arquivo = "..." .. arquivo:sub(arquivo:len(arquivo)- 22) 
  end

  DOM_inspeciona_condicional(arquivo,linha,true,...)
end

--[[
  Inspeção simplificada que não necessita de valores adicionais, apenas o titulo.  Mostra a linha
--]]
function DOM_inspeciona_r(titulo)
  if titulo == nil then
    titulo = ""
  end

  local linha = debug.getinfo(2, 'l').currentline
  local arquivo = debug.getinfo(2, 'S').short_src or debug.getinfo(2,'S').source
  if string.len(arquivo) > 25 then
    arquivo = "..." arquivo:sub(string.len(arquivo)- 22) 
  end

  print(arquivo .. " [" .. linha .. "] " .. titulo)
end


--[[
  Realiza a união do string.format com o print simulando o printf do C++.
--]]
function DOM_print(...)
  print(string.format(...))
end

--[[
  Permite envio de mensagens para o log no minitest ao invés do terminal, segue a formatação do string.format
--]]
function DOM_log(...)
  -- action, error, info
  minetest.log("action", "[DOM]"..string.format(...))
end


--[[
  Centraliza os valores na matriz 5x5 de acordo com a largura e altura recebidas gerando automaticamente uma margem ao redor da fórmula.
--]]
function DOM_centraliza_matriz_5x5(matriz, largura, altura)
  --Centraliza se largura ou altura forem menores que 5.
  --Largura ou Altura/Critério:  5/Ignora, 4/Ignora, 3/1 de margem, 2/1 de margem, 1/2 de margem
local i = 0
a=matriz[1][3]
if a~=nil then 
  if string.find(a,"gravel") then 
    i = 1
  end
end
--DOM_inspeciona("Rotina centraliza matriz: ",matriz)

  local margem_superior = math.floor((5-altura)/2)
  local margem_lateral  = math.floor((5-largura)/2)
  local d_a = margem_lateral
  local d_b = margem_superior

  if margem_superior > 0 or margem_lateral > 0 then 
    for a=5,margem_lateral+1,-1 do --Colunas
      for b=5,margem_superior+1,-1 do --Linhas
        -- Transfere valor da posição original para a deslocada tornando o valor da posição original como nulo.
        matriz[a][b] = matriz[a-d_a][b-d_b]
        matriz[a-d_a][b-d_b] = nil
      end
    end
  end
--DOM_inspeciona("Matriz convertida:",matriz)

---DOM_inspeciona("Saida da rotina centraliza matriz: ",matriz)
  return matriz
end

--[[
  Cria matriz 5x5 a patir de uma linha de itens separados por virgulas
  - Ignora itens a partir do sexto...
--]]
function DOM_cria_matriz_5x5(itens)
  local m_5x5={{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}},{{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}}
  local i = {}
  local a = 0
  local largura = 0
  
  if itens ~= "" and itens ~= nil then
    if itens.find(itens,",") then
    else
      table.insert(i,itens)
      a = a + 1
    end
  end

  while string.find(itens,",") do
    lido = string.sub(itens,1,itens.find(","))
    itens = string.sub(itens,itens.find(",")+1)
    table.insert(i,lido)
    a = a + 1
  end

  largura = a 
  while a < 5 do
    table.insert(i,nil)
    a = a + 1
  end
  
  for a=1,5,1 do --Colunas
  -- Transfere valores para a linha 3.
     m_5x5[3][a] = i[a]
  end

  m_5x5 = DOM_centraliza_matriz_5x5(m_5x5,largura,5)

  return m_5x5
end

--[[
  Converte valor posicional xyz para valor em texto separados por virgulas e sem espaços:
  <classe> -> "x,y,z"
]]--
function DOM_de_xyz_para_texto(valor)
  if valor==nil then
    return "0,0,0"
  end

  local r = ""
  r = tostring(valor.x)..",".. tostring(valor.y) ..",".. tostring(valor.z)
  return r
end


--[[
  Converte valor posicional de texto para a classe xyz:
  "x,y,z" -> <classe>


  Convert values x,y,z in text to the class xyz:
  "x,y,z" -> <classe>
]]--
function DOM_de_texto_para_xyz(valor)
  if valor==nil or recebido == "" then
    return {x=0,y=0,z=0}
  end

--print("Recebido:".. dump(valor))
  local r={x=0,y=0,z=0}
  local d=valor
  r.x=tonumber(d:sub(1,string.find(d,",")-1))

  d=d:sub(string.find(d,",")+1)
  r.y= tonumber(d:sub(1,string.find(d,",")-1))

  d=d:sub(string.find(d,",")+1)
  r.z= tonumber(d)
--print("Retorno:".. dump(r))
  return r
end


--[[
  Mensagem básica de carga
  Recebe:
    nome do modulo, caminho do modulo

  Basic load message
  Params:
    module name, path of the module
]]--
function DOM_mb(m,c)
--  minetest.log("action", "[DOM]"..m.." loaded from "..minetest.get_modpath(minetest.get_current_modname()))
  minetest.log("action", "[DOM]"..m.." is ready.")
end



--[[
  Registra comando para chamar rotinas de apoio pelo chat com o comando /dom_util <comando> <parametros...>
  Comandos:
  apaga x y z 	Apaga node no lugar especificado.
    
    if  comando == "comando" then -- Comando?
      minetest.chat_send_player(name, "[DOM]dom_util: ".."Comando?")
    elseif comando == "comando2" then -- Comando?
      minetest.chat_send_player(name, "[DOM]dom_util: ".."Comando2?")
    end
  end

--]]
function DOM_registra_comandos_de_uso_geral()
  minetest.register_chatcommand("dom_util",
  {
    params = "",
    description = "[DOM]DOM_util, use dom_util help to more details." ,
    func = function(name,param)
      local j = minetest.env:get_player_by_name(name)
      local jn = j:get_player_name()
      local jp = j:getpos()
      local nome = ""
      local parametros = nil

      -- Sai se parametros não foram passados.
      if param == nil or param == "" or param == "help" then param = "ajuda" end

      -- Remove símbolos passados que possam causar eventuais problemas.
      local p = DOM_remove_simbolos(param)
      p = string.lower(p)
      p = string.gsub(p, "(,)", " ") -- Troca vírgulas encontradas por espaços.
      p = DOM_remove_espacos(p)
   
      -- Quebra pamaretros em lista de itens encontrados separados por espaços na variavel p
  --    parametros = {"","","","","",""}
      parametros = DOM_quebra_texto_em_lista(p)
--print("Texto quebrado: " .. dump(parametros))
      comando = parametros[1]

      if comando == "ajuda" then  -- Sem parâmetros ou pedido de ajuda
        minetest.chat_send_player(jn, "dom_util <command> <params>")
        minetest.chat_send_player(jn, "Params:")
        minetest.chat_send_player(jn, "apagar <x> <y> <z>        Remove a node from x,y,z")
        minetest.chat_send_player(jn, "identifica <x> <y> <z>        Return the name of the node in x,y,z")
        minetest.chat_send_player(jn, "dia       Set time to 5000, start of the day")
        minetest.chat_send_player(jn, "noite     Set time to 19000, start of the night")
        minetest.chat_send_player(jn, "sobe <n>     Move player n in the y axis")
        minetest.chat_send_player(jn, "arvore <n>     Create a skeleton tree for debug")


      elseif comando == "apagar" then -- Apaga o node no lugar especificado.
        local localizacao = tostring(parametros[2]) ..",".. tostring(parametros[3]) ..",".. tostring(parametros[4])
        local l = DOM_de_texto_para_xyz(localizacao)
        local n = minetest.env:get_node(l)
        if n ~= nil then
          nome = n.name
          minetest.chat_send_player(jn, "[DOM] Removing node at "..localizacao .. " [" .. nome .. "]")
          minetest.env:remove_node(l)
        else
          minetest.chat_send_player(jn, "[DOM] Removing node at "..localizacao .. ".  Fail: Invalid node.")
        end
      elseif comando == "identifica" then -- Identifica o node no lugar especificado.
        local localizacao = tostring(parametros[2]) ..",".. tostring(parametros[3]) ..",".. tostring(parametros[4])
        local l = DOM_de_texto_para_xyz(localizacao)
        local n = minetest.env:get_node(l)

        if n == nil then 
          nome = "?"
        else
          nome = n.name
        end
        minetest.chat_send_player(jn, "[DOM] Identity of the node at "..localizacao .. ": " .. nome)
      elseif comando == "dia" then -- Acerta tempo para 5000
        minetest.env:set_timeofday(5000/24000) --0.2
      elseif comando == "noite" then -- Acerta tempo para 19000
        minetest.env:set_timeofday(19000/24000)--0.8
      elseif comando == "arvore" then -- Cria arvore a 2 unidades de distância do jogador.
        p = {x=jp.x+2,y=jp.y,z=jp.z-2}

        if minetest.env:get_node(p).name ~= "air" then
          p = {x=jp.x+2,y=jp.y,z=jp.z+2}         
        end
        if minetest.env:get_node(p).name ~= "air" then
          p = {x=jp.x-2,y=jp.y,z=jp.z-2}         
        end
        if minetest.env:get_node(p).name ~= "air" then
          p = {x=jp.x-2,y=jp.y,z=jp.z+2}
        end

        if minetest.env:get_node(p).name ~= "air" then
          minetest.chat_send_player(jn, "[DOM] Creating tree, leaving, don't found a clear area.")
          return
        end
        minetest.chat_send_player(jn, "[DOM] Creating tree at "..dump(p))
  
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x,y=p.y+1,z=p.z}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x,y=p.y+1,z=p.z}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x+1,y=p.y,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x-2,y=p.y,z=p.z-2}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x+1,y=p.y+1,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x-1,y=p.y,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x+1,y=p.y+1,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x+1,y=p.y+1,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x+1,y=p.y+1,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
        p = {x=p.x+1,y=p.y+1,z=p.z+1}
        minetest.env:add_node(p, {name='default:tree'})
      
      elseif comando == "sobe" then -- Sobe ou desce de acordo com o parâmetro
        local deslocamento = 0
        local d_t="0"

        if parametros.tamanho >= 2 then
          d_t = parametros[2]
          deslocamento = tonumber(d_t)       
        end

--print("Deslocamento:"..dump(tostring(deslocamento)))
        local np= {}
        DOM_copia_ponto(jp,np)
        np.y = np.y + deslocamento
        j:setpos(np)
      elseif comando == "voa" then -- Sobe e desce a altura pedida
        local deslocamento = 0
        local d_t="0"

        if parametros.tamanho >= 2 then
          d_t = parametros[2]
          deslocamento = tonumber(d_t)
        end

--print("Deslocamento:"..dump(tostring(deslocamento)))
        local np= {}
        DOM_copia_ponto(jp,np)
        np.y = np.y + deslocamento
--DOM_inspeciona("Aceleração:",dump(j:getacceleration()))
        j:moveto(np,true)
        j:setacceleration({x=0, y=0, z=0})

--        j:moveto(jp,true)
      elseif comando == "copiar" then
        local nome_local = "blablabla"
        local p_local={}
        local v_local={}

        if parametros.tamanho == 8 then
          v_local[1] = {}
          v_local[1].x = tonumber(parametros[2])
          v_local[1].y = tonumber(parametros[3])
          v_local[1].z = tonumber(parametros[4])

          v_local[2] = {}
          v_local[2].x = tonumber(parametros[5])
          v_local[2].y = tonumber(parametros[6])
          v_local[2].z = tonumber(parametros[7])

          nome_local = parametros[8]
        elseif parametros.tamanho == 4 then -- Todas as coordenadas na forma dos nomes dos pontos.
          p_local[1] = tonumber(string.sub(parametros[2],2))
          p_local[2] = tonumber(string.sub(parametros[3],2))
DOM_inspeciona("Valores:",p_local)
          
          if domb.p[p1_local] == nil or domb.p[p2_local] == nil then
            return
          end 
          for a=1,2,1 do
            v_local[a].x = domb.p[p_local[a]].x
            v_local[a].y = domb.p[p_local[a]].y
            v_local[a].z = domb.p[p_local[a]].z
          end

          nome_local = parametros[4]
        elseif domb.p[1] ~= nil and  domb.p[2] ~= nil and parametros.tamanho == 2 then
          v_local[1] = {}
          v_local[1].x = domb.p[1].x
          v_local[1].y = domb.p[1].y
          v_local[1].z = domb.p[1].z

          v_local[2] = {}
          v_local[2].x = domb.p[2].x
          v_local[2].y = domb.p[2].y
          v_local[2].z = domb.p[2].z

          nome_local = parametros[2]
        else
          return
        end

        DOM_copia_construcao(nome_local,{x=v_local[1].x,y=v_local[1].y,z=v_local[1].z},{x=v_local[2].x,y=v_local[2].y,z=v_local[2].z},"")
      elseif comando == "colar" then
        local nome_local = "blablabla"
--        DOM_cola_construcao("blablabla",{x=-838,y=5,z=-216})
--          DOM_cola_construcao("objeto1",{x=-830,y=2,z=-196})

        if parametros.tamanho == 5 then
          x_local = tonumber(parametros[2])
          y_local = tonumber(parametros[3])
          z_local = tonumber(parametros[4])

          nome_local = parametros[5]
        elseif parametros.tamanho == 3 then -- Todas as coordenadas na forma dos nomes dos pontos.
          p_local = tonumber(string.sub(parametros[2],2))
          
          if domb.p[p_local] == nil then
            return
          end 

          x_local = domb.p[p_local].x
          y_local = domb.p[p_local].y
          z_local = domb.p[p_local].z

          nome_local = parametros[3]
        elseif domb.p[1] ~= nil and tamanho == 2 then
          x_local = domb.p[1].x
          y_local = domb.p[1].y
          z_local = domb.p[1].z

          nome_local = parametros[2]
        else
          return
        end
       
        DOM_cola_construcao(nome_local,{x=x_local,y=y_local,z=z_local})
      elseif comando == "limpar" then
        local p_local={}

        if parametros.tamanho == 7 then -- Todas as coordenadas
          x_local[1] = tonumber(parametros[2])
          y_local[1] = tonumber(parametros[3])
          z_local[1] = tonumber(parametros[4])

          x_local[2] = tonumber(parametros[5])
          y_local[2] = tonumber(parametros[6])
          z_local[2] = tonumber(parametros[7])
        elseif parametros.tamanho == 3 then -- Todas as coordenadas na forma dos nomes dos pontos.
          p_local[1] = tonumber(string.sub(parametros[2],2))
          p_local[2] = tonumber(string.sub(parametros[3],2))
          
          if domb.p[p1_local] == nil or domb.p[p2_local] == nil then
            return
          end 
          for a=1,2,1 do
            x_local[a] = domb.p[p_local[a]].x
            y_local[a] = domb.p[p_local[a]].y
            z_local[a] = domb.p[p_local[a]].z
          end
        elseif domb.p[1] ~= nil and  domb.p[2] ~= nil then -- Sem coordenadas porém com os pontos memorizados.
          x_local[1] = domb.p[1].x
          y_local[1] = domb.p[1].y
          z_local[1] = domb.p[1].z

          x_local[2] = domb.p[2].x
          y_local[2] = domb.p[2].y
          z_local[2] = domb.p[2].z
        else
          return
        end

        DOM_preenche_area({x=x_local[1],y=y_local[1],z=z_local[1]},{x=x_local[2],y=y_local[2],z=z_local[2]},"air")
      elseif comando == "c_p" then -- Testes copia e cola para o modo de teste.
        DOM_preenche_area({x=-830,y=2,z=-194},{x=-821,y=10,z=-198},"air")
        DOM_copia_construcao2("objeto1",{x=-840,y=2,z=-196},{x=-834,y=9,z=-196},"")
        DOM_cola_construcao2("objeto1",{x=-830,y=2,z=-196})
      elseif comando == "m1" or comando == "m2" or comando == "m3" or comando == "m4" then -- Memoriza um ponto
        local posicao = tonumber(string.sub(comando,2))

        local cp_x=nil
        local cp_y=nil
        local cp_z=nil

        if parametros.tamanho == 4 then
          cp_x=tonumber(parametros[2])
          cp_y=tonumber(parametros[3])
          cp_z=tonumber(parametros[4])
        else
          cp_x=math.floor(jp.x)
          cp_y=math.floor(jp.y)
          cp_z=math.floor(jp.z)
        end

        domb.p[posicao] = {x=cp_x,y=cp_y,z=cp_z}
      elseif comando == "limpa_pontos" then -- Limpa os quatro pontos.
        domb.p = {}
      elseif comando == "lista_pontos" then -- Lista os quatro pontos.
        minetest.chat_send_player(jn, "Pontos memorizados: " .. dump(domb.p))
      end
     end
  })
end

--[[
  Quebra texto em lista utilizando espaços como delimitadores.
--]]
function DOM_quebra_texto_em_lista (texto)
  local lista = {}

  lista = DOM_quebra_texto_em_lista_por_delimitador (texto, " ")

  return lista
end

--[[
  Quebra texto em lista utilizando delimitador pedido.
--]]
function DOM_quebra_texto_em_lista_por_delimitador (texto, delimitador)
  local lista = {}
  lista.tamanho = 0
  local t = ""
  local fatia = ""
  
  if texto==nil or texto =="" then return nil end -- Caso texto recebido não seja válido retorna nulo
  if delimitador==nil or delimitador =="" then return nil end -- Caso delimitador recebido não seja válido retorna nulo

--print("Texto: \'"..dump(texto).."\'")
  t = texto 
  if not t:find(delimitador) then  -- Cria lista com um item caso não seja encontrado nenhum delimitador.
    table.insert(lista, t)
    lista.tamanho = 1
  end
 
  while t:find(delimitador) do -- Enquanto o delimitador puder ser encontrado no texto, fica no laço.
    fatia = t:sub(1,t:find(delimitador)-1)
    table.insert(lista,fatia)
    lista.tamanho= lista.tamanho + 1

    t = t:sub(t:find(delimitador)+1)

    if not t:find(delimitador) then -- Adiciona o item que sobra ao final após o último delimitador ser removido.
      table.insert(lista,t)
      lista.tamanho= lista.tamanho + 1
    end
  end

--print("saída: "..dump(table.tamanho).." => "..dump(table))
  return lista
end

--[[
  Copia ponto evitando que seja passada matriz por referência
--]]
function DOM_copia_ponto(origem,destino)
--DOM_inspeciona("Copia ponto:",origem,destino)
  if destino == nil then
    destino = {}
  end

  destino.x = tonumber(origem.x)
  destino.y = tonumber(origem.y)
  destino.z = tonumber(origem.z)

  return destino
end

-- Pega valores meta de um item, provavelmente se aplica a nodos.
function DOM_get_item_meta (item)
  local r = {}
  local v = item["metadata"]

  if v==nil then
    return r
  end

  if string.find(v,"return {") then
    r = minetest.deserialize(v)
  end

  return r
end

-- Associa valores meta a um item, provavelmente se aplica a nodos.
function DOM_set_item_meta(i, v)
  local t = minetest.serialize(v)

  i["metadata"]=t
end

-- Copia objetos entre duas coordenadas que formam um cubo, dentro de uma lista de blocos aceitos para um local de armazenamento.
-- Retorno o ponto central da base do objeto, para referência na hora de contruir.
function DOM_copia_construcao(nome, ponto1,ponto2,blocos)
  local mapa={}

  local p1={x=ponto1.x,y=ponto1.y,z=ponto1.z}
  local p2={x=ponto2.x,y=ponto2.y,z=ponto2.z}
  local pi={x=p1.x,y=p1.y,z=p1.z}

  local arq = minetest.get_modpath("domb") .."/maps/"..nome.."-constr-sav.txt"

  -- Caso o ponto 2 tenha menores valores em x, y ou z os valores serão trocados.
  if p1.x > p2.x then
    pi.x = p2.x
  end
  if p1.y > p2.y then
    pi.y = p2.y
  end
  if p1.z > p2.z then
    pi.z = p2.z
  end

  local x=0
  local y=0
  local z=0
  local posicao =1
  local vx=1
  local vy=1
  local vz=1

  if p1.x > p2.x then vx=-1 end
  if p1.y > p2.y then vy=-1 end
  if p1.z > p2.z then vz=-1 end

  for x=p1.x,p2.x,vx do
    for y=p1.y,p2.y,vy do
      for z=p1.z,p2.z,vz do
        local o = (minetest.env:get_node({x=x, y=y, z=z}))
        local meta =  minetest.env:get_meta({x=x, y=y, z=z})

        m = DOM_meta_para_tabela(meta)
--        m = meta:to_table()
        if o.name ~= "ignore" and o.name ~= "air" then
          mapa[posicao] = {}
          mapa[posicao].x = x-pi.x
          mapa[posicao].y = y-pi.y
          mapa[posicao].z = z-pi.z
          mapa[posicao].o = o
          mapa[posicao].m = m
          posicao = posicao + 1
        end       
      end
    end
  end

  domb_mapa = mapa

  --Write the file, if is possible.
  a, error = io.open(arq, "w")
  if error then return error end
  a:write(minetest.serialize(mapa))

  return pi
end

-- Cola objeto copiado a partir do ponto inicial
function DOM_cola_construcao(nome, ponto_inicial)
  local pi = {x=ponto_inicial.x,y=ponto_inicial.y,z=ponto_inicial.z}
  local tipo = "air"
  local arq = minetest.get_modpath("domb") .."/maps/"..nome.."-constr-sav.txt"
  local mapa = nil

  --Carga do arquivo.
  a, error = io.open(arq, "r")
  if error then return error end
  mapa_ = a:read("*a")
  a:close()


  mapa = minetest.deserialize(mapa_)
if mapa ~= nil then 
tamanho_mapa = #(mapa) 
else
tamanho_mapa = 0
end

DOM_inspeciona("Mapa:",mapa_,mapa, tamanho_mapa)


if mapa == nil then return end

  domb_mapa = mapa
  local tamanho = #(mapa)

  for p=1,tamanho do
    if mapa[p] ~= nil then
      if mapa[p].o ~= nil then
        tipo = mapa[p].o
        posicao = {x=mapa[p].x+pi.x,y=mapa[p].y+pi.y,z=mapa[p].z+pi.z}
        minetest.env:add_node(posicao, tipo)
        meta = minetest.env:get_meta(posicao)
        DOM_tabela_para_meta((mapa[p].m),meta)
--        if m.inventory ~= nil then
--          meta:from_table(m)
--        end
      end
    end
  end
end

-- Preenche completamente uma area com material passado.
function DOM_preenche_area(ponto1,ponto2,material)
  local p1={x=ponto1.x,y=ponto1.y,z=ponto1.z}
  local p2={x=ponto2.x,y=ponto2.y,z=ponto2.z}

  local x=0
  local y=0
  local z=0
  local vx=1
  local vy=1
  local vz=1

  if p1.x > p2.x then vx=-1 end
  if p1.y > p2.y then vy=-1 end
  if p1.z > p2.z then vz=-1 end

  for x=p1.x,p2.x,vx do
    for y=p1.y,p2.y,vy do
      for z=p1.z,p2.z,vz do
        minetest.env:set_node({x=x, y=y, z=z},{name=material})
      end
    end
  end
end

function DOM_meta_para_tabela(meta)
--  if type(meta) ~= "userdata" then
--    return(meta)
--  end

  local retorno ={}
  local t_r = meta:to_table()
  local t = {}

  if t_r.inventory ~= nil then
    i = t_r.inventory

    if i.main ~= nil then
      local contagem =1
      t.inventory = {}
      t.inventory.main = {} 
      
      for contagem=1,#(i.main),1 do
        interno = i.main[contagem]:to_table()
  
        t.inventory.main[tostring(contagem)] = interno
      end

    end

    if i.fields ~= nil then
      i.inventory.fields = {}
      t.inventory.fields = i.fields:to_table()
    end
  end

  retorno = t
  return retorno
end

function DOM_tabela_para_meta(t,meta)
--  if type(meta) ~= "userdata" then
--    return(meta)
--  end
--  DOM_inspeciona("Tipo recebido:",type(meta),type(t))

  local retorno ={}
  local t_r = meta:to_table()
 
  if t.inventory ~= nil then
--DOM_inspeciona_r("Ponto")
    t_r.inventory = {}
    i = t_r.inventory

    if t.inventory.main ~= nil then
--DOM_inspeciona_r("Ponto")
      i.main = {} 
      local contagem =1
      
      for contagem=1,#(i.main),1 do
        i.main[contagem]:from_table(t.inventory.main[contagem])
      end
    end

    if t.inventory.fields ~= nil then
--DOM_inspeciona_r("Ponto")
--      i.fields = {}
      i.fields = t.inventory.fields
    end
  end

  return
end
