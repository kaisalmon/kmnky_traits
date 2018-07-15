local Scarred = class()

local log = radiant.log.create_logger('kai')
function Scarred:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function Scarred:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
   self._add_scar = true
end

function Scarred:post_activate()
   local json = radiant.resources.load_json(self._sv._uri)

   -- Add scar asset on creation
   local customization = json.data.customization
   self._subcategory = customization.subcategory
   self._style = customization.style
   if self._add_scar then
      self:_add_scar_customization()
   end
   radiant.entities.add_thought(self._sv._entity, 'stonehearth:thoughts:traits:disfigured')
end

function Scarred:destroy()

   self:_remove_scar_customization()
   radiant.entities.remove_thought(self._sv._entity, 'stonehearth:thoughts:traits:disfigured')
end


function Scarred:_add_scar_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization(self._subcategory, self._style)
end

function Scarred:_remove_scar_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization(self._subcategory, nil)
end

if GameCreationService and not GameCreationService.kmnky_traits_injection then
   local old_randomize_citizen = GameCreationService._randomize_citizen

   function GameCreationService:_randomize_citizen(citizen, pop, gender, locked_options)
      old_randomize_citizen(self, citizen, pop, gender, locked_options)
      pop:regenerate_stats(citizen, { embarking = true })
   end
   GameCreationService.kmnky_traits_injection = true
end

return Scarred
