local martial_trained = class()
local log = radiant.log.create_logger('kai')
function martial_trained:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function martial_trained:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
end

function martial_trained:post_activate()
    self._sv._entity:get_component('stonehearth:unit_info')._sv._can_equip_any_weapon = true
end

function martial_trained:destroy()
    self._sv._entity:get_component('stonehearth:unit_info')._sv._can_equip_any_weapon = nil
end


local EquipmentPieceComponent = radiant.mods.require("stonehearth.components.equipment_piece.equipment_piece_component")
if EquipmentPieceComponent and not EquipmentPieceComponent.kmnky_traits_injection then
   local old_EquipmentPieceComponent_is_upgrade_for = EquipmentPieceComponent.is_upgrade_for
   function EquipmentPieceComponent:is_upgrade_for(unit)
      local slot = self:get_slot()
      if unit:get_component('stonehearth:unit_info') and unit:get_component('stonehearth:unit_info')._sv._can_equip_any_weapon and slot == "mainhand" then
         -- upgradable items have a slot.  if there's not slot (e.g. the job outfits that
         -- just contain abilities), there's no possibility for upgrade
        
         -- if the unit can't wear equipment, obviously not an upgrade!  similarly, if the
         -- unit has no job, we can't figure out if it can wear this
         local equipment_component = unit:get_component('stonehearth:equipment')
         local job_component = unit:get_component('stonehearth:job')
         if not equipment_component or not job_component then
            return false
         end
         -- if we're not better than what's currently equipped, bail
         local equipped = equipment_component:get_item_in_slot(slot)
         if equipped and equipped:is_valid() then
            local current_ilevel = equipped:get_component('stonehearth:equipment_piece'):get_ilevel()
            if current_ilevel < 0 or current_ilevel >= self:get_ilevel() then
               -- if current ilevel is < 0, that means the item is not unequippable. It's linked to another item
               return false
            end
         end

         -- finally!!!  this is good.  use it!
         return true
      else
         return old_EquipmentPieceComponent_is_upgrade_for(self, unit)
      end
   end

    EquipmentPieceComponent.kmnky_traits_injection = true
end

return martial_trained
