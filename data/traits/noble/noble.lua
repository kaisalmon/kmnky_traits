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

   self._job_changed_listener = radiant.events.listen(self._sv._entity, 'stonehearth:job_changed', self, self._adjust_thought)

   local population = stonehearth.population:get_population(self._sv._entity:get_player_id())
   self.pop_listener = radiant.events.listen(population, 'stonehearth:population:citizen_count_changed', function()
   if not self._sv._entity:get_component('stonehearth:unit_info')._sv._added_noble_gold then
      local player_id = self._sv._entity:get_player_id()
      local from_inventory = stonehearth.inventory:get_inventory(player_id)
         pcall(function()
            from_inventory:add_gold(INVESTMENT)
            local str =  radiant.entities.get_custom_name(self._sv._entity) .. " made a donation of " .. INVESTMENT .. " gold pieces to the town treasury!"
            local options = {
            }
            population:show_notification_for_citizen(self._sv._entity, str)
            self._sv._entity:get_component('stonehearth:unit_info')._sv._added_noble_gold = true
            self.pop_listener:destroy()
            self:_adjust_thought()
         end)
      end
   end)
   self:_adjust_thought()
end

function noble:destroy()

   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("eyebrows", nil)

   if self._job_changed_listener then
      self._job_changed_listener:destroy()
      self._job_changed_listener = nil
   end
   self.pop_listener:destroy()
   radiant.entities.remove_thought(self._sv._entity, 'stonehearth:thoughts:traits:job_beneath_me')
end


function noble:_add_glasses_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("eyebrows", "noble")
end



function noble:_adjust_thought()
   -- grab the job component
   local job_component = self._sv._entity:get_component('stonehearth:job')
   local job_uri = job_component and job_component:get_job_uri()

   if not job_uri  then
      return
   end

   if job_uri == 'stonehearth:jobs:farmer' or job_uri == 'stonehearth:jobs:worker' or job_uri == 'stonehearth:jobs:trapper'  or job_uri == 'stonehearth:jobs:shepard' or job_uri == 'stonehearth:jobs:footman' then
      radiant.entities.add_thought(self._sv._entity, 'stonehearth:thoughts:traits:job_beneath_me')
   else
      radiant.entities.remove_thought(self._sv._entity, 'stonehearth:thoughts:traits:job_beneath_me')
   end
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
