local noble = class()
local INVESTMENT = 300
local log = radiant.log.create_logger('kai')
function noble:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function noble:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
   self._add_glasses = true
end

function noble:post_activate()
   local json = radiant.resources.load_json(self._sv._uri)

   -- Add glasses asset on creation

   if self._add_glasses then
      self:_add_glasses_customization()
   end

   local population = stonehearth.population:get_population(self._sv._entity:get_player_id())
   self.pop_listener = radiant.events.listen(population, 'stonehearth:population:citizen_count_changed', function()
   if not self._sv._entity:get_component('stonehearth:unit_info')._sv._added_noble_gold then
      local player_id = self._sv._entity:get_player_id()
      local from_inventory = stonehearth.inventory:get_inventory(player_id)
      --pcall(function()
            from_inventory:add_gold(INVESTMENT)
            local str =  radiant.entities.get_custom_name(self._sv._entity) .. " made a donation of " .. INVESTMENT .. " gold pieces to the town treasury!"
            local options = {
            }
            population:show_notification_for_citizen(self._sv._entity, str)
            self._sv._entity:get_component('stonehearth:unit_info')._sv._added_noble_gold = true
            self.pop_listener:destroy()
         --end)
      end
   end)
   
end

function noble:destroy()

   self:_remove_glasses_customization()

    
   self.pop_listener:destroy()
end


function noble:_add_glasses_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("eyebrows", "noble")
end

function noble:_remove_glasses_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("eyebrows", nil)
end

if GameCreationService and not GameCreationService.kmnky_traits_injection then
   local old_randomize_citizen = GameCreationService._randomize_citizen

   function GameCreationService:_randomize_citizen(citizen, pop, gender, locked_options)
      old_randomize_citizen(self, citizen, pop, gender, locked_options)
      pop:regenerate_stats(citizen, { embarking = true })
   end
   GameCreationService.kmnky_traits_injection = true
end

return noble
