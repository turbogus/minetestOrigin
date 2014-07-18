-- Copia objetos entre duas coordenadas que formam um cubo, dentro de uma lista de blocos aceitos para um local de armazenamento.
-- Retorno o ponto central da base do objeto, para referência na hora de contruir.
function DOM_copia_construcao2(nome, ponto1,ponto2,blocos)
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
--if meta ~= nil then
--DOM_inspeciona("Meta lido:",meta:to_table())
--end

  m = DOM_meta_para_tabela(meta)
--  m=debug.getmetatable(meta)
        if o.name ~= "ignore" and o.name ~= "air" then
          mapa[posicao] = {}
          mapa[posicao].x = x-pi.x
          mapa[posicao].y = y-pi.y
          mapa[posicao].z = z-pi.z
          mapa[posicao].o = o
          mapa[posicao].m = m
          posicao = posicao + 1
--          DOM_inspeciona_r("Ponto:"..tostring(x)..","..tostring(y)..","..tostring(z),o.name)
        end       
      end
    end
  end


  --Write the file, if is possible.
  a, error = io.open(arq, "w")
  if error then return error end
  a:write(minetest.serialize(mapa))
--  a:write(dump(mapa))
--  a:close()

--  a, error = io.open(arq.."3", "w")
--  if error then return error end
--  d=tostring(mapa)

--  a:write(d)
--  a:write(mapa)
--  a:close()
  domb_mapa = mapa

  return pi
end

-- Cola objeto copiado a partir do ponto inicial
function DOM_cola_construcao2(nome, ponto_inicial)
  local pi = {x=ponto_inicial.x,y=ponto_inicial.y,z=ponto_inicial.z}
  local tipo = "air"
  local arq = minetest.get_modpath("domb") .."/maps/"..nome.."-constr-sav.txt"

  --Read the file, if is found.
  a, error = io.open(arq, "r")
  if error then return error end
--  local mapa = domb_mapa
--  local mapa = (a:read("*a"))
local mapa = minetest.deserialize(a:read("*a"))
--  local m = a:read("*a")
  a:close()

--DOM_inspeciona("Mapa: ",mapa)
  local tamanho = #(mapa)

  for p=1,tamanho do
    if mapa[p] ~= nil then
      if mapa[p].o ~= nil then
        tipo = mapa[p].o
--        meta = minetest.deserialize(mapa[p].m)
        m = dom_m.stringtotable(mapa[p].m)
        posicao = {x=mapa[p].x+pi.x,y=mapa[p].y+pi.y,z=mapa[p].z+pi.z}
        minetest.env:add_node(posicao, tipo)
        meta = minetest.env:get_meta(posicao)
--if m.inventory ~= nil then
--DOM_inspeciona("Meta lido:",type(m),type(m.inventory),type(m.inventory.main))
--DOM_inspeciona("Meta lido:",m,debug.getmetatable(m))
--end
        if m.inventory ~= nil then
--DOM_inspeciona_r("Carga de meta teórica.",m.inventory)
--          meta:from_table(minetest.deserialize(m.inventory))
--DOM_inspeciona_r(debug.getmetatable(m))
          meta:from_table(m)
--          meta:from_table(m)
        end
      end
    end
  end
end
