--[[
  DOM:Craft Guide for Mineteste - Rewrite (CGMR)
  
  The original code of the "Craft Guide for Minetest" is from cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-craft_guide, License: GPLv3

  Version: 1.0 (20130418)
]]--

-- Rotinas
dofile(minetest.get_modpath("cgmr").."/rotinas.lua")

-- Bibliotecas
dofile(minetest.get_modpath("cgmr").."/itens.lua")

cgmr.carrega_lista_de_itens()

-- Apenas para indicar que este módulo foi completamente carregado.
DOM_mb(minetest.get_current_modname(),minetest.get_modpath(minetest.get_current_modname()))
