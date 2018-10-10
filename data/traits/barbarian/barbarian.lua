
local Barbarian = class()

local log = radiant.log.create_logger('kai')
function Barbarian:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function Barbarian:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
end

function Barbarian:post_activate()
   local json = radiant.resources.load_json(self._sv._uri)
   local population = stonehearth.population:get_population(self._sv._entity:get_player_id())

   self:don_outfit()

   self._job_changed_listener = radiant.events.listen(self._sv._entity, 'stonehearth:job_changed', self, self.don_outfit)

   self.pop_listener = radiant.events.listen_once(population, 'stonehearth:population:citizen_count_changed', function()
      if not self._sv._entity:get_component('stonehearth:unit_info')._sv._made_barbarian then
         local options = {}
         options.dont_drop_talisman = true
         options.skip_visual_effects = true
         local able_to_be_footman = pcall(function()
           self._sv._entity:get_component('stonehearth:job'):promote_to('stonehearth:jobs:footman', options)
         end)
         local all_jobs = stonehearth.player:get_jobs(self._sv._entity:get_player_id())
         local allowed_jobs = {}
         for job_uri, _ in pairs(all_jobs) do
            allowed_jobs[job_uri] = true
         end
         self._sv._entity:get_component('stonehearth:job')._sv.allowed_jobs = allowed_jobs
         self._sv._entity:get_component('stonehearth:job')._sv.allowed_jobs["stonehearth:jobs:knight"] = false
         self._sv._entity:get_component('stonehearth:unit_info')._sv._made_barbarian = true
         self:don_outfit()
      end
   end)

end

function Barbarian:don_outfit()
   self._sv._entity:get_component('stonehearth:equipment'):equip_item('kmnky_traits:traits:barbarian_outfit')
end

function Barbarian:destroy()
   self._sv._entity:get_component('stonehearth:equipment'):equip_item('kmnky_traits:traits:barbarian_outfit')

   self._sv._entity:get_component("stonehearth:job"):_equip_equipment(self._sv._entity:get_component("stonehearth:job")._job_json)
   self.pop_listener:destroy()
   self._job_changed_listener:destroy()
end

local EquipmentPieceComponent = radiant.mods.require("stonehearth.components.equipment_piece.equipment_piece_component")
if EquipmentPieceComponent and not EquipmentPieceComponent.kmnky_traits_injection2 then
   local old_EquipmentPieceComponent_is_upgrade_for = EquipmentPieceComponent.is_upgrade_for
   function EquipmentPieceComponent:is_upgrade_for(unit)
      local slot = self:get_slot()
      if unit:get_component('stonehearth:unit_info') and unit:get_component('stonehearth:unit_info')._sv._made_barbarian and slot ~= "mainhand" then
         return false
      else
         return old_EquipmentPieceComponent_is_upgrade_for(self, unit)
      end
   end

    EquipmentPieceComponent.kmnky_traits_injection2 = true
end

return Barbarian
